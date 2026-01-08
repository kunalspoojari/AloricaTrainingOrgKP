global class SendZeroTCVReminder implements Schedulable {

    global void execute(SchedulableContext sc) {
        // Fetch opportunities where Net TCV is zero and stage is Qualified/Pricing
        List<Opportunity> oppList = [
            SELECT Id, Name, Owner.Email, Owner.Name, Deal_Type_Category__c, Account_Owner_Division__c, StageName, Forecast_Status__c,
            CloseDate, Opportunity_IYR__c, Opportunity_ARR__c, Net_TCV_growth__c, Net_FTE_growth__c
            FROM Opportunity
            WHERE (StageName = 'Qualified' OR StageName = 'Pricing')
              AND Net_TCV_growth__c = 0
              AND IsClosed = FALSE
        ];

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Opportunity opp : oppList) {
            if (opp.Owner.Email != null) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { opp.Owner.Email });
                email.setCcAddresses(new String[] {'Vinay.J@alorica.com'});
                email.setSubject(opp.Name + '\'s Net TCV is $0');
                email.setHtmlBody('Dear ' + opp.Owner.Name + ',<br/><br/>' +
    'This deal owned by you is in Qualified+ stage. It is mandatory to enter the Revenue Model and Services at this stage. ' +
    'Please review and enter the Revenue Model & other necessary details for this deal.<br/><br/>' +

    '<b>Opportunity Name:</b> <a href="'+ URL.getOrgDomainUrl().toExternalForm() + '/' + opp.Id + '">' + opp.Name + '</a><br/>'+
    '<b>Deal Type Category:</b> ' + opp.Deal_Type_Category__c + '<br/>' +
    '<b>Alorica Vertical:</b> ' + opp.Account_Owner_Division__c + '<br/>' +
    '<b>Stage:</b> ' + opp.StageName + '<br/>' +
    '<b>Forecast Status:</b> ' + opp.Forecast_Status__c + '<br/>' +
    '<b>Close Date:</b> ' + opp.CloseDate + '<br/>' +
    '<b>Opportunity Net IYR:</b> ' + opp.Opportunity_IYR__c + '<br/>' +
    '<b>Opportunity Net ARR:</b> ' + opp.Opportunity_ARR__c + '<br/>' +
    '<b>Opportunity Net TCV:</b> ' + opp.Net_TCV_growth__c + '<br/>' +
    '<b>Opportunity Net FTE:</b> ' + opp.Net_FTE_growth__c + '<br/><br/>' +

    'Please reach out to Sales Operations if you have any questions/clarifications.');
                emails.add(email);
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}