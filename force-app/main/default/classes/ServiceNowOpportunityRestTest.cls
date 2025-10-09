/*
*   @Author: Ariel Tribunal
*   @Date: 8/26/2019
*   @Apex Name: ServiceNowOpportunityRestTest
*   @Description: This test class is use for Service Now Opportunity Rest coverage
*
*/
@isTest
private class ServiceNowOpportunityRestTest {
    
    // Helper method
    static Id createOppRecord() {
        //Load the sites and find Cutler.
        TestDataFactory.loadReferenceData();
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
        insert opp;
        return opp.Id;
        
    }

    static testMethod void testPatch() {
        Id opId = createOppRecord();
        String oppId = String.valueOf(opId);
              
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse(); 
        //req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/Opportunity'; 
        //req.httpMethod = 'PATCH';
        //req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf('{"u_opportunity_id": "' + oppId + '","u_project_id": "ProjectId12"}');
        //req.requestBody = Blob.valueOf('{"u_opportunity_id": "' + o.Id + '","u_project_id": "ProjectId12"}');
        RestContext.request = req;
        RestContext.response = res;
        // Update Project Id of existing record
        ServiceNowOpportunityRest.updateOpportunityFields();
        // Verify the Opportunity Project ID was updated
        Opportunity thisOpp = [select Id, ServiceNow_Project_ID__c from Opportunity where Id=:oppId];
        //Opportunity thisOpp = [select Id, ServiceNow_Project_ID__c from Opportunity where Id=:o.Id];
        system.assert(thisOpp != null);
        System.assertEquals(thisOpp.ServiceNow_Project_ID__c, 'ProjectId12');
    }
    
    static testMethod void testPatchErrOppId() {
        Id opId = createOppRecord();
        String oppId = String.valueOf(opId);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse(); 
        //req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/Opportunity'; 
        //req.httpMethod = 'PATCH';
        //req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf('{"u_opportunity_id": "' + 'InvalidOppId' + '","u_project_id": "ProjectId12"}');
        RestContext.request = req;
        RestContext.response = res;
        // Update Invalid Opportunity ID
        ServiceNowOpportunityRest.updateOpportunityFields();
        // Verify the Opportunity Project ID was not updated
        Opportunity thisOpp = [select Id, ServiceNow_Project_ID__c from Opportunity where Id=:oppId];
        system.assert(thisOpp != null);
        system.assertEquals(thisOpp.ServiceNow_Project_ID__c, null);
    }
}