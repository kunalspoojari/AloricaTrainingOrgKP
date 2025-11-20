trigger CampaignMemberTrigger on CampaignMember (after insert, after update) {
     if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        CampaignMemberHandler.updateContactStatusWhenContactSelected(Trigger.new, Trigger.oldMap);
    }
  
}