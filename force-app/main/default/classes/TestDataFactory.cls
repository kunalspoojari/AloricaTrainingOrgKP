@isTest 
public class TestDataFactory {
    public static String CSV_Site = 'TestData_AloricaSites';
    public static String Opp_RT_PricingCalculator = 'Lightning';
    public static String Opp_RT_Qualified = 'Qualified_Lead';
    public static String Opp_Stage_Qualified = 'Qualified Lead';
    
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
}