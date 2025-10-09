trigger DefaultCSAssignee on Opportunity (before insert) {
	for(Opportunity opp : Trigger.NEW){
        system.debug(opp.OwnerId);
        opp.CS_Assignee__c = opp.OwnerId;
    }
}