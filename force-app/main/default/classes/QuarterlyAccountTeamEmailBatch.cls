global class QuarterlyAccountTeamEmailBatch implements Database.Batchable<SObject>, Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator([
            SELECT Id, OwnerId,Owner.Email
            FROM Account
            WHERE Id='001Ov00001AvwsEIAR'
        ]);
    }

    global void execute(Database.BatchableContext bc, List<Account> accList) {

        if (accList.isEmpty()) return;

        for (Account acc : accList) {

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            mail.setTemplateId(getTemplateId('Quarter_Wise_Email')); // <== YOUR TEMPLATE
             mail.setToAddresses(new String[] { acc.Owner.Email });
            mail.setTargetObjectId(acc.OwnerId);
            mail.setWhatId(acc.Id); // ensures merge fields resolve
            mail.setSaveAsActivity(false);

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    global void finish(Database.BatchableContext bc) {
        // Optional - summary email or log
    }

    // Helper to fetch template ID using DeveloperName
    private Id getTemplateId(String templateDeveloperName) {
        return [
            SELECT Id
            FROM EmailTemplate
            WHERE DeveloperName = :templateDeveloperName
            LIMIT 1
        ].Id;
    }
}