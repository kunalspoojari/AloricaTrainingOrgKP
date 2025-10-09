@isTest
global class SFDC_DQM_Queue_HttpMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals(Label.Azure_Service_Bus_URI+'/messages', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"response":'+true+'}');
        res.setStatusCode(200);
        return res;
    }
}