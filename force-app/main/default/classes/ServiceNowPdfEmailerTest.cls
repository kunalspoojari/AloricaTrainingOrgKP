/*
*   @Author: Ariel Tribunal
*   @Date: 10/01/2019
*   @Apex Name: ServiceNowPdfEmailerTest
*   @Description: This test class is use for ServiceNowPdfEmailer coverage
*
*/
@isTest
private class ServiceNowPdfEmailerTest {
    private static testMethod void testsendEmail(){
        //Load the sites and find Cutler.
        TestDataFactory.loadReferenceData();
        Map<String, Site__c> siteMap = AloricaSiteDAO.getSitesMapByName(new List<String>{'Cutler Bay'});
        System.assertEquals(1, siteMap.size());
        //Create an Account
        Account a = TestDataFactory.mockAccount();
        insert a;
        //Get the Cutler site
        Site__c cutler = siteMap.get('Cutler Bay');
        System.assert(cutler != null);
        System.assertEquals('Cutler Bay', cutler.Name);
        // Create Opportunity
        Opportunity opp = TestDataFactory.mockOpportunity(a.Id, cutler.Id, 'Classic', 'Proposal');
        opp.Deal_Type__c = 'New Logo';
        insert opp;
        
        Test.StartTest(); 
        
        list<Id> loppId = new list<Id>();
        loppId.add(opp.Id);
        
        ServiceNowPdfEmailer.sendEmail(loppId);
        Test.StopTest();
    }
}