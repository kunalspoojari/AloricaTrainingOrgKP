@isTest
public class SendZeroTCVReminderTest {

    @testSetup
    static void setup() {
        // Create a test user
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User u = new User(
            FirstName = 'Test',
            LastName = 'Owner',
            Email = 'testowner@example.com',
            Username = 'testowner' + System.currentTimeMillis() + '@example.com',
            Alias = 'tstown',
            TimeZoneSidKey = 'Asia/Kolkata',
            LocaleSidKey = 'en_IN',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id
        );
        insert u;

        Account a = new Account(Name ='icrm testing acc');
        insert a;
        
        Contact con = new Contact(FirstName = 'Test',LastName = 'Contact',Email = 'testcontact' + Math.abs(Crypto.getRandomInteger()) + '@example.com',AccountId = a.Id);
        insert con;
        
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            CloseDate = Date.today().addDays(10),
            StageName = 'Qualified',
            OwnerId = u.Id,GSTApprover__c = u.id, ECApprover__c = u.id, AccountId= a.Id,GeoApprover__c= u.id,
            Business_Development_Assignee__c = u.id, Client_Contact__c = con.Id
        );
        insert opp;
        opp.StageName = 'Qualified';
        update opp;
        Model__c modelRec = new Model__c(
            Opportunity__c = opp.Id,
            Model_Net_TCV_Growth__c = 100, // This gets ignored because Active = false
            Active__c = false
        );
        insert modelRec;
        system.debug('NET TCV: '+opp.Net_TCV_growth__c);
        system.debug('Stage: '+opp.StageName);
    }

    @isTest
    static void testReminderEmail() {

        Test.startTest();

        // Call the schedulable class
        SendZeroTCVReminder job = new SendZeroTCVReminder();
        job.execute(null);

        Test.stopTest();

    }
}