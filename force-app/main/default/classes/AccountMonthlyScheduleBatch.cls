global class AccountMonthlyScheduleBatch implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {

        

        return Database.getQueryLocator(
            'SELECT Id, Name FROM Account WHERE Account_Name_Finance__c = NULL LIMIT 10'
        );
    }

    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        system.debug('line 21');
        if (scope.isEmpty()) return;
        system.debug('line 22');
        List<Account> accList = (List<Account>) scope;
        system.debug('line 20' + accList);
        String tableHtml = '<p>Hi Sivakumar,</p>';
        tableHtml += '<p>Please find below Account names whose "Account Name Finance" field is blank:</p>';
        tableHtml += '<table border="1" cellpadding="5" cellspacing="0" style="border-collapse: collapse;">';
        tableHtml += '<tr><th>Sr. No.</th><th>Account Name</th></tr>';

        Integer counter = 1;
        String baseUrl = System.Url.getOrgDomainUrl().toExternalForm();

        for (Account acc : accList) {
            tableHtml += '<tr>';
            tableHtml += '<td>' + counter + '</td>';
            tableHtml += '<td><a href="' + baseUrl + '/' + acc.Id + '">' + acc.Name + '</a></td>';
            tableHtml += '</tr>';
            counter++;
        }

        tableHtml += '</table>';
        tableHtml += '<p>Please update the Account Name Finance Field.</p><p>Thanks & Regards</p>';

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] {'kunalp1@damcogroup.com'});
        email.setSubject('Accounts Missing Account Name (Finance) - Monthly Report');

        email.setOrgWideEmailAddressId([
            SELECT Id FROM OrgWideEmailAddress
            WHERE Address = 'aloricainternalsalesforcerequests@alorica.com'
            LIMIT 1
        ].Id);

        email.setHtmlBody(tableHtml);
        system.debug('line 48-->'+tableHtml);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });

        System.debug('Email sent for batch: ' + accList.size() + ' accounts');
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('Batch execution completed.');
    }
}