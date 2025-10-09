@isTest
private class APTS_AttachmentTriggerHandlerTest {
	static Account testAccount;
	static Apttus__APTS_Agreement__c testAgreement;

	static{
		testAccount = new Account();
		testAccount.Name = 'APTS_AttachmentTriggerHandlerTest';
		insert testAccount;

		testAgreement = new Apttus__APTS_Agreement__c();
		testAgreement.Name = 'APTS_AttachmentTriggerHandlerTest';
		testAgreement.Apttus__Account__c = testAccount.Id;
		testAgreement.Apttus__Contract_Start_Date__c = Date.today();
        testAgreement.Apttus__Contract_End_Date__c = Date.today().addMonths(12);
		insert testAgreement;
	}

	@isTest static void activation_Test() {
		Attachment testAttachment = new Attachment();
		testAttachment.Name = 'activation_Test:_Activated.pdf';
		testAttachment.parentId = testAgreement.Id;
		testAttachment.Body =  Blob.valueOf('APTS_AttachmentTriggerHandlerTest');
		insert testAttachment;
        
        testAttachment.Name = 'activation_Test_Activated.pdf';
        update testAttachment;
        delete testAttachment;
        undelete testAttachment;
	}
}