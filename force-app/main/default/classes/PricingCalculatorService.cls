/*************************************************************
@Name: PricingCalculatorService
@Author: CJ Fabiano, Slalom
@CreateDate: 3/04/2019
@Description: This class holds business logic for the Opportunity Directional Pricing Calculator. It is invoked
from BEFORE INSERT and BEFORE UPDATE trigger on Pricing Caclulator object. It handles the calculation logic, calculation sequence & dependencies,
and specialized Rounding logic. This logic was implemented in APEX due to the quantity of field calculations, inter-dependencies
and Process Builder / Formula fields were reaching max Compute Size of 5,000 bytes.
@See: PricingCalculatorTriggerHandler.cls

NOTE -- Site__c table has many fields flagged as "Percent" fields so they render with a % sign in UI. When these fiels are retrieved in SOQL, 
        they are not in decimal format. 
        The developer must inspect Salesforce to ensure they properly divide by 100 prior to using the Percent fields. 
        Example: 9% is retrieved as 9.00, not as .09 
        Example: 15% is retrieved as 15.00, not as .15 
        Use method convertToPercentage() to divide by 100
******************************************************************/
public class PricingCalculatorService  {

    //describes which fields are user-supplied Calculator Inputs and should retrigger calculations when edited.
    //Note: Used in PricingCalculatorTriggerHandler
    public static final List<String> CALCULATOR_INPUTS = new List<String>{'Site__c', 
        'Agent_Profile__c',
        'AHT__c',
        'FTE__c',
        'Services__c',
        'Hours_of_Operation__c',
        'Training_Length__c', 
        'Training_Billable__c',
        'ApplyPremiumWage__c'};

    
   //global variable PNXT-1760 043019 UpchragePerMin__c
   static PricingCalculatorConfig__mdt config = [select id, QualifiedApiName, 
        UpchargePayrollHour__c, UpchargePerMin__c, UpchargePerTran__c, UpchargeProdHour__c 
        from PricingCalculatorConfig__mdt
        where QualifiedApiName = 'Default' LIMIT 1];
   
    /** MAIN ENTRY point from Trigger Handler to calculate prices for up to 200 calculators.
     *  @param List<PricingCalculator__c> rows - sent from TriggerHandler and represent trigger.new list.
     *  @assumption - Assumed invoked from a BEFORE event and that no explicit DML is needed to persist calculations.
     */
    public static void recalculatePrices(List<PricingCalculator__c> rows) {

        //Short-circuit
        if (rows == null || rows.size() == 0) { return; }

        //Get all dependent Sites in a single SOQL for bulkification.
        Set<Id> siteIds = SObjectUtility.getIdsFromList('Site__c', rows);
        Map<Id, Site__c> sitesRefMap = AloricaSiteDAO.getSitesMapByIds(siteIds);

        //Validate the single Metadata record was found correctly, else throw error.
        if (config == null) {
            throw new PricingCalculatorException('No Pricing Calculator Configuration record was found in metadata. Please give this error to your administrator.');
        }

        //(Re-)Calculate each row using retrieved Site
        for (PricingCalculator__c pc : rows) {
            
            //Null pointer prevention
            if (pc != null && pc.Site__c != null && sitesRefMap.containsKey(pc.Site__c)) {

                Site__c s = sitesRefMap.get(pc.Site__c);    
                recalcSingle(pc, s);
            }
        }
    } 

    /** Rounds a value to the nearest 10^X place.
     *  @param Decimal value - the value to be rounded
     *  @param Double tenToXpower - raise 10 to the tenToXpower to signify rounding to nearest 100, 1000, 10000, 100000, etc.
     *  
     *  Example: to round value to nearest Hundred Thousand, supply tenToXpower = 5.0 because (10 to the 5th) = 100,000
     *  Note: Should not be used for decimal place rounding (like nearest hundredth, thousandth, etc.) Only use for left-of-decimal rounding.
     */
    public static Decimal roundToPowerOfTen(Decimal value, Double tenToXpower) {
        
        System.debug('in roundToPowerOfTen: ' + value);
        Double tmp = value;
        Double tenDouble = 10.0;
        Decimal divisor = System.Math.pow(tenDouble, tenToXpower);  
        System.debug('divisor: ' + divisor);
            
        if (value > divisor * 10) {             
            tmp = value / divisor;
            System.debug('Value / divisor = ' + tmp);
            tmp = Math.round(tmp);
            tmp = tmp * divisor;
        }           
        System.debug('roundToPowerOfTen result: ' + tmp);
        return tmp;
    }

    /** Rounds a value UP to the nearest .50 cents.
     *  @param Decimal value - the value to be rounded
     */
    public static Decimal roundUpFiftyCents(Decimal value) {

        Decimal numeral = value.round(System.RoundingMode.DOWN); //drops the decimal placed to get to a whole number
        Decimal decPortion = value - numeral;

        if (decPortion == 0) {
            //nothing to round
        } else if (decPortion > .50) {
            decPortion = 0.0;
            numeral += 1.0;
        } else {
            //decPortion is < .50 && > 0
            decPortion = 0.50;
        }
        return (numeral + decPortion);
    }

    
    /** Recalculation for a single PricingCalculator record.
     *  @param PricingCalculator__c pc: the calculator record to perform calculations.
     *  @param Site__c s: is the site record that has already been queried with all dependent fields
     */
    private static void recalcSingle(PricingCalculator__c pc, Site__c s) {
        
        //Instantiate a helper class to do the calculations in case we need to use instance variables to hold values
        //during inter-dependent field calculations.
        try {

            CalculatorHelper helper = new CalculatorHelper(pc, s);      
            helper.calculate();

        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'An issue occurred calculating Pricing Calculator: ' + e.getMessage());
            System.debug(pc);
            //Ignore for now until further requirements.
        }       
    }


    //*************** Inner Helper Class ***********************

    public class CalculatorHelper {
        
        //easy access
        private PricingCalculator__c pc;
        private Site__c s;
    
        //constructors
        public CalculatorHelper() {}
        public CalculatorHelper(PricingCalculator__c row, Site__c siteRef) {
            pc = row;
            s = siteRef;
        }
        //log inputs
        private void logInputs() {
            System.debug(LoggingLevel.INFO, '::::::::::::: INPUTS');
            System.debug(LoggingLevel.INFO, 'Site: ' + s.Name);
            System.debug(LoggingLevel.INFO, 'Directional Services: ' + pc.Services__c);
            System.debug(LoggingLevel.INFO, 'AHT: ' + pc.AHT__c);
            System.debug(LoggingLevel.INFO, 'Agent Profile: ' + pc.Agent_Profile__c);
            System.debug(LoggingLevel.INFO, 'FTE: ' + pc.FTE__c);
            System.debug(LoggingLevel.INFO, 'Hours of Operation: ' + pc.Hours_of_Operation__c);
            System.debug(LoggingLevel.INFO, 'Training Length: ' + pc.Training_Length__c);
            System.debug(LoggingLevel.INFO, 'Training Billable: ' + pc.Training_Billable__c);
            System.debug(LoggingLevel.INFO, '::::::::::::: END INPUTS');
        }

        //MAIN - main entry
        public void calculate() {

            //validate & short-circuit
            if (pc == null || s == null) {
                System.debug(LoggingLevel.ERROR, 'PricingCalculatorHelper.calculate() method is missing Site record or PricingCalculator record.');
                return;
            }

            //Log inputs for easy troubleshooting       
            logInputs();
            
            //Fields that are based only on Inputs & Site fields. Highly depended upon down-stream.
            calcMostDependentFields();
            
            //Seats - which many other downstream calculations rely on as well. Dependent on calcMostDependentFields()
            calcAgentSeatsSection();

            //Costs
            calculateDirectCostsSection();      
            
            //Regional Opex Costs
            calcRegionalOpexCosts();

            //Corp SGA Costs
            calcCorpSGACostsSection();

            //Production, Training and Total Revenues
            calcRevenues();

            //Rates Section
            calcRatesSection();

            //Apply roundings to BID Rates and Total Revenue, etc.
            applyRoundings();
            
            //Clone the Site__c fields in PricingCalculator__c - PNXT-1760 ArielTribunal
            cloneSiteFields();
        }

        //Clone Site fields values - PNXT-1760 ArielTribunal
        private void cloneSiteFields() {
            
            //Clone the values from the Site__c
            pc.GP__c = s.GP__c;
            pc.Target_EBITDA__c = s.Target_EBITDA__c;
        }
        
        private void applyRoundings() {

            //Payroll - up by .50 increments
            pc.Payroll_Base_Rate__c = PricingCalculatorService.roundUpFiftyCents(pc.Payroll_Base_Rate__c);
            pc.Payroll_BID_Rate__c = PricingCalculatorService.roundUpFiftyCents(pc.Payroll_BID_Rate__c);
            pc.Payroll_BID_Rate_High__c = PricingCalculatorService.roundUpFiftyCents(pc.Payroll_BID_Rate_High__c);

            //Production - up by .50 increments
            pc.Productive_Base_Rate__c = PricingCalculatorService.roundUpFiftyCents(pc.Productive_Base_Rate__c);
            pc.Productive_BID_Rate__c = PricingCalculatorService.roundUpFiftyCents(pc.Productive_BID_Rate__c);
            pc.Productive_BID_Rate_High__c = PricingCalculatorService.roundUpFiftyCents(pc.Productive_BID_Rate_High__c);

            //Per Minute
            pc.Per_Min_Base_Rate__c = Math.ceil((pc.Per_Min_Base_Rate__c * 100)) / 100;
            pc.Per_Min_BID_Rate__c = Math.ceil((pc.Per_Min_BID_Rate__c * 100)) / 100;
            pc.Per_Min_BID_Rate_High__c = Math.ceil((pc.Per_Min_BID_Rate_High__c * 100)) / 100;

            //Per Transaction roundUpFiftyCents
            pc.Transaction_Base_Rate__c = PricingCalculatorService.roundUpFiftyCents(10 * pc.Transaction_Base_Rate__c) / 10;
            pc.Transaction_BID_Rate__c = PricingCalculatorService.roundUpFiftyCents(10 * pc.Transaction_BID_Rate__c) / 10;
            pc.Transaction_BID_Rate_High__c = PricingCalculatorService.roundUpFiftyCents(10 * pc.Transaction_BID_Rate_High__c) / 10;

            //Total Revenue
            pc.Total_Revenue__c = PricingCalculatorService.roundToPowerOfTen(pc.Total_Revenue__c, Double.valueOf('5.0'));
        }
        
        private void calcMostDependentFields() {

            //Agent Wage    
            pc.Agent_Wage__c = getAgentWage();

            //Attrition Training Costs
            pc.Attrition_Training_Costs__c = getAttritionTrainingCost();

            //Billable Payroll Hours
            pc.Billable_Payroll_Hours__c = getBillablePayrollHours();

            //Production Hours
            pc.Production_Hours__c = pc.Billable_Payroll_Hours__c - (pc.Billable_Payroll_Hours__c * convertToPercentage(s.Onsite_Shrink__c));
            
            //IT Maintenance
            pc.IT_Maintenance__c = getITMaintenance();

            //Occupancy
            pc.Occupancy__c = getOccupancyPercent();

            //Handle Hours 
            //Handle Minutes
            //Transactions
            pc.Handle_Hours__c = pc.Production_Hours__c - (pc.Production_Hours__c * (1 - convertToPercentage(pc.Occupancy__c)));            
            pc.Handle_Minutes__c = pc.Handle_Hours__c * 60;         
            pc.Transactions__c = (pc.AHT__c == null || pc.AHT__c == 0)  ? 0 : pc.Handle_Minutes__c / (pc.AHT__c / 60);
            
            //Ramp Training Costs
            pc.Ramp_Training_Costs__c = getRampTrainingCosts();

            //Recruiting
            pc.Recruiting__c = getRecruiting();

            //Seat Utilization
            pc.Seat_Utilization__c = getSeatUtilization();
      
        }

        private void calcAgentSeatsSection() {

            //Seat Count
            Decimal agentSeatCount =        (pc.Seat_Utilization__c == null || pc.Seat_Utilization__c == 0) ? 0 : (pc.FTE__c / pc.Seat_Utilization__c);
            Decimal tmSeatCount =           (s.TM_Ratio__c == null || s.TM_Ratio__c == 0) ? 0 : (pc.FTE__c / s.TM_Ratio__c);
                    
            pc.Seat_Count__c                = agentSeatCount.round(System.RoundingMode.UP) + tmSeatCount.round(System.RoundingMode.UP);
            pc.Facililtes_per_Seat__c       = s.Facililtes_Total__c / (s.Total_Seats_in_Site__c / 0.85); // RITM0069355 ArielT 103119
            pc.Site_Payroll_Per_Seat__c     = s.Site_Payroll_Total_Cost__c; // PNXT-1578 ArielT 040419  
            pc.Training_Rate__c             = s.TrainingRate__c;  //PNXT-1760 043019
        }

        private void calculateDirectCostsSection() {
            
            //Agent Wage Cost
                      
            
            pc.Agent_Wage_Cost__c = (pc.Agent_Wage__c * pc.FTE__c) *  s.Annual_Agent_Hours__c *  (1 - convertToPercentage(s.Offsite_Shrink__c));
            System.debug(LoggingLevel.INFO, 'Agent_Wage_Cost__c: ' + pc.Agent_Wage_Cost__c);

            //Agent Incentive Cost
            pc.Agent_Incentive_Cost__c = pc.Agent_Wage__c * pc.FTE__c * pc.Billable_Payroll_Hours__c * convertToPercentage(s.Agent_Incentives__c);
            System.debug(LoggingLevel.INFO, 'Agent_Incentive_Cost__c: ' + pc.Agent_Incentive_Cost__c);

            //Overtime Cost
            pc.Overtime_Cost__c = pc.Agent_Wage__c * pc.FTE__c * pc.Billable_Payroll_Hours__c * convertToPercentage(s.OT_Premium__c);
            System.debug(LoggingLevel.INFO, 'Overtime_Cost__c: ' + pc.Overtime_Cost__c);

            //TM Cost
            Decimal tmWages = (pc.Agent_Wage__c * convertToPercentage(s.TM_Wages__c)) + pc.Agent_Wage__c;
            pc.TM_Cost__c = (s.TM_Ratio__c == null || s.TM_Ratio__c == 0) ? 0 
                : tmWages *
                  (pc.FTE__c / s.TM_Ratio__c).round(System.RoundingMode.UP) * 
                  s.Annual_Agent_Hours__c;
            System.debug(LoggingLevel.INFO, 'TM_Cost__c: ' + pc.TM_Cost__c);

            //TM Incentive Cost
            pc.TM_Incentive_Cost__c = pc.TM_Cost__c * convertToPercentage(s.TM_Incentives__c);
            System.debug(LoggingLevel.INFO, 'TM_Incentive_Cost__c: ' + pc.TM_Incentive_Cost__c);

            //QA Wage Cost
            pc.QA_Wage_Cost__c = (s.QA_Ratio__c == null || s.QA_Ratio__c == 0) 
                ? 0
                : (pc.Agent_Wage__c + s.QA_Wages__c) * ((pc.FTE__c / s.QA_Ratio__c).round(System.RoundingMode.UP) * s.Annual_Agent_Hours__c);
            System.debug(LoggingLevel.INFO, 'QA_Wage_Cost__c: ' + pc.QA_Wage_Cost__c);

            //Trainer Wage Cost
            pc.Trainer_Wage_Cost__c = (s.Trainers_Ratio__c == null || s.Trainers_Ratio__c == 0)
                ? 0
                : s.Annual_Agent_Hours__c * 
                (
                    (
                        (pc.Agent_Wage__c * convertToPercentage(s.TM_Wages__c)) + pc.Agent_Wage__c) *
                        convertToPercentage(s.Trainers_Wages__c) + pc.Agent_Wage__c * convertToPercentage(s.TM_Wages__c) + pc.Agent_Wage__c * (pc.FTE__c / s.Trainers_Ratio__c)
                );
            System.debug(LoggingLevel.INFO, 'Trainer_Wage_Cost__c: ' + pc.Trainer_Wage_Cost__c);

            //Ops Mgmt Cost
            /*
            pc.Ops_Mgmt_Cost__c =  (s.Ops_Managers_Ratio__c == null || s.Ops_Managers_Ratio__c == 0) 
                ? 0
                : ( 
                    s.Annual_Agent_Hours__c *               
                    (
                        (((pc.Agent_Wage__c * convertToPercentage(s.TM_Wages__c)) + pc.Agent_Wage__c) * convertToPercentage(s.Ops_Manager_Wages__c)) + 
                        ((pc.Agent_Wage__c * convertToPercentage(s.TM_Wages__c) + pc.Agent_Wage__c) * (pc.FTE__c / s.Ops_Managers_Ratio__c))
                    ));
            */

            //Ops Wage = (tmWages * convertToPercentage(s.Ops_Manager_Wages__c)) + tmWages;
            Decimal opsWage = (tmWages * convertToPercentage(s.Ops_Manager_Wages__c)) + tmWages;
            Decimal opsRatioRoundedUp = (pc.FTE__c / s.Ops_Managers_Ratio__c).round(System.RoundingMode.UP);
            System.debug('opsWage: ' + opsWage);
            System.debug('opsRatioRoundedUp: ' + opsRatioRoundedUp);

            pc.Ops_Mgmt_Cost__c = opsWage * s.Annual_Agent_Hours__c * opsRatioRoundedUp;
            System.debug(LoggingLevel.INFO, 'Ops_Mgmt_Cost__c: ' + pc.Ops_Mgmt_Cost__c);

            //Ops Mgmt bonus Cost = Ops_Mgmt_Cost__c * Site__r.Ops_Manager_Bonus__c
            pc.Ops_Mgmt_bonus_Cost__c = pc.Ops_Mgmt_Cost__c * convertToPercentage(s.Ops_Manager_Bonus__c);
            System.debug(LoggingLevel.INFO, 'Ops_Mgmt_bonus_Cost__c: ' + pc.Ops_Mgmt_bonus_Cost__c);

            //Tax & Benefits Cost
            pc.Tax_Benefits_Cost__c = 
                (pc.Agent_Wage_Cost__c + 
                pc.Agent_Incentive_Cost__c + 
                pc.Ramp_Training_Costs__c + 
                pc.Attrition_Training_Costs__c + 
                pc.Overtime_Cost__c + 
                pc.TM_Cost__c + 
                pc.TM_Incentive_Cost__c + 
                pc.QA_Wage_Cost__c + 
                pc.Ops_Mgmt_Cost__c + 
                pc.Trainer_Wage_Cost__c + 
                pc.Ops_Mgmt_bonus_Cost__c) * convertToPercentage((s.Tax_and_Benefits__c != null && s.Tax_and_Benefits__c != 0) ? s.Tax_and_Benefits__c : 0);   
            System.debug(LoggingLevel.INFO, 'Tax_Benefits_Cost__c: ' + pc.Tax_Benefits_Cost__c);

            //Gross Profit Cost
            //NOTE: Gross Profit Cost must be last.
            pc.Gross_Profit_Cost__c = pc.Agent_Wage_Cost__c + 
                pc.Agent_Incentive_Cost__c + 
                pc.Ramp_Training_Costs__c + 
                pc.Attrition_Training_Costs__c + 
                pc.Overtime_Cost__c + 
                pc.TM_Cost__c + 
                pc.TM_Incentive_Cost__c + 
                pc.QA_Wage_Cost__c + 
                pc.Ops_Mgmt_Cost__c + 
                pc.Trainer_Wage_Cost__c +
                pc.Ops_Mgmt_bonus_Cost__c + 
                pc.Tax_Benefits_Cost__c;
            System.debug(LoggingLevel.INFO, 'Gross_Profit_Cost__c: ' + pc.Gross_Profit_Cost__c);            
        }

        private void calcRevenues() {
            
            //Total Revenue
            //pc.Total_Revenue__c = pc.Total_Estimated_Cost__c + 
            //  (pc.Total_Estimated_Cost__c * convertToPercentage(s.Target_EBITDA__c));
            Decimal targetEbitdaPct = 1 - convertToPercentage(s.Target_EBITDA__c);
            System.debug(LoggingLevel.INFO, 'targetEbitdaPct: ' + targetEbitdaPct);
            pc.Total_Revenue__c = pc.Total_Estimated_Cost__c / targetEbitdaPct;
            System.debug(LoggingLevel.INFO, 'Total Revenue: ' + pc.Total_Revenue__c);

            //Training Revenue
            pc.Training_Revenue__c = 0;
            if (s.Deal_Years__c != null && s.Deal_Years__c != 0) {
                
                if (pc.Training_Billable__c == 'Yes') {
                    pc.Training_Revenue__c = 
                        (pc.FTE__c * (pc.Training_Length__c / s.Deal_Years__c)) * pc.Training_Rate__c; //PNXT-1760 043019
                }
            }       
            //Production Revenue
            pc.Production_Revenue__c = pc.Total_Revenue__c - pc.Training_Revenue__c;
        }

        private void calcRatesSection() {
            
            //Payroll Base Rate         
            pc.Payroll_Base_Rate__c =  (pc.Billable_Payroll_Hours__c == 0 || pc.FTE__c == 0) 
                ? 0
                : (pc.Production_Revenue__c / (pc.Billable_Payroll_Hours__c * pc.FTE__c ));
            //Payroll BID Rate Low  
            pc.Payroll_BID_Rate__c = pc.Payroll_Base_Rate__c + 
                (pc.Payroll_Base_Rate__c *  convertToPercentage(s.Payment_Terms_Percent__c)) + 
                (pc.Payroll_Base_Rate__c *  convertToPercentage(s.COLA_percent__c));
            //Payroll BID Rate High
            pc.Payroll_BID_Rate_High__c = pc.Payroll_BID_Rate__c + 
                (pc.Payroll_BID_Rate__c * convertToPercentage(config.UpchargePayrollHour__c));
    
            //Per Min Base Rate 
            pc.Per_Min_Base_Rate__c = (pc.Handle_Minutes__c == 0 || pc.FTE__c == 0) 
                ? 0
                : pc.Production_Revenue__c / (pc.Handle_Minutes__c * pc.FTE__c );
            //Per Min BID Rate  
            pc.Per_Min_BID_Rate__c = pc.Per_Min_Base_Rate__c + 
                (pc.Per_Min_Base_Rate__c * convertToPercentage(s.Payment_Terms_Percent__c)) + 
                (pc.Per_Min_Base_Rate__c * convertToPercentage(s.COLA_percent__c));
            //Per Min BID Rate High
            pc.Per_Min_BID_Rate_High__c = pc.Per_Min_BID_Rate__c + 
                (pc.Per_Min_BID_Rate__c * convertToPercentage(config.UpchargePerMin__c));
    
            //Productive Base Rate
            pc.Productive_Base_Rate__c = (pc.Production_Hours__c == 0 || pc.FTE__c == 0) 
                ? 0
                : pc.Production_Revenue__c / (pc.Production_Hours__c * pc.FTE__c );
            //Productive BID Rate
            pc.Productive_BID_Rate__c = pc.Productive_Base_Rate__c + 
                (pc.Productive_Base_Rate__c * convertToPercentage(s.Payment_Terms_Percent__c)) + 
                (pc.Productive_Base_Rate__c * convertToPercentage(s.COLA_percent__c));
            //Productive BID Rate High
            pc.Productive_BID_Rate_High__c = pc.Productive_BID_Rate__c + 
                (pc.Productive_BID_Rate__c * convertToPercentage(config.UpchargeProdHour__c));

            //Transaction Base Rate 
            pc.Transaction_Base_Rate__c = (pc.Transactions__c == 0 || pc.FTE__c == 0) 
                ? 0
                : pc.Production_Revenue__c / (pc.Transactions__c * pc.FTE__c);
            //Transaction BID Rate  
            pc.Transaction_BID_Rate__c = pc.Transaction_Base_Rate__c + 
                (pc.Transaction_Base_Rate__c * convertToPercentage(s.Payment_Terms_Percent__c)) + 
                (pc.Transaction_Base_Rate__c * convertToPercentage(s.COLA_percent__c));
            //Transaction BID Rate High
            pc.Transaction_BID_Rate_High__c = pc.Transaction_BID_Rate__c + 
                (pc.Transaction_BID_Rate__c * convertToPercentage(config.UpchargePerTran__c));
        }

        private void calcRegionalOpexCosts() {

            //Payroll
            pc.Payroll__c = pc.Seat_Count__c * pc.Site_Payroll_Per_Seat__c;

            //Facilities
            pc.Facilities__c = pc.Seat_Count__c * pc.Facililtes_per_Seat__c;

            //Other/Uptfront Travel/Telco 
            pc.Other_Uptfront_Travel_Telco__c = pc.Seat_Count__c * s.Other_Costs__c;

            //IT Maintenance Cost
            pc.IT_Maintenance_Cost__c = pc.Seat_Count__c * pc.IT_Maintenance__c;

            //Regional Support Costs
            pc.Regional_Support_Costs__c = pc.Seat_Count__c * s.Regional_Support__c;

            //Regional Support Opex Costs
            pc.Regional_Support_Opex_Costs__c = pc.Payroll__c +
                pc.Recruiting__c + 
                pc.Facilities__c + 
                pc.Other_Uptfront_Travel_Telco__c + 
                pc.IT_Maintenance_Cost__c + 
                pc.Regional_Support_Costs__c;
        }

        private void calcCorpSGACostsSection() {

            //CS_WF_Costs__c 
            pc.CS_WF_Costs__c = pc.Seat_Count__c * s.CS_Workforce__c;

            //Allocated_Corp_SGA_Costs__c 
            pc.Allocated_Corp_SGA_Costs__c = pc.Seat_Count__c * s.Corp_SGA__c;

            //Commissions_Costs__c 
            pc.Commissions_Costs__c = convertToPercentage(s.Commissions__c) * 
                (pc.Gross_Profit_Cost__c + pc.Regional_Support_Opex_Costs__c + pc.Allocated_Corp_SGA_Costs__c);

            //Corp_SGA_Costs__c 
            pc.Corp_SGA_Costs__c = pc.CS_WF_Costs__c + pc.Allocated_Corp_SGA_Costs__c + pc.Commissions_Costs__c;

            //Total_Estimated_Cost__c
            pc.Total_Estimated_Cost__c = pc.Gross_Profit_Cost__c + pc.Regional_Support_Opex_Costs__c + pc.Corp_SGA_Costs__c;
        }

        private Decimal getAgentWage() {
            System.debug(LoggingLevel.INFO, 'In getAgentWage');

            Decimal wage = 0.0;
            switch on pc.Agent_Profile__c {
                when 'Tier 1' {
                    wage = s.Agents_Wages_Tier_1__c;
                }
                when 'Tier 2' {
                    wage = s.Agents_Wages_Tier_2__c;
                }
                when 'Tier 3' {
                    wage = s.Agents_Wages_Tier_3__c;
                }
                when else {
                    System.debug(LoggingLevel.INFO, 'Agent Profile not handled: ' + pc.Agent_Profile__c);
                    wage = 0.00;
                }
            }
            
            // PNXT-1414: inspect the checkbox and properly return the normal agent wage, or the inflated agent wage based on acceptance criteria
            if(pc.ApplyPremiumWage__c != null && pc.ApplyPremiumWage__c == true) {
                if(s.Agent_Wage_Premium__c != null) {
                    wage = wage + (wage * convertToPercentage(s.Agent_Wage_Premium__c));
                }
            }
            
            System.debug(LoggingLevel.INFO, 'Agent Wage: ' + wage);
            return wage;
        }

        private Decimal getAttritionTrainingCost() {
            System.debug(LoggingLevel.INFO, 'In getAttritionTrainingCost');
            Decimal atc = 0.0;
            
            atc = (pc.Agent_Wage__c *
                ((convertToPercentage(s.Attrition_Production__c) * 12 * pc.FTE__c * pc.Training_Length__c) + 
                (convertToPercentage(s.Attrition_Production__c) * 12 * pc.FTE__c * pc.Training_Length__c * convertToPercentage(s.Attrition_Training__c) )
                ));
                            
            System.debug(LoggingLevel.INFO, 'Attrition Training Cost: ' + atc);
            return atc;
        }

        private Decimal getBillablePayrollHours() {
            System.debug(LoggingLevel.INFO, 'In getBillablePayrollHours');
            System.debug(LoggingLevel.INFO, 'LOG - Lost_Time__c: ' + s.Lost_Time__c);
            System.debug(LoggingLevel.INFO, 'LOG - Annual_Agent_Hours__c: ' + s.Annual_Agent_Hours__c);
            System.debug(LoggingLevel.INFO, 'LOG - Offsite_Shrink__c: ' + s.Offsite_Shrink__c);
            
            Decimal bph = s.Annual_Agent_Hours__c;
            bph = bph - (s.Annual_Agent_Hours__c * convertToPercentage(s.Offsite_Shrink__c));
            bph = bph - Math.round(bph * convertToPercentage(s.Lost_Time__c));
            
            System.debug(LoggingLevel.INFO, 'Billable Payroll Hours: ' + bph);
            return bph;
        }
        
        private Decimal convertToPercentage(Decimal input) {
            
            //5% comes in as 5, not as .05
            return input / 100;
        }

        private Decimal getITMaintenance() {
            
            System.debug(LoggingLevel.INFO, 'In getITMaintenance');
            if (pc.Services__c == 'Voice') {
                return 612.0;
            } else {
                return 512.0;
            }
        }

        private Decimal getOccupancyPercent() {
             
            System.debug(LoggingLevel.INFO, 'In getOccupancyPercent');
            Decimal occPercent = 85.0;
            if (pc.Services__c == 'Voice') {
                occPercent = 80.0;
            } 
            System.debug(LoggingLevel.INFO, 'Occupancy Percent: ' + occPercent);
            return occPercent;
        }

        private Decimal getRampTrainingCosts() {            
            
            System.debug(LoggingLevel.INFO, 'In getRampTrainingCosts');
            Decimal rtc = 0;

            if (s.Deal_Years__c == null || s.Deal_Years__c == 0) {
                return rtc;
            }
            rtc =  (pc.FTE__c * pc.Training_Length__c / s.Deal_Years__c ) * pc.Agent_Wage__c;
            System.debug(LoggingLevel.INFO, 'Ramp Training Costs: ' + rtc);
            return rtc;
        }

        private Decimal getRecruiting() {
            
            System.debug(LoggingLevel.INFO, 'In getRecruiting');
            Decimal recruit = 0;

            recruit =  s.Recruiting_Cost__c * 
                ((convertToPercentage(s.Attrition_Production__c) * 12 * pc.FTE__c) + 
                 (convertToPercentage(s.Attrition_Production__c) * 12 * pc.FTE__c * convertToPercentage(s.Attrition_Training__c)));

            System.debug(LoggingLevel.INFO, 'Recruiting: ' + recruit);
            return recruit;
        }

        private Decimal getSeatUtilization() {
            
            System.debug(LoggingLevel.INFO, 'In getSeatUtilization');
            Decimal su = 1.0;

            switch on pc.Hours_of_Operation__c {
                when 'Basic 8 hrs 5 days' {
                    su = 1.0;
                }
                when 'Extended 12 hrs 7 days' {
                    su = 1.1;
                }
                when 'Extended plus 18 hrs 7 days' {
                    su = 1.2;
                }
                when 'Full 24 hours 7 days' {
                    su = 1.25;
                }
                when else {
                    System.debug(LoggingLevel.INFO, 'Hours of Operation not handled: ' + pc.Hours_of_Operation__c);
                    su = 1.00;
                }
            }
            System.debug(LoggingLevel.INFO, 'Seat Utilization: ' + su);
            return su;
        }

    }

    public class PricingCalculatorException extends Exception {}
}