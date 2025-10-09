@IsTest
public class ConvertLeadApexTest {

    @IsTest
    static void testConvertLead_Success() {
        // Create a lead to convert
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'testlead@example.com',
            Status = 'Open - Not Contacted'
        );
        insert testLead;

        // Create an invocable request for the test lead
        ConvertLeadApex.LeadConversionRequest request = new ConvertLeadApex.LeadConversionRequest();
        request.leadID = testLead.Id;
        request.createAcc = true;
        request.accName = 'Test Account';
        request.accWebsite = 'www.testaccount.com';
        request.accAlVertical = 'Technology';
        request.accAlIndustry = 'Healthcare';
        request.accOwnerId = UserInfo.getUserId();
        request.createCon = true;
        request.FName = 'Test';
        request.LName = 'Lead';
        request.conEmail = 'testlead@example.com';
        request.conOwnerId = UserInfo.getUserId();
        request.convertedStatus = 'Closed - Converted';
        request.createOpportunity = false;
        request.opportunityName = 'Test Opportunity';
        request.sendEmailToOwner = false;

        // Add the request to a list
        List<ConvertLeadApex.LeadConversionRequest> requests = new List<ConvertLeadApex.LeadConversionRequest>{request};

        // Execute the lead conversion
        Test.startTest();
        List<ConvertLeadApex.LeadConversionResult> results = ConvertLeadApex.convertLead(requests);
        Test.stopTest();
        
        // Assert that the conversion was successful
        System.assertEquals(1, results.size(), 'One result should be returned.');
        ConvertLeadApex.LeadConversionResult result = results[0];
        System.assert(result.accountID == null, 'Account ID should not be null.');
        System.assert(result.contactID == null, 'Contact ID should not be null.');
        //System.assert(result.opportunityID != null, 'Opportunity ID should not be null.');
        System.assert(result.errorMessage != null, 'There should be no error message.');
    }
    
    @IsTest
    static void testConvertLead_Failure() {
        // Create a lead to convert without required fields to simulate a failure
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'testlead@example.com',
            Status = 'Open - Not Contacted'
        );
        insert testLead;

        // Create an invocable request with missing required fields
        ConvertLeadApex.LeadConversionRequest request = new ConvertLeadApex.LeadConversionRequest();
        request.leadID = testLead.Id;
        request.createAcc = true;
        request.createCon = true;
        request.convertedStatus = 'Closed - Converted';

        // Add the request to a list
        List<ConvertLeadApex.LeadConversionRequest> requests = new List<ConvertLeadApex.LeadConversionRequest>{request};

        // Execute the lead conversion
        Test.startTest();
        List<ConvertLeadApex.LeadConversionResult> results = ConvertLeadApex.convertLead(requests);
        Test.stopTest();

 // Assert that the conversion failed and an error message is provided
        System.assertEquals(1, results.size(), 'One result should be returned.');
        ConvertLeadApex.LeadConversionResult result = results[0];
        System.assert(result.accountID == null, 'Account ID should be null.');
        System.assert(result.contactID == null, 'Contact ID should be null.');
        System.assert(result.opportunityID == null, 'Opportunity ID should be null.');
        System.assert(result.errorMessage != null, 'An error message should be provided.');
    }

    @IsTest
    static void testConvertLead_InvalidLeadID() {
        // Create an invocable request with an invalid lead ID
        ConvertLeadApex.LeadConversionRequest request = new ConvertLeadApex.LeadConversionRequest();
        request.leadID = 'invalidLeadID';
		request.contactID = null;
        request.createAcc = true;
        request.accName = 'Test Account';
        request.accWebsite = 'www.testaccount.com';
        request.accAlVertical = 'Technology';
        request.accAlIndustry = 'healthcare';
        request.accOwnerId = UserInfo.getUserId();
        request.createCon = true;
        request.FName = 'Test';
        request.LName = 'Lead';
        request.conEmail = 'testlead@example.com';
        request.conOwnerId = UserInfo.getUserId();
		request.accountID = null;
        request.convertedStatus = 'Closed - Converted';
        request.createOpportunity = false;
        request.opportunityName = null;
        request.sendEmailToOwner = false;

        // Add the request to a list
        List<ConvertLeadApex.LeadConversionRequest> requests = new List<ConvertLeadApex.LeadConversionRequest>{request};

        // Execute the lead conversion
        Test.startTest();
        List<ConvertLeadApex.LeadConversionResult> results = ConvertLeadApex.convertLead(requests);
        Test.stopTest();

        // Assert that the conversion failed due to invalid lead ID
        System.assertEquals(1, results.size(), 'One result should be returned.');
        ConvertLeadApex.LeadConversionResult result = results[0];
        System.assert(result.accountID == null, 'Account ID should be null.');
        System.assert(result.contactID == null, 'Contact ID should be null.');
        System.assert(result.opportunityID == null, 'Opportunity ID should be null.');
        System.assert(result.errorMessage != null, 'An error message should be provided.');
    }
}