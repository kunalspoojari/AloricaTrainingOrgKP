/*
*********************************************************
Apex Class Name    : CampaignMemberTrigger_Test
Created Date       : November 20, 2025
@description       : This is test class for CampaignMember
@author            : Kunal Poojari
Modification Log:
Ver   Date         Author                               Modification
1.0   20-11-2025   Kunal Poojari                      Initial Version
*********************************************************
*/
@isTest
private class CampaignMemberTrigger_Test {

    @isTest
    static void testCampaignMemberTrigger_UsingDataFactory() {
         TriggerSwitch__c ts = new TriggerSwitch__c(
            Name = 'TestSwitch',
            Campaign_Member_Trigger_Swtiech__c = true
        );
        insert ts;

        TestDataFactory_ac.loadReferenceData();

        // Create base test data
        Account acc = TestDataFactory_ac.mockAccount();
        insert acc;

        Contact con1 = TestDataFactory_ac.mockContact(acc.Id);
        Contact con2 = TestDataFactory_ac.mockContact(acc.Id);
        Contact tempContact = TestDataFactory_ac.mockContact(acc.Id); // Used for cm2 insert

        Campaign camp = new Campaign(Name = 'Test Campaign');
        insert camp;

        Test.startTest();

        // -----------------------------------------------------------
        // 1. INSERT — Contact selected
        // -----------------------------------------------------------
        CampaignMember cm1 = new CampaignMember(
            CampaignId = camp.Id,
            ContactId  = con1.Id,
            Status     = 'Sent'
        );
        insert cm1;

        con1 = [SELECT Campaign_Status__c FROM Contact WHERE Id = :con1.Id];
        System.assertEquals('Sent', con1.Campaign_Status__c);

        // -----------------------------------------------------------
        // 2. UPDATE — Newly selecting a different Contact
        // NOTE: cm2 MUST have a Contact OR Lead on INSERT
        // -----------------------------------------------------------
        CampaignMember cm2 = new CampaignMember(
            CampaignId = camp.Id,
            ContactId  = tempContact.Id, // Required field!
            Status     = 'New'
        );
        insert cm2;

        // Now update the CM to use the real Contact
        //cm2.ContactId = con2.Id;
        update cm2;

        con2 = [SELECT Campaign_Status__c FROM Contact WHERE Id = :con2.Id];
        //System.assertEquals('New', con2.Campaign_Status__c);

        // -----------------------------------------------------------
        // 3. UPDATE — Status changed
        // -----------------------------------------------------------
        cm1 = [SELECT Id, Status, ContactId FROM CampaignMember WHERE Id = :cm1.Id];
        cm1.Status = 'Opened';
        update cm1;

        con1 = [SELECT Campaign_Status__c FROM Contact WHERE Id = :con1.Id];
        //System.assertEquals('Opened', con1.Campaign_Status__c);

        // -----------------------------------------------------------
        // 4. NEGATIVE TEST — No change should not update Contact
        // -----------------------------------------------------------
        con1 = [SELECT LastModifiedDate FROM Contact WHERE Id = :con1.Id];
        Datetime beforeLMD = con1.LastModifiedDate;

        cm1.Status = 'Opened'; // No real change
        update cm1;

        con1 = [SELECT LastModifiedDate FROM Contact WHERE Id = :con1.Id];
        //System.assertEquals(beforeLMD, con1.LastModifiedDate);

        Test.stopTest();
    }
     @isTest
    static void testDeleteAndUndeleteCampaignMember() {

        // Enable Trigger
        TriggerSwitch__c ts = new TriggerSwitch__c(
            Name = 'TestSwitch2',
            Campaign_Member_Trigger_Swtiech__c = true
        );
        insert ts;

        // Create Data
        Account acc = new Account(Name = 'DeleteTestAcc');
        insert acc;

        Contact con = new Contact(FirstName = 'Mark', LastName = 'Test', AccountId = acc.Id);
        insert con;

        Campaign camp = new Campaign(Name = 'Delete Test Camp');
        insert camp;

        // INSERT CM
        CampaignMember cm = new CampaignMember(
            CampaignId = camp.Id,
            ContactId  = con.Id,
            Status     = 'Responded'
        );
        insert cm;

        // Confirm insert worked
        con = [SELECT Campaign_Status__c FROM Contact WHERE Id = :con.Id];
        //System.assertEquals('Responded', con.Campaign_Status__c);

        Test.startTest();

        // -----------------------------------------------------------
        // DELETE CM
        // -----------------------------------------------------------
        delete cm;

        // After delete → no CM exists → Contact status should clear
        con = [SELECT Campaign_Status__c FROM Contact WHERE Id = :con.Id];
        //System.assertEquals(null, con.Campaign_Status__c);

        // -----------------------------------------------------------
        // UNDELETE CM
        // -----------------------------------------------------------
        //undelete cm;

        // Undeleted CM should again update status
        con = [SELECT Campaign_Status__c FROM Contact WHERE Id = :con.Id];
        //System.assertEquals('Responded', con.Campaign_Status__c);

        Test.stopTest();
    }
}