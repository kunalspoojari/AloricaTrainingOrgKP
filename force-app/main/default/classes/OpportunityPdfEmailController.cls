/*
*   @Author: Ariel Tribunal
*   @Date: 9/30/2019
*   @Apex Name: OpportunityPdfEmailController
*   @Description: Controller use for setting up the visualforce page to be converted to pdf for Service Now
*
*/
public class OpportunityPdfEmailController {

    public Opportunity opp;
    public list<OpportunityLineItem> OppProducts { get; set;}
    public list<ContentVersion> FileAttached { get; set;}

    public OpportunityPdfEmailController(ApexPages.StandardController stdController) {
        this.opp = (Opportunity)stdController.getRecord();
        
        String SvnProjId = ApexPages.currentPage().getParameters().get('snprojid');
        String StageNameVar = ApexPages.currentPage().getParameters().get('stage');
        
        if(SvnProjId != NULL){
            this.opp.ServiceNow_Project_ID__c = SvnProjId;
        }
        
        if(StageNameVar != NULL){
            this.opp.StageName = StageNameVar;
        }
                
        OppProducts = [SELECT Id, Name, Opportunity.Name, Primary_Product__c, Product2.Name, Stage__c, PrimaryDirectional__c, Pricing_Model__c, 
                       Opportunity_Stage__c, Other_Billing_Mechanisms_to_model__c, Additional_Notes_to_Pricing_Team__c, POS_Approved_Date__c,Engage_Opportunity_Team__c,
                       Client_Preferred_Site__c,Hours_of_Operation__c,AHT__c,Training_Length__c,Link_to_Agent_Profile__c,Training_Billable__c,Agent_Profile__c,
                       Channel_s__c, FTE__c,Language__c,estimated_Go_Live_Date__c,Percentage_Split_for_Multiple_Languages__c,Geography__c,Build_type__c,
                       Billing_Mechanism_Final__c,Service__c,Does_this_involve_seasonality__c,notes_on_Seasonality__c,X24_7__c,Time_Zone__c,Monday_Start_Time__c,
                       Monday_End_Time__c,Tuesday_Start_Time__c,Tuesday_End_Time__c,Wednesday_Start_Time__c,Wednesday_End_Time__c,Thursday_Start_Time__c,
                       Thursday_End_Time__c,Friday_Start_Time__c,Friday_End_Time__c,Saturday_Start_Time__c,Saturday_End_Time__c,Sunday_Start_Time__c,Sunday_End_Time__c,
                       Operations_Manager_Ratio__c,Agent_License_Required__c,Team_Manager_Ratio__c,Agent_License_Description__c,QA_Ratio__c,
                       Negotiated_COLA__c,QA_Location__c,Client_Required_Uptraining__c,Trainer_Ratio__c,Notes_on_Shared_Positions__c,
                       Shared_Trainers__c,Shared_Ops_Manager__c,Client_Mandated_Operations_Manager_Ratio__c,Client_mandated_occupancy__c,
                       Client_Provided_Hiring_Profiles__c,Proposed_Occupancy__c,Historical_Call_Arrival_Data__c,Estimated_Inbound_Volume__c,
                       ABAY_Length__c,Estimated_Outbound_Volume__c,Client_Required_AHT_Caps__c,NonStandard_Build_Out_Requirements__c,
                       AHT_Cap_Details__c,Secure_Training_Room_Required__c,Client_Mandated_Specialized_Positions__c,Special_Furniture_Required__c,
                       Notes_on_Specialized_Position__c,Notes_on_Special_Furniture_Requirements__c,Additional_Notes_on_Volume__c,
                       Additional_Agent_Skillset_Notes__c,Target_Production_Go_Live_Date__c,Target_Training_Launch_Date__c,Initial_ramp_SL_relief_days__c,
                       expected_travel_budget_ramp__c,Max_Bonus_Potential__c,Notes_on_travel_requirements__c,Max_Penalty_Exposure__c,Forecast_Detail__c,
                       Service_Level_Relief_Max_Forecast__c,Forecast_Types__c,Are_there_any_graduation_KPIs__c,Lock_Timeframe_days__c,Details_on_Graduation_KPIs__c,
                       Interval_Length_minutes__c,Volume_Delivery_Allocation__c,Month_Type__c,Min_or_Max_Volume_Protection__c,Forecast_Length_in_Months__c,
                       Expected_Travel_Budget_Steady_State__c,percent_of_the_nesting_period_is_sp__c,Other_Important_Contractual_Elements__c,
                       Desktop_Specifications__c,Monitors__c,Alorica_Reporting_Requirements__c,Other_Performance_Platform_Details__c,
                       WAH_Requirement__c,File_Feeds__c,Performance_Platforms__c,Logical_Security_Certifications_Requir__c,
                       Voice_Platform__c,IT_Secutiry_Audit_Requirements__c,Phone_Type__c,IT_Solution_DQM__c,Phones_required_in_Training_Room__c,IT_Per_Seat_Capex_Cost__c,
                       Recording_System__c,IT_Per_Seat_Opex_Cost__c,Call_Recording__c,IT_One_Time_Cost__c,Call_Recording_Retention_in_days__c,Automatic_Dialer__c,
                       Screen_Recording__c,Number_of_New_Production_Workstations__c,Screen_Recording_Retention_in_days__c,Number_Of_Training_Workstations__c,
                       Transmit_Recordings_back_to_Client__c,Number_of_New_Training_Workstations__c,Speech_Analytics__c,Number_of_Support_Workstations__c,IVR_Required__c,
                       Number_of_New_Support_Workstations__c,Call_Back_Assist__c,Number_of_New_Training_Rooms__c,Seats_per_New_Training_Room__c,Workforce__c,
                       Need_for_Non_Production_Phones__c,Email_Non_Channel__c,Co_Browse_Required_for_Agent__c,Nonstandard_Agent_Software_Requirements__c,
                       Agent_Take_Over_Client_PC_Required__c,Bandwidth_Requirement_kbps__c,Other_PreAgent_Call_Treatment_Details__c,
                       Pre_Agent_Call_Treatment_Required__c,Voice_Delivery__c,Predictive_Dialer_Agent_Leg_Voice_Techno__c,Telephony_numbers__c,ACD_and_WFM_RTA_Integration_Requirement__c,
                       Alorica_Applications_Required__c,CTI_Required__c,Data_Connectivity__c,Total_Price__c,Desktop_Other_detail__c,Other_Solution_details__c,Monitor_Other_detail__c,
                       Other_Reporting_details__c,If_Client_Add_Location_Data__c,Other_File_Feed_details__c,Additional_Build_Out_Cost__c,Number_of_Production_Workstations__c,
                       Onsite_Shrink_Meeting__c,Offsite_Shrink_PTO_Percentage__c,Onsite_Shrink_Lunch__c,Offsite_Shrink_Sick_Percentage__c,Onsite_Shrink_Off_Phone__c,
                       Offsite_Shrink_Late_Percentage__c,Onsite_Shrink_Break__c,Offsite_Shrink_LOA_Percentage__c,Primary_responsibility_for_Forecasting__c,Offsite_Shrink_NCNS_Percentage__c,
                       Workforce_Suggested_FTE__c,Onsite_Shrink_Coaching_Percentage__c,Workforce_Suggested_Occupancy__c,Onsite_Shrink_CE_Training__c,Workforce_Suggested_Seat_Utilization__c,
                       Has_early_ramp_plan_been_developed__c,Training_Rate__c,Gross_Profit__c,Production_Rate_s__c,
                       Ancilllary_Rate_s__c,Full_Load_EBITDA__c,Annualized_Revenue__c,Occupancy__c,Attrition_Production__c,Onsite_Shrink__c,Attrition_Training__c,Offline_Shrink__c,
                       Seat_Utilization__c,Agent_Wage__c,Payment_Terms__c,Incentives__c,Team_Lead_Incentives__c,Yr_1_Revenue__c,Team_Lead_Salary__c,
                       Yr_2_Revenue__c,QA_Wage__c,Yr_3_Revenue__c,OM_Salary__c,Headcount__c
                      //Proposed_Bid_Rate__c,Applications__c,Circuits_Order_Required__c
                FROM OpportunityLineItem
                WHERE OpportunityId = :this.opp.Id];
                    
        list<ContentDocumentLink> listContDocs = 
            [SELECT ContentDocumentId,Id,LinkedEntityId from ContentDocumentLink where LinkedEntityId = :this.opp.Id];
        if(!listContDocs.isEmpty()){
            list<Id> listids = new list<Id>();
            for(ContentDocumentLink cdl: listContDocs){
                listids.add(cdl.ContentDocumentId);
            }
            FileAttached = [SELECT Title,FirstPublishLocationId,Id FROM ContentVersion where ContentDocumentId IN:listids];
        }
    }
}