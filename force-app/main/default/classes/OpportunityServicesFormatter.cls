public with sharing class OpportunityServicesFormatter {

    public class Request {
        @InvocableVariable(required=true)
        public Id opportunityId;
    }

    public class Response {
        @InvocableVariable
        public String formattedText;
    }

    @InvocableMethod(label='Format Opportunity Services' description='Returns formatted services & Opp values')
    public static List<Response> formatServices(List<Request> requests) {
        List<Response> responses = new List<Response>();

        for (Request req : requests) {
            // Query Opportunity with new fields
            Opportunity opp = [
                SELECT Id, 
                       Net_FTE_growth__c,
                       In_Year_Forecast_Revenue__c,
                       Annual_Recurring_Revenue__c,
                       Net_TCV_growth__c
                FROM Opportunity 
                WHERE Id = :req.opportunityId
                LIMIT 1
            ];

            // Query related services
            List<Service__c> services = [
                SELECT Id,
                       Service_Line__c,
                       FTE__c,
                       Alorica_Site__r.Name
                FROM Service__c
                WHERE Opportunity__c = :req.opportunityId
                AND Model_is_Primary__c = true
                ORDER BY CreatedDate ASC
            ];

            // Build output using String
            String output = 'Service/Site/FTE:\n';
            Integer counter = 1;

            for (Service__c s : services) {
                output += 'Service-'+counter + ')'
                       + s.Service_Line__c + '/'
                       + (s.Alorica_Site__r != null ? s.Alorica_Site__r.Name : 'N/A') + '/'
                       	+ (s.FTE__c != null ? String.valueOf(s.FTE__c) : '0')
                       + '\n';
                counter++;
            }

            // Add Opportunity summary values
            output += '\nOpportunity Net IYR: ' + opp.In_Year_Forecast_Revenue__c
                   + '\nOpportunity Net ARR: ' + opp.Annual_Recurring_Revenue__c
                   + '\nOpportunity Net TCV: ' + opp.Net_TCV_growth__c
                   + '\nOpportunity Net FTE: ' + opp.Net_FTE_growth__c;

            Response res = new Response();
            res.formattedText = output;
            responses.add(res);
        }
        return responses;
    }
}