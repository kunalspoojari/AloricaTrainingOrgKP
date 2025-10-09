@isTest
public class APTS_AgreementUploadSignedControllerTest {
    public static testmethod void testmeth()
    {
        Account testAcc = new Account();
        testAcc.Name = 'Test Account';
        testAcc.APTS_Company_Type__c = 'a limited liability company';
    	insert testAcc;
        
        Apttus__APTS_Agreement__c newAg = new Apttus__APTS_Agreement__c();
                
                newAg.Name = 'Name ';
                newAg.Apttus__Account__c = testAcc.Id;
                
                
                newAg.Apttus__Contract_End_Date__c = Date.Today();
                newAg.Apttus__Status_Category__c = 'In Effect';
                newAg.Apttus__Status__c = 'Activated';
                insert newAg;
        
        PageReference pr = new PagEReference('/apex/APTS_AgreementUploadSigned?id=' + newag.Id + '&signed=fully');
        test.startTest();
        test.setCurrentPage(pr);
        
        
        APTS_AgreementUploadSignedController testCont = new APTS_AgreementUploadSignedController();
        testCont.upload();
        pr = new PagEReference('/apex/APTS_AgreementUploadSigned?id=' + newag.Id + '&signed=partially');
                test.setCurrentPage(pr);
		testCont.upload();
        test.stopTest();
    }
}