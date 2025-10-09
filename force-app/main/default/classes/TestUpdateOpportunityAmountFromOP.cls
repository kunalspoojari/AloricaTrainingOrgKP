@isTest
private class TestUpdateOpportunityAmountFromOP {
    
    static testMethod void testmethod1() {
    
        Id oppRecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Lightning').getRecordTypeId();
        
        Account a = new Account(Name ='icrm testing acc');
        insert a;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Sales'];
        
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
        
        Date myDate = date.today();
        opportunity oppr = new opportunity(Name='opp1' , Reason_Lost__c = 'Price was too high', EngageOpportunityTeam__c = false, AccountId= a.Id,StageName = 'Qualified Opportunity', Pricebook2Id = Test.getStandardPricebookId(), RecordTypeId = oppRecordTypeId, CloseDate = myDate);
        insert oppr;
        
        Product2 pro2 = new Product2(Name='BXCDXXX', isActive=true);
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=1,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),isActive=true,UseStandardPrice = false);
        insert pbe2;
        
        Site__c s = new Site__c(name = 'site',GEO_Approver__c=usr.id, EC_Approver__c = usr.id);
        insert s;
        
        //PricingCalculator__c pc = new PricingCalculator__c(Site__c = s.id, Opportunity__c = oppr.id); 
        //insert pc;
        
        Pricing_Model__c pm = new Pricing_Model__c(Opportunity__c = oppr.id, GEO_Approver__c=usr.id, Pricing_Round__c  = 'BAFO', Agent_Profile__c = 'Tier 1', Site__C = s.id, Channel__c = 'Voice', Service__c = 'Inbound Sales', status__c = 'Not Submitted');
        insert pm;
        
        List<OpportunityLineItem> opList = new List<OpportunityLineItem>();
        
        OpportunityLineItem ooli = new OpportunityLineItem (Quantity=2,UnitPrice=1, OpportunityId=oppr.Id, PriceBookEntryId=pbe2.Id); 
        ooli.Client_Preferred_Site__c = s.Id;
        ooli.AHT__c = 10000;
        ooli.FTE__c = 1000;
        ooli.Does_this_involve_seasonality__c = 'No';
        ooli.notes_on_Seasonality__c = '12';
        ooli.Estimated_Go_Live_Date__c =  Date.today().addMonths(12).addDays(12);
        ooli.Training_Length__c = 20;
        ooli.Billing_Mechanism_Final__c = 'Per Labor/Payroll Hour';
        ooli.Agent_Profile__c = 'Tier 1';
        ooli.Channel_s__c =  'Voice';
        ooli.Build_type__c = 'Refresh';
        ooli.Hours_of_Operation__c  = 'Basic 8 hrs 5 days';
//        ooli.Training_Billable__c = 'Yes';
        ooli.Language__c = 'English;Other';
        ooli.primary_product__c = true;
//      active remove here
        ooli.Pricing_Model__c = pm.id;
        ooli.Headcount__c = 100;
		ooli.Gross_Profit__c = 0.30;
        
        opList.add(ooli);
        OpportunityLineItem ooli2 = new OpportunityLineItem (Quantity=2,UnitPrice=1, OpportunityId=oppr.Id, PriceBookEntryId=pbe2.Id); 
        ooli2.Client_Preferred_Site__c = s.Id;
        ooli2.AHT__c = 10000;
        ooli2.FTE__c = 1000;
        ooli2.Headcount__c = 100;
        ooli2.Does_this_involve_seasonality__c = 'No';
        ooli2.notes_on_Seasonality__c = '12';
        ooli2.Estimated_Go_Live_Date__c =  Date.today().addMonths(12).addDays(12);
        ooli2.Training_Length__c = 20;
        ooli2.Billing_Mechanism_Final__c = 'Per Labor/Payroll Hour';
        ooli2.Agent_Profile__c = 'Tier 2';
        ooli2.Channel_s__c =  'Voice';
        ooli2.Build_type__c = 'Refresh';
        ooli2.Hours_of_Operation__c  = 'Basic 8 hrs 5 days';
//        ooli.Training_Billable__c = 'Yes';
        ooli2.Language__c = 'English;Other';
        ooli2.primary_product__c = true;
        ooli2.Gross_Profit__c = 0.30;
//      active remove here
        opList.add(ooli2); 
        
        Test.startTest();
        insert opList;
        Test.stopTest();
        
    }    
}