/*
*   @Author: Ariel Tribunal
*   @Date: 9/30/2019
*   @Apex Name: ServiceNowPdfEmailer
*   @Description: Class use to create an email with attached pdf converted from visualforce page.
*
*/
public class ServiceNowPdfEmailer {

    @InvocableMethod(label='sendEmailOppPdf' description='Opportunity ids, send email with the Opportunity detail.')
    public static void sendEmail(list<Id> OppId) {

        // Get account name for email message strings
        Opportunity opp = [SELECT Id,Name, ServiceNow_Project_ID__c, StageName
                           FROM Opportunity 
                           WHERE Id = :OppId 
                           LIMIT 1];
        if(null == opp) {
            return; // No Opportunity to process
        }
        
        // Create email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        String toAddress = Label.SN_Recipient_Email;
        String bccAddress = Label.SN_Bcc_Email;
        
        //message.setToAddresses(new String[]{ toAddress });
        message.setToAddresses(toAddress.split(';'));
        //message.setBccAddresses(new String[]{'ariel.tribunal@alorica.com','Anne.Naef@alorica.com'});
        message.setBccAddresses(bccAddress.split(';'));
        //message.setInReplyTo('Salesforce@alorica.com');
        message.setReplyTo('salesforcedevelopmentteam@alorica.com');
        //message.setSenderDisplayName('Salesforce Alorica');
        list<OrgWideEmailAddress> SvnOrgWideEmailAddress = new list<OrgWideEmailAddress>(
            [SELECT Address,DisplayName,Id FROM OrgWideEmailAddress where DisplayName = 'Salesforce Alorica' Limit 1]);
        if(SvnOrgWideEmailAddress.isEmpty()){
            message.setSenderDisplayName('Salesforce Alorica');
        }
        else{
            message.setOrgWideEmailAddressId(SvnOrgWideEmailAddress[0].Id);
        }
        
        message.setSubject('RE: ' + opp.ServiceNow_Project_ID__c);
        message.setHtmlBody('');
        
        // Create PDF
        PageReference reportPage = new PageReference('/apex/OpportunityPdfEmail?id=' + opp.Id +'&snprojid='+ opp.ServiceNow_Project_ID__c
                                                    + '&stage=' + opp.StageName);
        //system.debug('reportPage='+ reportPage);
        Blob reportPdf;
        try {
            reportPdf = reportPage.getContentAsPDF();
        }
        catch (Exception e) {
            reportPdf = Blob.valueOf(e.getMessage());
        }
        
        // Attach PDF to email and send
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setContentType('application/pdf');
        attachment.setFileName(opp.Name + '.pdf');
        attachment.setInline(false);
        attachment.setBody(reportPdf);
        message.setFileAttachments(new Messaging.EmailFileAttachment[]{ attachment });
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ message });
        
        return;
    }
}