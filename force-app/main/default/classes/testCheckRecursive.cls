@isTest 
public class testCheckRecursive
{
    static testMethod void testMethod1() 
    {
    
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Industry = 'Communications';
        acc.Inside_Sales_Owner__c = 'Account Owner';   
        
        insert acc;
        
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
        
        
        checkRecursive.runOnce();
        
        update opp;
        
    }
}