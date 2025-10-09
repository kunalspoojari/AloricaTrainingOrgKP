/*
*   @Author: Ariel Tribunal
*   @Date: 10/1/2019
*   @Apex Name: OpportunityPdfEmailControllerTest
*   @Description: This test class is use for OpportunityPdfEmailController coverage
*
*/
@isTest
private class OpportunityPdfEmailControllerTest {
    private static testMethod void testcontroller() {
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
        
        //Simulate uploading a file in the opportunity
        ContentVersion content=new ContentVersion();
        content.Title='Test';
        content.PathOnClient='/' + content.Title + '.jpg';
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body');
        content.VersionData=bodyBlob;
        content.origin = 'H';
        insert content;
        ContentDocumentLink File=new ContentDocumentLink();
        File.LinkedEntityId=opp.id;
        File.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        File.ShareType = 'V';
        insert File;
        
        Test.StartTest(); 

        PageReference pageRef = Page.OpportunityPdfEmail; // Add your VF page Name here
        pageRef.getParameters().put('stage', 'Contract');
        pageRef.getParameters().put('snprojid', 'PRJ0010383');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        OpportunityPdfEmailController testAccPlan = new OpportunityPdfEmailController(sc);
        
        Test.StopTest();
    }
}