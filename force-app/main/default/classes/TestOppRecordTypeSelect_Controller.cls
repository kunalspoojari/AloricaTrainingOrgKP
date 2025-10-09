@isTest
public class TestOppRecordTypeSelect_Controller {
    
    static testMethod void Testmethod1() {
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Industry = 'Communications';
        acc.Inside_Sales_Owner__c = 'Account Owner';   
        
        insert acc;
        
       // System.assert(acc.Id !=null, 'Account got created : '+acc.Id);
       
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        /*opp.Additional_Notes_to_Pricing_Team__c = 'test';*/
        opp.Name = 'Test Opportunity';
        opp.CloseDate = Date.today().addMonths(12).addDays(-1);
        opp.StageName = 'Qualified Opportunity';
        opp.Deal_Type__c = 'New Logo';
        opp.Vertical__c = 'Energy & Utilities';
        opp.Business_Type__c = 'B2B';
        opp.Reason_Lost__c = 'Price was too high';
        opp.QualifyApprovedDate__c = Date.today().addMonths(2).addDays(-1);
        opp.RecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Lightning').getRecordTypeId();
        insert opp;
        
        Test.startTest();
        
        PageReference pref = Page.Opportunity_RecordType_Select;
        Test.setCurrentPage(pref);
        ApexPages.StandardController con = new ApexPages.StandardController(opp);
        ApexPages.currentPage().getParameters().put('accid',opp.id);
        opporunityRecorTypeSelect_Controller ext = new opporunityRecorTypeSelect_Controller(con);

       
        PageReference ref = ext.cont();
        ext.getmyOptions();
        PageReference reRend = new PageReference('/006/e?retURL=%2F006%2Fo&RecordType='+ opp.RecordTypeId +'&ent=Opportunity'+'&accid='+opp.id);
        Test.stopTest();
    }
    
    static testMethod void Testmetho2() {
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Industry = 'Communications';
        acc.Inside_Sales_Owner__c = 'Account Owner';   
        
        insert acc;
        
       // System.assert(acc.Id !=null, 'Account got created : '+acc.Id);
       
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        /*opp.Additional_Notes_to_Pricing_Team__c = 'test';*/
        opp.Name = 'Test Opportunity';
        opp.CloseDate = Date.today().addMonths(12).addDays(-1);
        opp.StageName = 'Qualified Opportunity';
        opp.Deal_Type__c = 'New Logo';
        opp.Vertical__c = 'Energy & Utilities';
        opp.Business_Type__c = 'B2B';
        opp.Reason_Lost__c = 'Price was too high';
        opp.QualifyApprovedDate__c = Date.today().addMonths(2).addDays(-1);
        opp.RecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Classic').getRecordTypeId();
        insert opp;
        
        ApexPages.StandardController con = new ApexPages.StandardController(opp);
        opporunityRecorTypeSelect_Controller ext = new opporunityRecorTypeSelect_Controller(con);
        Test.startTest();
        ext.getmyOptions();
        PageReference ref = ext.cont();
        
        PageReference reRend = new PageReference('/006/e?retURL=%2F006%2Fo&RecordType='+ opp.RecordTypeId +'&ent=Opportunity');
        Test.stopTest();
    }
}