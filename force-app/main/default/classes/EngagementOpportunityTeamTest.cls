@isTest
private  class EngagementOpportunityTeamTest {
   /* testMethod static void testSubmit() {
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        SBQQ__Quote__c clonedQuote = new SBQQ__Quote__c();
        insert quote;

    }
    static testMethod void validateApprovalTrigger() {
        SBQQ__Quote__c testQuote1 = New SBQQ__Quote__c(); 
        insert testQuote1;
        
        sbaa__Approval__c testApproval1 = New sbaa__Approval__c();
        testApproval1.Quote__c = testQuote1.Id;
        testApproval1.sbaa__ApprovalStep__c = 10;
        testApproval1.sbaa__RecordField__c = 'Quote__c';
            
        insert testApproval1;
        
        sbaa__Approval__c testApproval2 = New sbaa__Approval__c();
        testApproval2.Quote__c = testQuote1.Id;     
        testApproval2.sbaa__ApprovalStep__c = 20;
        testApproval2.sbaa__RecordField__c = 'Quote__c';
        testApproval2.sbaa__Status__c = 'Approved';
        insert testApproval2;
        
    }
   /* static testMethod void validate(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Industry = 'Communications';
        acc.Inside_Sales_Owner__c = 'Account Owner';   
        
        insert acc;
        
        User salesUser = [select id,name from user where ProfileId in : [select id from Profile where name ='Sales' limit 1] and isActive = true limit 1];
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        Id standardPrice = Test.getStandardPricebookId();
        //insert standardPrice;
        System.assert(standardPrice !=null, 'Standard Pricebook got created: '+standardPrice);
        
       // System.assert(acc.Id !=null, 'Account got created : '+acc.Id);
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        /*opp.Additional_Notes_to_Pricing_Team__c = 'test';*/
        /*opp.Name = 'Test Opportunity';
        opp.CloseDate = Date.today().addMonths(12).addDays(-1);
        opp.StageName = 'Qualified Opportunity';
        opp.Deal_Type__c = 'New Logo';
        opp.Vertical__c = 'Energy & Utilities';
        opp.Business_Type__c = 'B2B';
        opp.Reason_Lost__c = 'Price was too high';
        opp.Who_did_we_lose_to__c = 'Other';
        opp.QualifyApprovedDate__c = Date.today().addMonths(2).addDays(-1);
        opp.RecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Lightning').getRecordTypeId();
        opp.PriceBook2Id = customPB.id;
        
        insert opp;
        
       SBQQ__Quote__c q = new SBQQ__Quote__c();
       q.SBQQ__Account__c = acc.Id;
       q.SBQQ__Opportunity2__c = opp.Id;
       q.SBQQ__StartDate__c =  Date.today().addMonths(12).addDays(12);
       q.SBQQ__SubscriptionTerm__c =  36;   
       q.ApprovalStatus__c = 'Draft';
        
        insert q;
        
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.IsActive = true;
        prod.ProductCode = 'CORE-CC';
        
        insert prod;
        
       // System.assert(prod.Id !=null, 'Product got created : '+prod.Id);
        
        //Opportunity tmp = [Select PriceBook2Id from Opportunity Where Id = :opp.id];  
        
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
        
        //System.assert(newPb1.Id !=null, 'Pricebook entry got created : '+newPb1.Id);
        
        Site__c site = new Site__c(); 
        site.Name = 'test site';
        site.Region__c = 'Asia Pacific';
        insert site;
        
        //System.assert(site.Id !=null, 'Alorica Site got created : '+site.Id);
        
        
        OpportunityLineItem ooli = new OpportunityLineItem (Quantity=2,UnitPrice=1, OpportunityId=opp.Id, PriceBookEntryId=newPb1.Id); 
        ooli.Client_Preferred_Site__c = site.Id;
        ooli.AHT__c = 10000;
        ooli.FTE__c = 1000;
        ooli.Does_this_involve_seasonality__c = 'No';
        ooli.notes_on_Seasonality__c = '12';
        ooli.Estimated_Go_Live_Date__c =  Date.today().addMonths(12).addDays(12);
        ooli.Training_Length__c = 20;
        ooli.Billing_Mechanism_Final__c = 'Payroll Hour';
        ooli.Agent_Profile__c = 'Tier 1';
        ooli.Channel_s__c =  'Voice';
        ooli.Build_type__c = 'Refresh';
        ooli.Hours_of_Operation__c  = 'Basic 8 hrs 5 days';
//        ooli.Training_Billable__c = 'Yes';
        ooli.Language__c = 'English;Other';
        ooli.Primary_Product__c = true;
//      removed active here
        ooli.Headcount__c = 50;
        ooli.Training_Billable__c = true;
        ooli.Training_Length__c = 10;
        ooli.Gross_Profit__c = 0.30;
        
        insert ooli; 
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        User usr = new User(LastName = 'LIVESTON',
                            FirstName='JASON',
                            Alias = 'jliv',
                            Email = 'jason.liveston@asdf.com',
                            Username = 'jason.livston@asdf.com',
                            ProfileId = p.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           );
        
        insert usr;
        
        ooli.X24_7__c = true;
        ooli.Operations_Manager_Ratio__c = 12;
        ooli.QA_Ratio__c = 12;
        ooli.Team_Manager_Ratio__c = 12;
        ooli.Trainer_Ratio__c = 12;
//        ooli.Agent_License_Required__c = 'Yes';

//        ooli.Client_Provided_Hiring_Profiles__c = 'No';
        ooli.Historical_Call_Arrival_Data__c = 'No';
        ooli.QA_Location__c = 'Onsite';
        ooli.Client_Required_Uptraining__c = 12;
      
        update ooli;
       
        opp.GSTApprover__c = usr.Id;
        opp.EngageOpportunityTeam__c = true;
        opp.SBQQ__PrimaryQuote__c = q.Id;
        opp.RFI_IT_Compl_Date__c = Date.today().addDays(14);
        opp.RFI_WFM_Compl_Date__c = Date.today().addDays(13);
        opp.StageName = Label.OppStage20; 
        
        System.debug('Opp List :'+JSON.serialize(opp));
        update opp;
        
        
        opp.StageName = Label.OppStage30;
        opp.StageName = 'Verbal Win';
        opp.Renewal_Option__c = 'Yes';
        opp.OwnerId = salesUser.Id;
        update opp;
        
        Test.startTest();
//        ooli.Are_there_any_graduation_KPIs__c = 'Yes';
        ooli.Volume_Delivery_Allocation__c = 'Alorica';
        ooli.Min_or_Max_Volume_Protection__c = '75%';
        ooli.expected_travel_budget_ramp__c = 100;
        ooli.Expected_Travel_Budget_Steady_State__c = 100;
        ooli.Initial_ramp_SL_relief_days__c = 100;
        ooli.Max_Bonus_Potential__c  = 100;
        ooli.Max_Penalty_Exposure__c = 100;
        ooli.Trainer_Ratio__c = 10;
        ooli.Forecast_Detail__c = 'Monthly';
        ooli.Forecast_Types__c = 'Volume';
        ooli.Lock_Timeframe_days__c = '30';
        ooli.Interval_Length_minutes__c = '15';
        ooli.Service_Level_Relief_Max_Forecast__c = 10;
        ooli.Month_Type__c = 'Calendar';
        ooli.Forecast_Length_in_Months__c = 10;
        ooli.Target_Training_Launch_Date__c = Date.today();
        ooli.Target_Production_Go_Live_Date__c = Date.today().addDays(1);
        ooli.Stage__c = 'Won';
        
        update ooli;
        
        if(salesUser != null){
            System.runAs(salesUser){ 
                opp.Move_to_Contract__c = true;
                opp.VerbalWinDate__c = Date.today();
                opp.Verbal_Win_IT_Validation_Complete__c = Date.today();
                opp.Verbal_Win_Pricing_Validation_Complete__c = Date.today();
                opp.Verbal_Win_WFM_Validation_Complete__c = Date.today();
                opp.StageName = 'Contract';
                update opp;
            }
        }
        
           
        opp.Reason_Lost__c = 'Price was too high';
        opp.Who_did_we_lose_to__c = 'Other';
        opp.StageName = 'Closed Lost';
        update opp;
        Test.stopTest();        
    }
    
/*-------------------------------------------------------------------------*/
    
    /* static testMethod void validate2(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Industry = 'Communications';
        acc.Inside_Sales_Owner__c = 'Account Owner';   
        
        insert acc;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        User salesUser = [select id,name from user where ProfileId in : [select id from Profile where name ='Sales' limit 1] and isActive = true limit 1];
         
        Id standardPrice = Test.getStandardPricebookId();
        //insert standardPrice;
        System.assert(standardPrice !=null, 'Standard Pricebook got created: '+standardPrice);
        
       // System.assert(acc.Id !=null, 'Account got created : '+acc.Id);
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
       /* opp.Additional_Notes_to_Pricing_Team__c = 'test';*/
        /*opp.Name = 'Test Opportunity';
        opp.CloseDate = Date.today().addMonths(12).addDays(-1);
        opp.StageName = 'Qualified Opportunity';
        opp.Deal_Type__c = 'New Logo';
        opp.Vertical__c = 'Energy & Utilities';
        opp.Reason_Lost__c = 'Price was too high';
        opp.Who_did_we_lose_to__c = 'Other';
        opp.Business_Type__c = 'B2B';
        opp.QualifyApprovedDate__c = Date.today().addMonths(2).addDays(-1);
        opp.RecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Lightning').getRecordTypeId();
        opp.OwnerId = salesUser.Id;
        opp.PriceBook2Id = customPB.id;
        insert opp;

       SBQQ__Quote__c q = new SBQQ__Quote__c();
       q.SBQQ__Account__c = acc.Id;
       q.SBQQ__Opportunity2__c = opp.Id;
       q.SBQQ__StartDate__c =  Date.today().addMonths(12).addDays(12);
       q.SBQQ__SubscriptionTerm__c =  36;   
       q.ApprovalStatus__c = 'Draft';
        
        insert q;
        
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.IsActive = true;
        prod.ProductCode = 'CORE-CC';
         
        insert prod;
        
       // System.assert(prod.Id !=null, 'Product got created : '+prod.Id);
        
        
        
        //Opportunity tmp = [Select PriceBook2Id from Opportunity Where Id = :opp.id];  
        
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
        
        //System.assert(newPb1.Id !=null, 'Pricebook entry got created : '+newPb1.Id);
        
        Site__c site = new Site__c(); 
        site.Name = 'test site';
        site.Region__c = 'Asia Pacific';
        insert site;
        
        //System.assert(site.Id !=null, 'Alorica Site got created : '+site.Id);
        
        
        OpportunityLineItem ooli1 = new OpportunityLineItem (Quantity=2,UnitPrice=1, OpportunityId=opp.Id, PriceBookEntryId=newPb1.Id); 
        ooli1.Client_Preferred_Site__c = site.Id;
        ooli1.AHT__c = 10000;
        ooli1.FTE__c = 1000;
        ooli1.Does_this_involve_seasonality__c = 'No';
        ooli1.notes_on_Seasonality__c = '12';
        ooli1.Estimated_Go_Live_Date__c =  Date.today().addMonths(12).addDays(12);
        ooli1.Training_Length__c = 20;
        ooli1.Billing_Mechanism_Final__c = 'Payroll Hour';
        ooli1.Agent_Profile__c = 'Tier 2';
        ooli1.Channel_s__c =  'Voice';
        ooli1.Build_type__c = 'Refresh';
        ooli1.Hours_of_Operation__c  = 'Basic 8 hrs 5 days';
//        ooli1.Training_Billable__c = 'Yes';
        ooli1.Language__c = 'English;Other';
        ooli1.Primary_Product__c = true;
//      removed active here
        ooli1.Headcount__c = 50;
        ooli1.Training_Billable__c = true;
        ooli1.Training_Length__c = 10;
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
     
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        User usr = new User(LastName = 'LIVESTON',
                            FirstName='JASON',
                            Alias = 'jliv',
                            Email = 'jason.liveston@asdf.com',
                            Username = 'jason.livston@asdf.com',
                            ProfileId = p.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           );
        
        insert usr;
       
        opp.GSTApprover__c = usr.Id;
        opp.EngageOpportunityTeam__c = true;  
        opp.RFI_IT_Compl_Date__c = Date.today().addDays(14);
        opp.RFI_WFM_Compl_Date__c = Date.today().addDays(13);
        opp.StageName = Label.OppStage20;
        opp.SBQQ__PrimaryQuote__c = q.Id;
       
        update opp;
       
        opp.StageName = 'Verbal Win';
        opp.Renewal_Option__c = 'Yes';
        update opp;
         
        Test.startTest();
         if(salesUser != null){
            System.runAs(salesUser){ 
                opp.Verbal_Win_IT_Validation_Complete__c = Date.today();
                opp.Verbal_Win_Pricing_Validation_Complete__c = Date.today();
                opp.Verbal_Win_WFM_Validation_Complete__c = Date.today();
                opp.Move_to_Contract__c = true;
                opp.VerbalWinDate__c = Date.today();
                opp.StageName = 'Contract';
                update opp;
            }
        }
          
        opp.Reason_Lost__c = 'Price was too high';
        opp.Who_did_we_lose_to__c = 'Other';
        opp.StageName = 'Closed Lost';
        update opp;
        Test.stopTest(); 
        
    }
    
    static testMethod void validate3(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Industry = 'Communications';
        acc.Inside_Sales_Owner__c = 'Account Owner';   
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        insert acc;
        
        Id standardPrice = Test.getStandardPricebookId();
        //insert standardPrice;
        System.assert(standardPrice !=null, 'Standard Pricebook got created: '+standardPrice);
        
        User salesUser = [select id,name from user where ProfileId in : [select id from Profile where name ='Sales' limit 1] and isActive = true limit 1];
        
       // System.assert(acc.Id !=null, 'Account got created : '+acc.Id);
    
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
      /*  opp.Additional_Notes_to_Pricing_Team__c = 'test';*/
       /* opp.Name = 'Test Opportunity';
        opp.CloseDate = Date.today().addMonths(12).addDays(-1);
        opp.StageName = 'Qualified Opportunity';
        opp.Deal_Type__c = 'New Logo';
        opp.Vertical__c = 'Energy & Utilities';
        opp.Reason_Lost__c = 'Price was too high';
        opp.Who_did_we_lose_to__c = 'Other';
        opp.Business_Type__c = 'B2B';
        opp.QualifyApprovedDate__c = Date.today().addMonths(2).addDays(-1);
        opp.RecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Lightning').getRecordTypeId();
        opp.OwnerId = salesUser.Id;
        opp.PriceBook2Id = customPB.id;
        
        insert opp;
       
       SBQQ__Quote__c q = new SBQQ__Quote__c();
       q.SBQQ__Account__c = acc.Id;
       q.SBQQ__Opportunity2__c = opp.Id;
       q.SBQQ__StartDate__c =  Date.today().addMonths(12).addDays(12);
       q.SBQQ__SubscriptionTerm__c =  36;   
       q.ApprovalStatus__c = 'Draft';
        
        insert q;
        
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.IsActive = true;
        prod.ProductCode = 'CORE-CC';
        
        insert prod;
        
       // System.assert(prod.Id !=null, 'Product got created : '+prod.Id);
        
        
        
        //Opportunity tmp = [Select PriceBook2Id from Opportunity Where Id = :opp.id];  
        
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
        
        //System.assert(newPb1.Id !=null, 'Pricebook entry got created : '+newPb1.Id);
        
        Site__c site = new Site__c(); 
        site.Name = 'test site';
        site.Region__c = 'Asia Pacific';
        insert site;
        
        //System.assert(site.Id !=null, 'Alorica Site got created : '+site.Id);
        
        
        OpportunityLineItem ooli1 = new OpportunityLineItem (Quantity=2,UnitPrice=1, OpportunityId=opp.Id, PriceBookEntryId=newPb1.Id); 
        ooli1.Client_Preferred_Site__c = site.Id;
        ooli1.AHT__c = 10000;
        ooli1.FTE__c = 1000;
        ooli1.Does_this_involve_seasonality__c = 'No';
        ooli1.notes_on_Seasonality__c = '12';
        ooli1.Estimated_Go_Live_Date__c =  Date.today().addMonths(12).addDays(12);
        ooli1.Training_Length__c = 20;
        ooli1.Billing_Mechanism_Final__c = 'Payroll Hour';
        ooli1.Agent_Profile__c = 'Tier 2';
        ooli1.Channel_s__c =  'Voice';
        ooli1.Build_type__c = 'Refresh';
        ooli1.Hours_of_Operation__c  = 'Basic 8 hrs 5 days';
//        ooli1.Training_Billable__c = 'Yes';
        ooli1.Language__c = 'English;Other';
        ooli1.Primary_Product__c = true;
//      removed active here
        ooli1.Headcount__c = 50;
        ooli1.Training_Billable__c = true;
        ooli1.Training_Length__c = 10;
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
        ooli1.Stage__c = 'Lost - Price was too high';
        ooli1.Gross_Profit__c = 0.30;
        
        insert ooli1;
     
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        User usr = new User(LastName = 'LIVESTON',
                            FirstName='JASON',
                            Alias = 'jliv',
                            Email = 'jason.liveston@asdf.com',
                            Username = 'jason.livston@asdf.com',
                            ProfileId = p.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           );
        
        insert usr;
       
        opp.GSTApprover__c = usr.Id;
        opp.EngageOpportunityTeam__c = true;
        opp.RFI_IT_Compl_Date__c = Date.today().addDays(14);
        opp.RFI_WFM_Compl_Date__c = Date.today().addDays(13);
        opp.SBQQ__PrimaryQuote__c = q.Id;
        opp.Currency__c = 'US';
        opp.Background_Checks__c = 'Credit check';
        opp.Physical_Security_requirements__c= 'Dedicated Badge Access';
        opp.StageName = Label.OppStage20; 
        
        System.debug('Opp List :'+JSON.serialize(opp));
        update opp;
       
        
       // opp.StageName = Label.OppStage30;
       // update opp;
        
        if(salesUser != null){
            System.runAs(salesUser){ 
                //opp.StageName = Label.OppStage30;
               // update opp;
            }
        }
        
        opp.StageName = 'Verbal Win';
        opp.Renewal_Option__c = 'Yes';
        opp.LOICompleteDate__c = Date.today().addDays(15);
        opp.Why_did_we_win__c = 'Most Experience';
        opp.Oracle_Project_Code__c = '12';
        opp.Capex_Number__c  = '12';
        opp.CapexApprovedAmount__c = 12;
        opp.Contract_Signed_Date__c = Date.today().addDays(15);
        
        Test.startTest();
        update opp;
        
       
        if(salesUser != null){
            System.runAs(salesUser){ 
                opp.Verbal_Win_IT_Validation_Complete__c = Date.today();
                opp.Verbal_Win_Pricing_Validation_Complete__c = Date.today();
                opp.Verbal_Win_WFM_Validation_Complete__c = Date.today();
                opp.Move_to_Contract__c = true;
                opp.VerbalWinDate__c = Date.today();
                opp.StageName = 'Contract';
                update opp;
            }
        }
        Test.stopTest();
        /*if(salesUser != null){
            System.runAs(salesUser){ 
                opp.Reason_Lost__c = 'Price was too high';
                opp.Who_did_we_lose_to__c = 'Other';
            opp.StageName = 'Closed Lost';
            update opp;
            }
        }*/
        
   /* }*/
    
}