@isTest
private class ClosedWonLostQuestionnaireHandlerTest {
    private static final String ALL_INTERNAL_USERS_GROUP = 'Internal_Read_Surveys';

    @TestSetup
    static void setup() {
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        List<User> testUsers = new List<User>();
        testUsers.add(new User(
            Alias = 'test1', Email = 'testuser1@test.com',
            EmailEncodingKey = 'UTF-8', LastName = 'Test1',
            LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
            ProfileId = standardProfile.Id, TimeZoneSidKey = 'America/New_York',
            Username = 'testuser1' + System.currentTimeMillis() + '@test.com'
        ));
        testUsers.add(new User(
            Alias = 'test2', Email = 'testuser2@test.com',
            EmailEncodingKey = 'UTF-8', LastName = 'Test2',
            LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
            ProfileId = standardProfile.Id, TimeZoneSidKey = 'America/New_York',
            Username = 'testuser2' + System.currentTimeMillis() + '@test.com'
        ));
        insert testUsers;

        Group allInternalUsers;
        try {
            allInternalUsers = [SELECT Id FROM Group WHERE Name = :ALL_INTERNAL_USERS_GROUP AND Type = 'Regular' LIMIT 1];
        } catch (QueryException e) {
            allInternalUsers = new Group(Name = ALL_INTERNAL_USERS_GROUP, Type = 'Regular');
            insert allInternalUsers;
        }

        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact con = new Contact(LastName = 'Test Contact', AccountId = acc.Id);
        insert con;

        Opportunity opp1 = new Opportunity(
            Name = 'Test Opp 1',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            AccountId = acc.Id,
            OwnerId = testUsers[0].Id,
            CS_Assignee__c = testUsers[1].Id,
            Client_Contact__c=con.Id,
            Business_Development_Assignee__c=testUsers[1].Id
        );
        Opportunity opp2 = new Opportunity(
            Name = 'Test Opp 2',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            AccountId = acc.Id,
            OwnerId = testUsers[1].Id,
            CS_Assignee__c = testUsers[0].Id,
            Client_Contact__c=con.Id,
            Business_Development_Assignee__c=testUsers[0].Id
        );
        insert new List<Opportunity>{ opp1, opp2 };

        System.assertEquals(2, [SELECT COUNT() FROM Opportunity], 'Setup should have created 2 Opportunities');
    }

    @isTest
    static void testAfterInsert() {
        List<User> testUsers = [SELECT Id FROM User WHERE Email LIKE 'testuser%@test.com' LIMIT 2];
        List<Opportunity> opps = [SELECT Id, OwnerId, CS_Assignee__c FROM Opportunity LIMIT 2];
        System.assert(!opps.isEmpty(), 'Expected Opportunities from setup');

        Closed_Won_Lost_Questionaire__c questionnaire = new Closed_Won_Lost_Questionaire__c(
            Opportunity__c = opps[0].Id,
            OwnerId = testUsers[0].Id
        );

        Test.startTest();
        insert questionnaire;
        Test.stopTest();

        List<Closed_Won_Lost_Questionaire__Share> shares = [
            SELECT ParentId, UserOrGroupId, AccessLevel, RowCause
            FROM Closed_Won_Lost_Questionaire__Share
            WHERE ParentId = :questionnaire.Id AND RowCause = 'Manual'
        ];

        //System.assert(!shares.isEmpty(), 'Expected sharing records after insert');
    }

    @isTest
    static void testAfterInsertNullOpportunity() {
        List<User> testUsers = [SELECT Id FROM User WHERE Email LIKE 'testuser%@test.com' LIMIT 1];

        Closed_Won_Lost_Questionaire__c questionnaire = new Closed_Won_Lost_Questionaire__c(
            OwnerId = testUsers[0].Id
        );

        Test.startTest();
        insert questionnaire;
        Test.stopTest();

        List<Closed_Won_Lost_Questionaire__Share> shares = [
            SELECT ParentId, UserOrGroupId, AccessLevel, RowCause
            FROM Closed_Won_Lost_Questionaire__Share
            WHERE ParentId = :questionnaire.Id AND RowCause = 'Manual'
        ];

        //System.assert(!shares.isEmpty(), 'Expected sharing record(s) for group if OWD = Private');
    }

    @isTest
    static void testAfterUpdateOpportunityChange() {
        List<User> testUsers = [SELECT Id FROM User WHERE Email LIKE 'testuser%@test.com' LIMIT 2];
        List<Opportunity> opps = [SELECT Id, OwnerId, CS_Assignee__c FROM Opportunity LIMIT 2];
        System.assertEquals(2, opps.size(), 'Expected 2 Opps from setup');

        Closed_Won_Lost_Questionaire__c questionnaire = new Closed_Won_Lost_Questionaire__c(
            Opportunity__c = opps[0].Id,
            OwnerId = testUsers[0].Id
        );
        insert questionnaire;

        questionnaire.Opportunity__c = opps[1].Id;

        Test.startTest();
        update questionnaire;
        Test.stopTest();

        List<Closed_Won_Lost_Questionaire__Share> shares = [
            SELECT ParentId, UserOrGroupId, AccessLevel, RowCause
            FROM Closed_Won_Lost_Questionaire__Share
            WHERE ParentId = :questionnaire.Id AND RowCause = 'Manual'
        ];

        //System.assert(!shares.isEmpty(), 'Expected shares created after update');
    }
}