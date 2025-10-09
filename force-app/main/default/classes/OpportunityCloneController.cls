public class OpportunityCloneController{

    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
     // add the instance for the variables being passed by id on the url
    private OpportunityLineItem op {get;set;}
    // set the id of the record that is created -- ONLY USED BY THE TEST CLASS
    public ID newRecordId {get;set;}

    // initialize the controller
    public OpportunityCloneController(ApexPages.StandardController controller) {

        //initialize the stanrdard controller
        this.controller = controller;
        // load the current record
        op = (OpportunityLineItem)controller.getRecord();

    }

    // method called from the VF's action attribute to clone the po
    public PageReference cloneOP() {

         // setup the save point for rollback
         Savepoint sp = Database.setSavepoint();
         OpportunityLineItem newOPL;
         newRecordId = op.id;

         try {

             // copy over the line items - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
             List<OpportunityLineItem> items = new List<OpportunityLineItem>();
             /*for (OpportunityLineItem oplineitem : [SELECT ABAY_Length__c,ACD_and_WFM_RTA_Integration_Requirement__c,Active__c,Additional_Agent_Skillset_Notes__c,
                                                     Additional_Build_Out_Cost__c,Additional_Notes_on_Volume__c,Additional_Notes_to_Pricing_Team__c,Agent_License_Description__c,Agent_License_Required__c,Agent_Profile__c,
                                                     Agent_Take_Over_Client_PC_Required__c,Agent_Wage__c,AHT_Cap_Details__c,AHT__c,Alorica_Applications_Required__c,Alorica_Reporting_Requirements__c,Ancilllary_Rate_s__c,
                                                     Annualized_Revenue__c,Applications__c,Apply_Premium_Wage__c,Apttus_Approval__Approval_Status__c,Are_there_any_graduation_KPIs__c,Attrition_Production__c,Attrition_Training__c,
                                                     Automatic_Dialer__c,Bandwidth_Requirement_kbps__c,Bandwidth_Requirement__c,Billing_Mechanism_Final__c,Build_type__c,Call_Back_Assist__c,Call_Recording_Retention_in_days__c,
                                                     Call_Recording__c,CanUseRevenueSchedule,Channels__c,Channel_s__c,Circuits_Order_Required__c,Client_mandated_occupancy__c,Client_Mandated_Operations_Manager_Ratio__c,
                                                     Client_Mandated_Specialized_Positions__c,Client_Preferred_Site__c,Client_Provided_Hiring_Profiles__c,Client_Required_AHT_Caps__c,Client_Required_Uptraining__c,
                                                     Components_of_Billing_Calculation__c,Contract_Term_Months__c,Co_Browse_Required_for_Agent__c,CreatedById,CreatedDate,CTI_Required__c,Data_Connectivity__c,Description,
                                                     Desktop_Other_detail__c,Desktop_Specifications__c,Details_on_Graduation_KPIs__c,Does_this_involve_seasonality__c,EC_Approver__c,Email_Non_Channel__c,Engage_Opportunity_Team__c,
                                                     Estimated_Go_Live_Date__c,Estimated_Inbound_Volume__c,Estimated_Outbound_Volume__c,Est_Annual_Revenue__c,expected_travel_budget_ramp__c,Expected_Travel_Budget_Steady_State__c,
                                                     Feedback_Link__c,File_Feeds__c,Forecast_Detail__c,Forecast_Length_in_Months__c,Forecast_Types__c,Friday_End_Time__c,Friday_Start_Time__c,FTE__c,Full_Load_EBITDA__c,
                                                     Geography__c,Geo_Approver__c,Gross_Profit__c,GST_Approver__c,HasQuantitySchedule,HasRevenueSchedule,HasSchedule,Has_early_ramp_plan_been_developed__c,Historical_Call_Arrival_Data__c,
                                                     Hours_of_Operation__c,Id,If_Client_Add_Location_Data__c,Incentives__c,Initial_ramp_SL_relief_days__c,Interval_Length_minutes__c,IsDeleted,Is_Cloned__c,IT_One_Time_Cost__c,
                                                     IT_Per_Seat_Capex_Cost__c,IT_Per_Seat_Opex_Cost__c,IT_Secutiry_Audit_Requirements__c,IT_Solution_DQM__c,IVR_Required__c,JIRA_Feedback__c,Language__c,LastModifiedById,
                                                     LastModifiedDate,Link_to_Agent_Profile__c,ListPrice,Lock_Timeframe_days__c,Logical_Security_Certifications_Requir__c,Max_Bonus_Potential__c,Max_Penalty_Exposure__c,
                                                     Min_or_Max_Volume_Protection__c,Monday_End_Time__c,Monday_Start_Time__c,Monitors__c,Monitor_Other_detail__c,Month_Type__c,Name,Name__c,Need_for_Non_Production_Phones__c,
                                                     Negotiated_COLA__c,Nonstandard_Agent_Software_Requirements__c,NonStandard_Build_Out_Requirements__c,notes_on_Seasonality__c,Notes_on_Shared_Positions__c,
                                                     Notes_on_Specialized_Position__c,Notes_on_Special_Furniture_Requirements__c,Notes_on_travel_requirements__c,Number_of_New_Production_Workstations__c,
                                                     Number_of_New_Support_Workstations__c,Number_of_New_Training_Rooms__c,Number_of_New_Training_Workstations__c,Number_of_Production_Workstations__c,Number_of_Support_Workstations__c,
                                                     Number_Of_Training_Workstations__c,Occupancy__c,Offline_Shrink__c,Offsite_Shrink_Late_Percentage__c,Offsite_Shrink_LOA_Percentage__c,Offsite_Shrink_NCNS_Percentage__c,
                                                     Offsite_Shrink_PTO_Percentage__c,Offsite_Shrink_Sick_Percentage__c,OM_Salary__c,Onsite_Shrink_Break__c,Onsite_Shrink_CE_Training__c,Onsite_Shrink_Coaching_Percentage__c,
                                                     Onsite_Shrink_Lunch__c,Onsite_Shrink_Meeting__c,Onsite_Shrink_Off_Phone__c,Onsite_Shrink__c,Operations_Manager_Ratio__c,OpportunityId,Opportunity_Stage__c,
                                                     Other_Billing_Mechanisms_to_model__c,Other_File_Feed_details__c,Other_Important_Contractual_Elements__c,Other_Performance_Platform_Details__c,Other_PreAgent_Call_Treatment_Details__c,
                                                     Other_Reporting_details__c,Other_Solution_details__c,Payment_Terms__c,Percentage_Split_for_Multiple_Languages__c,percent_of_the_nesting_period_is_sp__c,
                                                     Performance_Platforms__c,Phones_required_in_Training_Room__c,Phone_Type__c,POS_Approved_Date__c,Predictive_Dialer_Agent_Leg_Voice_Techno__c,Pre_Agent_Call_Treatment_Required__c,
                                                     PricebookEntryId,Pricing_Model_DQM_Snapshot__c,Pricing_Model__c,PrimaryDirectional__c,Primary_Product__c,Primary_responsibility_for_Forecasting__c,Product2Id,ProductCode,
                                                     Production_Rate_s__c,Profile_Name__c,Proposal_Submission_Date__c,Proposed_Bid_Rate__c,Proposed_Occupancy__c,QA_Location__c,QA_Ratio__c,QA_Wage__c,Quantity,Recording_System__c,
                                                     Regional_EBITDA__c,Saturday_End_Time__c,Saturday_Start_Time__c,SBQQ__ParentID__c,SBQQ__QuoteLine__c,SBQQ__SubscriptionType__c,Screen_Recording_Retention_in_days__c,
                                                     Screen_Recording__c,Seats_per_New_Training_Room__c,Seat_Utilization__c,Secure_Training_Room_Required__c,ServiceDate,Services__c,Service_Level_Relief_Max_Forecast__c,Service__c,
                                                     Shared_Ops_Manager__c,Shared_Trainers__c,Solutions_Required__c,SortOrder,Special_Furniture_Required__c,Speech_Analytics__c,Stage__c,Sunday_End_Time__c,Sunday_Start_Time__c,
                                                     SystemModstamp,Target_Production_Go_Live_Date__c,Target_Training_Launch_Date__c,Team_Lead_Incentives__c,Team_Lead_Salary__c,Team_Manager_Ratio__c,Telephony_numbers__c,
                                                     Thursday_End_Time__c,Thursday_Start_Time__c,Time_Zone__c,TotalPrice,Total_Price__c,Trainer_Ratio__c,Training_Billable__c,Training_Length__c,Training_Rate__c,
                                                     Transmit_Recordings_back_to_Client__c,Tuesday_End_Time__c,Tuesday_Start_Time__c,UnitPrice,Voice_Circuit_Provider__c,Voice_Delivery__c,Voice_Platform__c,Volume_Delivery_Allocation__c,
                                                     WAH_Requirement__c,Wednesday_End_Time__c,Wednesday_Start_Time__c,Workforce_Suggested_FTE__c,Workforce_Suggested_Occupancy__c,Workforce_Suggested_Seat_Utilization__c,Workforce__c,X24_7__c,Yr_1_Revenue__c,Yr_2_Revenue__c,Yr_3_Revenue__c,zzz_Background_Checks__c,zzz_Competitors_in_Short_List__c,zzz_Currency__c,zzz_Est_Revenue__c,zzz_Physical_Security_requirements__c,zzz_Renewal_Option__c,zzz_RFI_Sales_CS_Compl_Date__c,zzz_RFP_Due_Date__c FROM OpportunityLineItem where id =: op.id]) {
               
                newOPL = oplineitem.clone(false);
                  newOPL.Is_Cloned__c = True;
                  items.add(newOPL);
             }
             insert items;*/
             
             // Code added By Mehul Parmar - Start
              
             String selectQuery = createQuery('OpportunityLineItem',' id = \''+op.id+'\'');
              for (OpportunityLineItem oplineitem : Database.Query(selectQuery)) {
               
                newOPL = oplineitem.clone(false);
                  newOPL.Is_Cloned__c = True;
                  items.add(newOPL);
             }
             insert items;
             // Code added By Mehul Parmar - End

         } catch (Exception e){
             // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
         }
         String messageSuccess ='Record Has been Created Succesfully. Click here to open it : <a href="/' + newOPL.Id +'">newOPLName</a>';
         messageSuccess = messageSuccess.replace('newOPLName',newOPL.Name__c);

         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, messageSuccess ));
       
         //return new PageReference('/'+newOPL.id+'/e?retURL=%2F'+newOPL.id);
        return null; 
        // return new PageReference('/'+newOPL.id);
         
    }
    public String createQuery(String objectName,String whereClause){
        String selectQuery = 'SELECT ';
        Map <String, Schema.SObjectField> fieldMap =  Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult dfield = sfield.getDescribe();
            selectQuery+=dfield.getName() +',';
        }
        
        selectQuery = selectQuery.substring(0,selectQuery.length()-1);
        selectQuery += ' FROM '+objectName.toUpperCase();
        selectQuery += ' WHERE '+whereClause; 
        
        return selectQuery;
    }
    
}