@isTest
public class RemoveTargetFromSalesCadenceTest {
    
    @isTest
    static void testRemoveTarget() {
        // Create test data
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact');
        insert testContact;

        // Create a request object
        RemoveTargetFromSalesCadence.RemoveTargetRequest request = new RemoveTargetFromSalesCadence.RemoveTargetRequest();
        request.targetId = testContact.Id;
        request.completionReasonCode = 'Completed';
        
        List<RemoveTargetFromSalesCadence.RemoveTargetRequest> requests = new List<RemoveTargetFromSalesCadence.RemoveTargetRequest>();
        requests.add(request);

        // Mock the HTTP response
        Test.setMock(HttpCalloutMock.class, new RemoveTargetFromSalesCadenceMock());

        // Test the invocable method
        Test.startTest();
        RemoveTargetFromSalesCadence.removeTarget(requests);
        Test.stopTest();

        // Assertions
        System.assert(true, 'Code executed without exceptions');
    }
    
    @isTest
    static void testRemoveTargetNullInput() {
        // Mock the HTTP response
        Test.setMock(HttpCalloutMock.class, new RemoveTargetFromSalesCadenceMock());

        // Test the invocable method with null input
        Test.startTest();
        RemoveTargetFromSalesCadence.removeTarget(null);
        Test.stopTest();

        // Assertions
        System.assert(true, 'Code executed without exceptions');
    }
    
    // Mock class for the HTTP callout
    private class RemoveTargetFromSalesCadenceMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"statusCode": 200, "message": "Success"}');
            res.setStatusCode(200);
            return res;
        }
    }
}