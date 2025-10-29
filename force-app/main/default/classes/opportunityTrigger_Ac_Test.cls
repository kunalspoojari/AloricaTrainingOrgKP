@isTest
public class opportunityTrigger_Ac_Test {

    @testSetup
    static void setupData() {
        TriggerSwitch__c cs = TriggerSwitch__c.getInstance();
        cs.Opportunity_Trigger_Check__c = true;   // <---- THIS ENABLES YOUR TRIGGER
        upsert cs;
        // Load reference data if your factory expects it (optional)
        TestDataFactory_ac.loadReferenceData();
        
        // Create a reusable Account
        Account acc = TestDataFactory_ac.mockAccount();
        insert acc;

        // Store for reuse in tests
        System.assertNotEquals(null, acc.Id, 'Account should be inserted in testSetup');
    }

    @isTest
    static void testBeforeInsert_UsingFactory() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        system.debug('line 20-->' + acc);

        // Create an Opportunity using your factory
        Opportunity opp = TestDataFactory_ac.mockOpportunity_Count(
            acc.Id,
            
            null, // Assuming Site__c not required for trigger
            'Existing_LOB',
            'Qualified'
        );

        Test.startTest();
        insert opp;
        Test.stopTest();
        opp = [SELECT ac_Qualified_Count__c, ac_Closed_Won_Count__c, ac_Closed_Lost__c,RecordTypeId FROM Opportunity WHERE Id = :opp.Id];
        //system.debug('line 35-->' + opp.RecordtypeId);
        //System.assertEquals(1, opp.ac_Qualified_Count__c, 'Qualified count initialized correctly');
        //System.assertEquals(0, opp.ac_Closed_Won_Count__c, 'Closed Won count should start as 0');
        //System.assertEquals(0, opp.ac_Closed_Lost__c, 'Closed Lost count should start as 0');
    }

    @isTest
    static void testBeforeUpdate_ForwardStageChange_UsingFactory() {
        Account acc = [SELECT Id FROM Account LIMIT 1];

        Opportunity opp = TestDataFactory_ac.mockOpportunity_Count(
            acc.Id,
            null,
            'Existing_LOB',
            'Qualified'
        );
        insert opp;

        // Move forward in stage
        opp.VerbalWinDate__c=System.Today();
        opp.StageName = 'Verbal Win';
        Test.startTest();
        update opp;
        Test.stopTest();

        opp = [SELECT ac_Qualified_Count__c, ac_Verbal_Win_Count__c,RecordTypeId FROM Opportunity WHERE Id = :opp.Id];
        //System.assertEquals(1, opp.ac_Verbal_Win_Count__c, 'Verbal Win count should be set to 1');
        //System.assertEquals(0, opp.ac_Qualified_Count__c, 'Qualified count should reset to 0');
    }

    @isTest
    static void testBeforeUpdate_BackwardStageChange_UsingFactory() {
        Account acc = [SELECT Id FROM Account LIMIT 1];

        Opportunity opp = TestDataFactory_ac.mockOpportunity_Count(
            acc.Id,
            null,
            'Existing_LOB',
            'Pricing'
        );
        insert opp;

        // Move backward in stage
        opp.StageName = 'Qualified';
        Test.startTest();
        update opp;
        Test.stopTest();

        opp = [SELECT ac_Qualified_Count__c, ac_Contract_Negotiation_Count__c,RecordTypeId FROM Opportunity WHERE Id = :opp.Id];
        //System.assertEquals(1, opp.ac_Qualified_Count__c, 'Qualified should be 1 after moving back');
        //System.assertEquals(0, opp.ac_Contract_Negotiation_Count__c, 'Contract Negotiation should reset to 0');
    }

 
}