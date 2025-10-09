/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 * Apttus Contract Management
 * SendEmailPreProcessControllerTest
 *
 * @2016 Apttus Inc. All rights reserved.
 */
@isTest
private class SendEmailPreProcessControllerTest {
    static testmethod void test1() {
        
        SendEmailPreProcessControllerTest testController = new SendEmailPreProcessControllerTest();
    
        // test the continue action 
        testController.testLoad();
        
    }
    
    /**
     * Class Constructor
     */
    private SendEmailPreProcessControllerTest() {
        
    }
        
    private void testLoad() {
        Account testAcc = new Account();
        testAcc.Name = 'Test Account';
        testAcc.APTS_Company_Type__c = 'a limited liability company';
    	insert testAcc;
        Apttus__APTS_Agreement__c agreementSO = new Apttus__APTS_Agreement__c();
        agreementSO.Name = 'Name ';
                agreementSO.Apttus__Account__c = testAcc.Id;
                
                
                agreementSO.Apttus__Contract_End_Date__c = Date.Today();
                agreementSO.Apttus__Status_Category__c = 'In Authoring';
                agreementSO.Apttus__Status__c = '';
        insert agreementSO; 
        
        PageReference currPage = Page.SendEmailPreProcess;                                                        
        Test.setCurrentPage(currPage);
        System.currentPageReference().getParameters().put('id', agreementSO.id);
        System.currentPageReference().getParameters().put('action', 'Send_To_Other_Party_For_Review');
        // Create the page controller
        SendEmailPreProcessController controller = new SendEmailPreProcessController(new ApexPages.StandardController(agreementSO));
        
    }
}