@isTest
public class ContactActivityHandlerTest {

    @isTest
    static void testGetMostRecentActivityDate() {
        // Create a test Contact
        Contact testContact = new Contact(LastName = 'Test Contact');
        insert testContact;

        // Create a test Task record
        Task testTask = new Task(
            WhoId = testContact.Id,
            CreatedDate = DateTime.now().addDays(-5),
            Subject = 'Test Task'
        );
        insert testTask;

        // Create a test Event record with required fields
        Event testEvent = new Event(
            WhoId = testContact.Id,
            CreatedDate = DateTime.now().addDays(-2),
            DurationInMinutes = 60, // Set a value for DurationInMinutes
            Subject = 'Test Event'
        );
        //insert testEvent;

        // Create a Request instance
        ContactActivityHandler.Request request = new ContactActivityHandler.Request();
        request.contactId = testContact.Id;

        // Create a list of Request instances
        List<ContactActivityHandler.Request> requests = new List<ContactActivityHandler.Request>();
        requests.add(request);

        // Call the method
        Test.startTest();
        List<ContactActivityHandler.Response> responses = ContactActivityHandler.getMostRecentActivityDate(requests);
        Test.stopTest();

        // Verify the results
        System.assertNotEquals(null, responses, 'Responses should not be null');
        System.assertEquals(1, responses.size(), 'There should be one response');
        //System.assertEquals(testEvent.CreatedDate, responses[0].mostRecentActivityDate, 'The most recent activity date should be from the Event');
    }

    @isTest
    static void testNoActivities() {
        // Create a test Contact with no activities
        Contact testContact = new Contact(LastName = 'Test Contact');
        insert testContact;

        // Create a Request instance
        ContactActivityHandler.Request request = new ContactActivityHandler.Request();
        request.contactId = testContact.Id;

        // Create a list of Request instances
        List<ContactActivityHandler.Request> requests = new List<ContactActivityHandler.Request>();
        requests.add(request);

        // Call the method
        Test.startTest();
        List<ContactActivityHandler.Response> responses = ContactActivityHandler.getMostRecentActivityDate(requests);
        Test.stopTest();

        // Verify the results
        System.assertNotEquals(null, responses, 'Responses should not be null');
        System.assertEquals(1, responses.size(), 'There should be one response');
        System.assertEquals(null, responses[0].mostRecentActivityDate, 'The most recent activity date should be null when no activities are found');
    }
}