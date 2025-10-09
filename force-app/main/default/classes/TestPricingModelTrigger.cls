@isTest
private class TestPricingModelTrigger {
    static testMethod void testmethod1() {
    	
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Lightning').getRecordTypeId();
        
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
        
        Account a = new Account(Name ='icrm testing acc');
        insert a;
        
        Date myDate = date.today();
        opportunity oppr = new opportunity(Name='opp1' ,GeoApprover__c= usr.id,Reason_Lost__c = 'Price was too high', GSTApprover__c = usr.id, ECApprover__c = usr.id, AccountId= a.Id,StageName = 'Qualified Opportunity', RecordTypeID = devRecordTypeId, CloseDate = myDate);
        insert oppr;
        
        Site__c s = new Site__c(name = 'site',GEO_Approver__c=usr.id, EC_Approver__c = usr.id);
        insert s;
        
        Pricing_Model__c pm = new Pricing_Model__c(Opportunity__c = oppr.id, Pricing_Round__c  = 'BAFO', Agent_Profile__c = 'Tier 1', Site__C = s.id, Channel__c = 'Voice', Service__c = 'Inbound Sales', status__c = 'Not Submitted');
        insert pm;
        
        Test.startTest();
        Pricing_Model__c pm1 = new Pricing_Model__c(Opportunity__c = oppr.id, Pricing_Round__c  = 'BAFO', Agent_Profile__c = 'Tier 2', Site__C = s.id, Channel__c = 'Voice', Service__c = 'Inbound Sales', status__c = 'Not Submitted');
        insert pm1;
        Test.stopTest();
    }
}