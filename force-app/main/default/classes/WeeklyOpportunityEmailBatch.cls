/*
*********************************************************
Apex Class Name    : WeeklyOpportunityEmailBatch
Created Date       : November 28, 2025
@description       : Sends weekly email report for New Logo / NLOB opportunities.
@author            : Kunal Poojari
Modification Log:
Ver   Date         Author                               Modification
1.0   28-11-2025   Kunal Poojari                        Initial Version
*********************************************************
*/
public class WeeklyOpportunityEmailBatch implements Database.Batchable<SObject>, Database.Stateful {

    // Recipient email updated
    public String recipientEmail = 'kunalp1@damcogroup.com';

    public Database.QueryLocator start(Database.BatchableContext bc) {

        String query = 
        'SELECT ' +
            'CS_Assignee__c,'+
            'IT_Assignee__c,'+
            'Owner.Name,'+
            'Deal_Type__c,'+
            'StageName,'+
            'Probability,'+
            'CloseDate,'+
            'Net_FTE_growth__c,'+
            'Opportunity_Net_IYR_Growth__c,'+
            'Opportunity_ARR__c,'+
            'Opportunity_Net_TCV_Growth__c,'+
            'Account.Name,'+
            'Account_Owner_Division__c,'+
            'Service_Lines__c,'+
            'Revenue_StartDate__c,'+
            'Description,'+
            'IT_Solution_Summary__c,'+
            'Recent_Summary_of_Activity__c,'+
            'NextStep,'+
            'Forecast_Status__c,'+
            'Is_this_an_RFP__c,'+
            'RFP_Due_Date__c '+
        'FROM Opportunity '+
        'WHERE Deal_Type__c IN (\'New Logo\', \'NLOB\') '+
        'AND StageName IN (\'Qualified\', \'Pricing\') '+
        'AND Opportunity_Net_TCV_Growth__c = 0 '+
        'ORDER BY CloseDate ASC';
        return Database.getQueryLocator(query);
    }

    String htmlBody = '';

    public void execute(Database.BatchableContext bc, List<Opportunity> oppList) {

        if (oppList.isEmpty()) return;

        for (Opportunity o : oppList) {
            htmlBody += 
            '<tr>' +
                '<td>' + safe(o.CS_Assignee__c) + '</td>' +
                '<td>' + safe(o.IT_Assignee__c) + '</td>' +
                '<td>' + safe(o.Owner.Name) + '</td>' +
                '<td>' + safe(o.Deal_Type__c) + '</td>' +
                '<td>' + safe(o.StageName) + '</td>' +
                '<td>' + safe(String.valueOf(o.Probability)) + '</td>' +
                '<td>' + safe(formatDate(o.CloseDate)) + '</td>' +
                '<td>' + safe(String.valueOf(o.Net_FTE_growth__c)) + '</td>' +
                '<td>' + safe(String.valueOf(o.Opportunity_Net_IYR_Growth__c)) + '</td>' +
                '<td>' + safe(String.valueOf(o.Opportunity_ARR__c)) + '</td>' +
                '<td>' + safe(String.valueOf(o.Opportunity_Net_TCV_Growth__c)) + '</td>' +
                '<td>' + safe(o.Account.Name) + '</td>' +
                '<td>' + safe(o.Account_Owner_Division__c) + '</td>' +
                '<td>' + safe(o.Service_Lines__c) + '</td>' +
                '<td>' + safe(formatDate(o.Revenue_StartDate__c)) + '</td>' +
                '<td>' + safe(o.Description) + '</td>' +
                '<td>' + safe(o.IT_Solution_Summary__c) + '</td>' +
                '<td>' + safe(o.Recent_Summary_of_Activity__c) + '</td>' +
                '<td>' + safe(o.NextStep) + '</td>' +
                '<td>' + safe(o.Forecast_Status__c) + '</td>' +
                '<td>' + safe(String.valueOf(o.Is_this_an_RFP__c)) + '</td>' +
                '<td>' + safe(formatDate(o.RFP_Due_Date__c)) + '</td>' +
            '</tr>';
        }
    }

    public void finish(Database.BatchableContext bc) {

        String finalHtml = 
        '<html><body>' +
        '<h2>Weekly Opportunity Report - New Logo / NLOB</h2>' +
        '<table border="1" cellpadding="5" cellspacing="0">' +
        '<tr style="background-color:#e6f2ff;">' +
            '<th>Opportunity Assignee</th>' +
            '<th>IT Assignee</th>' +
            '<th>Opportunity Owner</th>' +
            '<th>Deal Type</th>' +
            '<th>Stage</th>' +
            '<th>Probability</th>' +
            '<th>Close Date</th>' +
            '<th>Net FTE Growth</th>' +
            '<th>Net IYR Growth</th>' +
            '<th>Net ARR Growth</th>' +
            '<th>Net TCV Growth</th>' +
            '<th>Account</th>' +
            '<th>Alorica Vertical</th>' +
            '<th>Service Lines</th>' +
            '<th>Revenue Start</th>' +
            '<th>Description</th>' +
            '<th>IT Solution Summary</th>' +
            '<th>Recent Activity</th>' +
            '<th>Next Step</th>' +
            '<th>Forecast Status</th>' +
            '<th>Is this an RFP?</th>' +
            '<th>RFP Due Date</th>' +
        '</tr>' +
        htmlBody +
        '</table>' +
        '</body></html>';

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { recipientEmail });
        email.setSubject('Weekly Opportunity Report - New Logo / NLOB');
        email.setHtmlBody(finalHtml);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }

    public String safe(Object val) {
        return val == null ? '' : String.valueOf(val).escapeHtml4();
    }

    public String formatDate(Date d) {
        return d == null ? '' : d.format();
    }
}