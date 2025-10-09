global class AccountMonthlySchedule implements Schedulable {

    global void execute(SchedulableContext sc) {
        // Run only if today is 1st of the month
        if (!Test.isRunningTest() && Date.today().day() != 1) {
            return;
        }

        List<Account> accList = [
            SELECT Id, Name 
            FROM Account 
            WHERE Account_Name_Finance__c = NULL
        ];

        if (accList.isEmpty()) {
            return; // Nothing to send
        }

        String tableHtml = '<p>Hi Sivakumar,</p>';
        tableHtml += '<p>Please find below Account names whose "Account Name Finance" field is blank:</p>';
        tableHtml += '<table border="1" cellpadding="5" cellspacing="0" style="border-collapse: collapse;">';
        tableHtml += '<tr><th>Sr. No.</th><th>Account Name</th></tr>';

        Integer counter = 1;
        String baseUrl = System.Url.getOrgDomainUrl().toExternalForm();

        for (Account acc : accList) {
            String recordLink = baseUrl + '/' + acc.Id;
            tableHtml += '<tr>';
            tableHtml += '<td>' + counter + '</td>';
            tableHtml += '<td><a href="' + recordLink + '">' + acc.Name + '</a></td>';
            tableHtml += '</tr>';
            counter++;
        }
        tableHtml += '</table>';
        tableHtml += '<p>Please update the Account Name Finance Field.</p><p>Thanks & Regards</p>';

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] {'Sivakumar.Muthuramalingam@alorica.com'}); // Change recipient
        email.setSubject('Accounts Missing Account Name (Finance) - Monthly Report');
        email.setOrgWideEmailAddressId([SELECT Id FROM OrgWideEmailAddress WHERE Address = 'aloricainternalsalesforcerequests@alorica.com' LIMIT 1].Id);
        email.setHtmlBody(tableHtml);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
}