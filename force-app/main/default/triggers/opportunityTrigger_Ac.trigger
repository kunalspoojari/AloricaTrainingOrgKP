/*
*********************************************************
Apex Class Name    : opportunityTrigger_Ac
Created Date       : October 27, 2025
@description       : This is Trigger for Opportunity
@author            : Kunal Poojari
Modification Log:
Ver   Date         Author                               Modification
1.0   27-10-2025   Kunal Poojari                      Initial Version
*********************************************************
*/
trigger opportunityTrigger_Ac on Opportunity (before insert, before update,after update) {
    TriggerSwitch__c triggerCheck = TriggerSwitch__c.getInstance();
    String triggerController = System.label.Opportunity_Count_Check;
    if(triggerCheck!=null && triggerCheck.Opportunity_Trigger_Check__c==true){
        if (Trigger.isBefore && triggerController=='True') {
            if (Trigger.isInsert) {
                OpportunityTriggerHandler.handleBeforeInsert(Trigger.new);
            } 
            else if (Trigger.isUpdate) {
                OpportunityTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
            }
        }
        if(Trigger.isAfter){
            if(Trigger.isUpdate){
                OpportunityTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
            }
        }
    }
}