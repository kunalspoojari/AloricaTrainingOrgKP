@isTest
public class SendZeroTCVReminderTest {

    @testSetup
    static void setup() {

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

        Account a = new Account(Name = 'Test Account');
        insert a;

        Contact c = new Contact(
            LastName = 'Contact',
            Email = 'test' + System.currentTimeMillis() + '@example.com',
            AccountId = a.Id
        );
        insert c;

Opportunity opp = new Opportunity( 
    Name = 'Test Opportunity', 
    CloseDate = Date.today().addDays(10), 
    StageName = 'Qualified', 
    OwnerId = u.Id,
    GSTApprover__c = u.id, 
    ECApprover__c = u.id, 
    AccountId= a.Id,
    GeoApprover__c= u.id, 
    Business_Development_Assignee__c = u.id, 
    Client_Contact__c = c.Id ); 
        insert opp;
        
        opp.StageName = 'Qualified'; 
        update opp;

        // 🔑 THIS is what drives Net_TCV_growth__c
        Model__c modelRec = new Model__c(
            Opportunity__c = opp.Id,
            Model_Net_TCV_Growth__c = 100,
            Active__c = true
        );
        insert modelRec;
    }

    @isTest
    static void testReminderEmailExecution() {

        Test.startTest();
        new SendZeroTCVReminder().execute(null);
        Test.stopTest();

    }
}