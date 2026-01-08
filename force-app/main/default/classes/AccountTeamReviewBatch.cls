global class AccountTeamReviewBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query all Customer Accounts with owner email and related user names for team members
       String query = 'SELECT Id, Name, OwnerId, Owner.Email, Owner.Name, ' +
               'Alorica_Vertical__c, ' +
               'Client_Account_Manager_1__r.Name, ' +
               'Client_Account_Manager_2__r.Name, ' +
               'Client_Account_Manager_3__r.Name, ' +
               'Client_Account_Manager_4__r.Name, ' +
               'Client_Account_Manager_5__r.Name, ' +
               'Client_Account_Manager_6__r.Name, ' +
               'Client_Account_Manager_7__r.Name ' +
               'FROM Account ' +
               'WHERE Account_Type__c = \'Customer\' ' +
               'AND Owner.Email != null ' +
               'AND Owner.Name != \'System Administrator\'';


        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for (Account acc : scope) {
            // Handle null values for fields
            String vertical = (acc.Alorica_Vertical__c != null) ? acc.Alorica_Vertical__c : '';
            String ownerName = (acc.Owner != null && acc.Owner.Name != null)? acc.Owner.Name: 'User';
            String clientPartner = (acc.Client_Account_Manager_1__r != null && acc.Client_Account_Manager_1__r.Name != null) ? acc.Client_Account_Manager_1__r.Name : '';
            String director1 = (acc.Client_Account_Manager_2__r != null && acc.Client_Account_Manager_2__r.Name != null) ? acc.Client_Account_Manager_2__r.Name : '';
            String director2 = (acc.Client_Account_Manager_3__r != null && acc.Client_Account_Manager_3__r.Name != null) ? acc.Client_Account_Manager_3__r.Name : '';
            String director3 = (acc.Client_Account_Manager_4__r != null && acc.Client_Account_Manager_4__r.Name != null) ? acc.Client_Account_Manager_4__r.Name : '';
            String director4 = (acc.Client_Account_Manager_5__r != null && acc.Client_Account_Manager_5__r.Name != null) ? acc.Client_Account_Manager_5__r.Name : '';
            //String director5 = (acc.Client_Account_Manager_5__r != null && acc.Client_Account_Manager_5__r.Name != null) ? acc.Client_Account_Manager_5__r.Name : '';
            String manager1 = (acc.Client_Account_Manager_6__r != null && acc.Client_Account_Manager_6__r.Name != null) ? acc.Client_Account_Manager_6__r.Name : '';
            String manager2 = (acc.Client_Account_Manager_7__r != null && acc.Client_Account_Manager_7__r.Name != null) ? acc.Client_Account_Manager_7__r.Name : '';
            String recordUrl = System.Url.getOrgDomainUrl().toExternalForm() + '/' + acc.Id;
            String encodedUrl = EncodingUtil.urlEncode(recordUrl, 'UTF-8');
            String htmlBody = ''
            + '<html><body style="font-family:Arial, sans-serif; font-size:14px; color:#222;">'
            + '<p>Dear ' + ownerName.escapeHtml4() + ',</p>'
            + '<p>Below are the details of your Account team tagged in Salesforce. Please look at these Account assignments and tagging and ensure the right team is tagged to your Account.</p>'
            + '<p>You have edit access to tag the right account team and it is essential you check this periodically whenever there is any change in Account Team. Please reach out to Sales Operations (Siva) for any questions/clarifications.</p>'
            // Account name as hyperlink (user requested) + styled Open Account anchor (as in your commented template)
            + '<p><strong>Account Name:</strong> <a href="' + recordUrl + '" target="_blank" style="color:#1a73e8; text-decoration:none;">' + acc.Name.escapeHtml4() + '</a></p>'
            + '<hr/>'
            + '<p><strong>Vertical:</strong> ' + vertical.escapeHtml4() + '<br/>'
            + '<strong>Client Partner:</strong> ' + clientPartner.escapeHtml4() + '<br/>'
            + '<strong>Client Account Director 1:</strong> ' + director1.escapeHtml4() + '<br/>'
            + '<strong>Client Account Director 2:</strong> ' + director2.escapeHtml4() + '<br/>'
            + '<strong>Client Account Director 3:</strong> ' + director3.escapeHtml4() + '<br/>'
            + '<strong>Client Account Director 4:</strong> ' + director4.escapeHtml4() + '<br/>'
            + '<strong>Client Account Manager 1:</strong> ' + manager1.escapeHtml4() + '<br/>'
            + '<strong>Client Account Manager 2:</strong> ' + manager2.escapeHtml4() + '</p>'
            + '<p>Thank You!!!<br/>'
            + '</body></html>';
            // Create email message
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[]{acc.Owner.Email});
            email.setCcAddresses(new String[] { 'vinay.j@alorica.com' });
            email.setSubject('Review Account Team Assignments in Salesforce');
            email.setHtmlBody(htmlBody);
            emails.add(email);
        }
        System.debug('line 56' + emails);
        
        // Send emails (note: in production, consider limits and bulkify if needed)
        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        // Optional: Add logging or post-processing here, e.g., send a summary email to admins
        System.debug('Account Team Review Batch completed.');
    }
      
}