@isTest
public class OpportunityServicesFormatterTest {

    @isTest
    static void testFormatServicesUsingDataFactory() {
        // Use DataFactory to generate sample data
        DataFactory df = new DataFactory();
        df.generateData();

        // Query an Opportunity created by DataFactory
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        // Build request
        OpportunityServicesFormatter.Request req = new OpportunityServicesFormatter.Request();
        req.opportunityId = opp.Id;

        Test.startTest();
        List<OpportunityServicesFormatter.Response> responses =
            OpportunityServicesFormatter.formatServices(new List<OpportunityServicesFormatter.Request>{ req });
        Test.stopTest();

        // Assertions
        System.assertEquals(1, responses.size(), 'One response expected');
        System.debug('Formatted Text: ' + responses[0].formattedText);
        System.assertNotEquals(null, responses[0].formattedText, 'Formatted text should not be null');
    }
}