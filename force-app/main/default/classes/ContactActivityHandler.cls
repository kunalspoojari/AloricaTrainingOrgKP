public class ContactActivityHandler {

    // Define the class to hold the input parameter for the flow
    public class Request {
        @InvocableVariable(label='Contact Id' required=true)
        public Id contactId;  // The Contact Id passed from Flow
    }

    // Define the class to hold the response to the flow
    public class Response {
        @InvocableVariable(label='Most Recent Activity Date')
        public DateTime mostRecentActivityDate;  // Date of the most recent activity
    }

    // The method to be called from the flow
    @InvocableMethod(label='Get Most Recent Activity Date' description='Get the most recent activity date for the given Contact ID')
    public static List<Response> getMostRecentActivityDate(List<Request> requests) {
        System.debug('Request:' + requests);

        // Create a list of Contact IDs from the requests
        Set<Id> contactIds = new Set<Id>();
        for (Request request : requests) {
            contactIds.add(request.contactId);
        }

        // Create a map to store the most recent activity date for each contact
        Map<Id, DateTime> contactToMostRecentActivityDate = new Map<Id, DateTime>();

        // Query Tasks and use AggregateResult to find the most recent Task date
        List<AggregateResult> taskResults = [SELECT WhoId, MAX(CreatedDate) mostRecentTaskDate 
                                             FROM Task 
                                             WHERE WhoId IN :contactIds 
                                             GROUP BY WhoId 
                                             ALL ROWS];

        // Query Events and use AggregateResult to find the most recent Event date
        List<AggregateResult> eventResults = [SELECT WhoId, MAX(CreatedDate) mostRecentEventDate 
                                              FROM Event 
                                              WHERE WhoId IN :contactIds 
                                              GROUP BY WhoId 
                                              ALL ROWS];

        // Process the most recent Task dates
        for (AggregateResult taskResult : taskResults) {
            Id contactId = (Id) taskResult.get('WhoId');
            DateTime mostRecentTaskDate = (DateTime) taskResult.get('mostRecentTaskDate');
            contactToMostRecentActivityDate.put(contactId, mostRecentTaskDate);
        }

        // Process the most recent Event dates
        for (AggregateResult eventResult : eventResults) {
            Id contactId = (Id) eventResult.get('WhoId');
            DateTime mostRecentEventDate = (DateTime) eventResult.get('mostRecentEventDate');
            DateTime existingDate = contactToMostRecentActivityDate.get(contactId);

            // Compare the event date with the existing task date to find the most recent
            if (existingDate != null) {
                contactToMostRecentActivityDate.put(contactId, (existingDate > mostRecentEventDate) ? existingDate : mostRecentEventDate);
            } else {
                contactToMostRecentActivityDate.put(contactId, mostRecentEventDate);
            }
        }

        // Prepare the responses to be returned
        List<Response> responses = new List<Response>();
        for (Request request : requests) {
            Response response = new Response();
            response.mostRecentActivityDate = contactToMostRecentActivityDate.get(request.contactId);
            responses.add(response);
        }

        System.debug('Return:' + responses);
        return responses;
    }
}