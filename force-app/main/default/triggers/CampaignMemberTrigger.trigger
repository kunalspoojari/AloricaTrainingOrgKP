/*
*********************************************************
Apex Class Name    : CampaignMemberTrigger
Created Date       : November 20, 2025
@description       : This is Trigger for Campaign Member
@author            : Kunal Poojari
Modification Log:
Ver   Date         Author                               Modification
1.0   20-11-2025   Kunal Poojari                      Initial Version1
*********************************************************
*/
trigger CampaignMemberTrigger on CampaignMember (after insert, after update, after delete,after undelete) {
    TriggerSwitch__c triggerCheck = TriggerSwitch__c.getInstance();
    
    if(triggerCheck!=null && triggerCheck.Campaign_Member_Trigger_Swtiech__c==true){
         if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        CampaignMemberHandler.updateContactStatusWhenContactSelected(Trigger.new, Trigger.oldMap);
         }
        // DELETE
         system.debug('line 19-->');
        if (Trigger.isAfter && Trigger.isDelete) {
            CampaignMemberHandler.handleDelete(Trigger.old);
        }
       
       
    }
}