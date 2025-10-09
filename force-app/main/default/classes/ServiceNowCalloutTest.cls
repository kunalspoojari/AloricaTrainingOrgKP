/*
*   @Author: Ariel Tribunal
*   @Date: 8/7/2019
    
*   @Apex Name: ServiceNowCalloutTest
*   @Description: This test class is use for Service Now callout code coverage
*
*/
@isTest
private class ServiceNowCalloutTest {
    private static testMethod void testpassOppData() {
        //Load the sites and find Cutler.
		TestDataFactory.loadReferenceData();
        /*
        Site__c cutler = new Site__c();
        cutler.Name = 'Cutler Bay';
        cutler.Address__c = '19500 South Dixie Hwy';
        cutler.Agents_Wages_Tier_1__c = 12.0;
        cutler.Agents_Wages_Tier_2__c = 13.0;
        cutler.Agents_Wages_Tier_3__c = 14.0;
        cutler.Agent_Incentives__c = 4.25;
        cutler.Agent_Wage_Premium__c = 1.0;
        cutler.Annual_Agent_Hours__c = 	2080.0;
        cutler.Attrition_Production__c = 9.0;
        cutler.Attrition_Training__c = 14.0;
        
        
        
        
        insert cutler;*/
        
		Map<String, Site__c> siteMap = AloricaSiteDAO.getSitesMapByName(new List<String>{'Cutler Bay'});
		//System.assertEquals(1, siteMap.size());
		//Create an Account
		Account a = TestDataFactory.mockAccount();
		insert a;
        //Get the Cutler site
		Site__c cutler = siteMap.get('Cutler Bay');
		//System.assert(cutler != null);
		//System.assertEquals('Cutler Bay', cutler.Name);
		// Create Opportunity
		Opportunity opp = TestDataFactory.mockOpportunity(a.Id, cutler.Id, 'Classic', 'Proposal');
		//Opportunity opp = TestDataFactory.mockOpportunity(a.Id, '', 'Classic', 'Proposal');
        opp.Deal_Type__c = 'New Logo';
        insert opp;
        
        list<Id> loppId = new list<Id>();
        loppId.add(opp.Id);
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SNpassOppDataStatic');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        
        ServiceNowCallout.invoServiceNowCall(loppId);
    }
}