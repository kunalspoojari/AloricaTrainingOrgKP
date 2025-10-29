@isTest 
public class TestDataFactory_ac {
    public static String CSV_Site = 'TestData_AloricaSites';
    public static String Opp_RT_PricingCalculator = 'Lightning';
    public static String Opp_RT_Qualified = 'Qualified_Lead';
    public static String Opp_Stage_Qualified = 'Qualified Lead';
    public static String New_Client = 'New Client';

    
    @isTest
    public static void loadReferenceData() {     
        loadSiteData();
    }
    
    public static void loadSiteData() {       
        List<Site__c> sites = Test.loadData(Site__c.sObjectType, CSV_Site);
        System.assertEquals(1, sites.size());
        System.assertEquals('Cutler Bay', sites[0].Name);
    }
    
    public static Account mockAccount() {
        Account a = new Account();
        a.Name = 'TestAccount';
        a.Inside_Sales_Owner__c = 'InsideSalesOwner';
        a.Industry = 'Technology';
        return a;
    }
     public static Contact mockContact(Id accountId) {
         Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.Email = 'testcontact' + DateTime.now().getTime() + '@example.com';
        c.Phone = '9999999999';
        c.Title = 'IT Manager';
        c.LeadSource = 'Employee Referral';
        
        if (accountId != null) {
            c.AccountId = accountId;
        } else {
            // Create a temporary Account if not provided
            Account acc = TestDataFactory_ac.mockAccount();
            insert acc;
            c.AccountId = acc.Id;
        }
        insert c;
        return c;
    }
    
    public static Opportunity mockOpportunity(Id accountId, Id siteId, String recordTypeDevName, String stageName) {
        Opportunity o = new Opportunity();
        o.AccountId = accountId;
        o.Reason_Lost__c = 'Price was too high';
        o.Name = 'TestAccount - TestOpp';
        o.CloseDate = Date.today().addMonths(2);
        o.StageName = stageName;
        o.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(recordTypeDevName).getRecordTypeId();
        return o;
    }
     public static Opportunity mockOpportunity_Count(Id accountId, Id siteId, String recordTypeDevName, String stageName) {
        Opportunity o = new Opportunity();
        o.AccountId = accountId;
        o.Deal_Type__c='New Channel';
        o.Description='Test';
        o.Opportunity_Source__c='Competitive Steal';
        User adminUser = getAdminUser();
        o.Business_Development_Assignee__c=adminUser.Id;
        Contact conTest =TestDataFactory_ac.mockContact(accountId);
        o.ContactId=conTest.id;
        o.Client_Contact__c=conTest.id;
        //o.Client_Contact__c=
        //o.Reason_Lost__c = 'Price was too high';
        o.Name = 'TestAccount - TestOpp';
        o.CloseDate = Date.today().addMonths(2);
        o.StageName = stageName;
        o.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(recordTypeDevName).getRecordTypeId();
        return o;
    }
    
    public static Opportunity mockPricingOpportunity(Id accountId, Id siteId) {    
        Opportunity o = mockOpportunity(accountId, siteId, TestDataFactory.Opp_RT_PricingCalculator, TestDataFactory.Opp_Stage_Qualified);
        return o;
    }
    
    @isTest
    static void testGenerateDataMethod() {
        Test.startTest();
        DataFactory df = new DataFactory();
        df.generateData();
        
        List<SObject> dummyRecords = new List<SObject>(); 
        BatchRecordCreator creator = new BatchRecordCreator(dummyRecords);
        creator.newMethod();
    }
    //Created by Kunal Poojari
       //  Helper: Get or create an Admin user for assignment
    private static User getAdminUser() {
        // Try to find an existing System Administrator user
        List<User> adminUsers = [
            SELECT Id, Profile.Name 
            FROM User 
            WHERE Profile.Name = 'System Administrator' 
            LIMIT 1
        ];
        if (!adminUsers.isEmpty()) {
            return adminUsers[0];
        }

        // If not found (e.g., in scratch org or isolated test context), create one
        Profile adminProfile = [
            SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1
        ];

        User u = new User(
            FirstName = 'Test',
            LastName = 'Admin',
            Email = 'testadmin@example.com',
            Username = 'testadmin' + DateTime.now().getTime() + '@example.com',
            Alias = 'tadm',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = adminProfile.Id
        );
        insert u;
        return u;
    }
}