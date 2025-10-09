@isTest
public class QuoteTriggerHandlerTest {
    /*static testMethod void validateErrorChecker(){
       SBQQ__Quote__c q = new SBQQ__Quote__c();
       insert q;
       try {
            if(Test.isRunningTest()) {
            // Cause DMLException
           q.Error_Message__c = 'Testing 123';
           update q;
            }
      } catch (DMLException e) {
    // Existing exception handling.
     System.Assert(e.getMessage().contains('Testing 123'));
    }     
    }
        static testMethod void validateUpdateOLIs(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Industry = 'Communications';
        acc.Inside_Sales_Owner__c = 'Account Owner';   
        
        insert acc;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
            
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        /*opp.Additional_Notes_to_Pricing_Team__c = 'test';*/
        /*opp.Name = 'Test Opportunity';
        opp.CloseDate = Date.today().addMonths(12).addDays(-1);
        opp.StageName = 'Qualified Opportunity';
        opp.Deal_Type__c = 'New Logo';
        opp.Vertical__c = 'Energy & Utilities';
        opp.Business_Type__c = 'B2B';
        opp.RecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Lightning').getRecordTypeId();
        opp.PriceBook2Id = customPB.id;
        insert opp;
        
        //Opportunity tmp = [Select PriceBook2Id from Opportunity Where Id = :opp.id];    
            
        Product2 prod = new Product2();
        prod.Name = 'Customer Care';
        prod.ProductCode = 'CORE-CC';
        prod.IsActive = true;
        insert prod;    
        
            
        PriceBookEntry newPb2 = new  PriceBookEntry();
        newPb2.Product2Id = prod.Id;
        newPb2.PriceBook2Id = test.getStandardPricebookId();
        newPb2.UnitPrice = 2200;
        newPb2.IsActive = true;
        insert newPb2;

        PriceBookEntry newPb1 = new  PriceBookEntry();
        newPb1.Product2Id = prod.Id;
        newPb1.PriceBook2Id = opp.Pricebook2Id;
        newPb1.UnitPrice = 2200;
        newPb1.IsActive = true;
        insert newPb1;    
            
        Site__c site = new Site__c(); 
        site.Name = 'test site';
        site.Region__c = 'Asia Pacific';
        insert site;
            
        OpportunityLineItem ooli1 = new OpportunityLineItem (Quantity=2,UnitPrice=1, OpportunityId=opp.Id, PriceBookEntryId=newPb1.Id); 
        ooli1.Client_Preferred_Site__c = site.Id;
        ooli1.AHT__c = 10000;
        ooli1.FTE__c = 1000;
        ooli1.Headcount__c = 100;
        ooli1.Does_this_involve_seasonality__c = 'No';
        ooli1.notes_on_Seasonality__c = '12';
        ooli1.Estimated_Go_Live_Date__c =  Date.today().addMonths(12).addDays(12);
        ooli1.Training_Length__c = 20;
        ooli1.Billing_Mechanism_Final__c = 'Payroll Hour';
        ooli1.Agent_Profile__c = 'Tier 2';
        ooli1.Services__c = 'Voice';
        ooli1.Channel_s__c =  'Voice';
        ooli1.Build_type__c = 'Refresh';
        ooli1.Hours_of_Operation__c  = 'Basic 8 hrs 5 days';
//        ooli1.Training_Billable__c = 'Yes';
        ooli1.Language__c = 'English;Other';
        ooli1.Primary_Product__c = true;
//remove active here
        ooli1.X24_7__c = true;
        ooli1.Operations_Manager_Ratio__c = 12;
        ooli1.QA_Ratio__c = 12;
        ooli1.Team_Manager_Ratio__c = 12;
        ooli1.Trainer_Ratio__c = 12;
//        ooli1.Agent_License_Required__c = 'Yes';
//        ooli1.Client_Provided_Hiring_Profiles__c = 'No';
        ooli1.Historical_Call_Arrival_Data__c = 'No';
        ooli1.QA_Location__c = 'Onsite';
        ooli1.Client_Required_Uptraining__c = 12;
//        ooli1.Are_there_any_graduation_KPIs__c = 'Yes';
        ooli1.Volume_Delivery_Allocation__c = 'Alorica';
        ooli1.Min_or_Max_Volume_Protection__c = '75%';
        ooli1.expected_travel_budget_ramp__c = 100;
        ooli1.Expected_Travel_Budget_Steady_State__c = 100;
        ooli1.Initial_ramp_SL_relief_days__c = 100;
        ooli1.Max_Bonus_Potential__c  = 100;
        ooli1.Max_Penalty_Exposure__c = 100;
        ooli1.Trainer_Ratio__c = 10;
        ooli1.Forecast_Detail__c = 'Monthly';
        ooli1.Forecast_Types__c = 'Volume';
        ooli1.Lock_Timeframe_days__c = '30';
        ooli1.Interval_Length_minutes__c = '15';
        ooli1.Service_Level_Relief_Max_Forecast__c = 10;
        ooli1.Month_Type__c = 'Calendar';
        ooli1.Forecast_Length_in_Months__c = 10;
        ooli1.Target_Training_Launch_Date__c = Date.today();
        ooli1.Target_Production_Go_Live_Date__c = Date.today().addDays(1);
        ooli1.Stage__c = 'Won';
        ooli1.Gross_Profit__c = 0.30;
        
        insert ooli1;    
            
       /*SBQQ__Quote__c q = new SBQQ__Quote__c();
       q.SBQQ__Account__c = acc.Id;
       q.SBQQ__Opportunity2__c = opp.Id;
       q.SBQQ__StartDate__c =  Date.today().addMonths(12).addDays(12);
       q.SBQQ__SubscriptionTerm__c =  36;   
       q.ApprovalStatus__c = 'Draft';
        insert q;
       q.ApprovalStatus__c = 'Pending';
        update q; */
        /* }*/
   
}