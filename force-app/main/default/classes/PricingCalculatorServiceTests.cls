@isTest 
private class PricingCalculatorServiceTests {

	@isTest
	private static void testAutoCreate() {
		Test.startTest();
		//Load the sites and find Cutler.
		TestDataFactory.loadReferenceData();
		Map<String, Site__c> siteMap = AloricaSiteDAO.getSitesMapByName(new List<String>{'Cutler Bay'});
		System.assertEquals(1, siteMap.size());

		//Create an Account and Opp
		Account a = TestDataFactory.mockAccount();
		insert a;

		//Get the Cutler site
		Site__c cutler = siteMap.get('Cutler Bay');
		System.assert(cutler != null);
		System.assertEquals('Cutler Bay', cutler.Name);
	
        
        Opportunity pricingOpp = TestDataFactory.mockPricingOpportunity(a.Id, cutler.Id);

		//Test that Pricing Calculator gets created upon Opp insert (Process Builder)
		

		insert pricingOpp;
		//Ensure Pricing Calculator created.
		//List<PricingCalculator__c> pcs = [Select Id, Site__c, Opportunity__c from PricingCalculator__c];

		//System.assertEquals(1, pcs.size());
		//System.assertEquals(pricingOpp.Id, pcs[0].Opportunity__c);
        Test.stopTest();
	}
}