/*
*********************************************************
Apex Class Name    : OpportunityTriggerHandler
Created Date       : October 27, 2025
@description       : This is class is used as a Handelr class for Opportunity
@author            : Kunal Poojari
Modification Log:
Ver   Date         Author                               Modification
1.0   27-10-2025   Kunal Poojari                      Initial Version
*********************************************************
*/
public class OpportunityTriggerHandler {
    
    public static void handleBeforeInsert(List<Opportunity> newOpps) {
        OpportunityHelper helper = new OpportunityHelper();
        for (Opportunity opp : newOpps) {
            helper.initializeCounts(opp);
        }
    }
    
    public static void handleBeforeUpdate(List<Opportunity> newOpps, Map<Id, Opportunity> oldOpps) {
        OpportunityHelper helper = new OpportunityHelper();
        for (Opportunity newOpp : newOpps) {
            Opportunity oldOpp = oldOpps.get(newOpp.Id);
            if (newOpp.StageName != oldOpp.StageName) {
                helper.handleStageChange(newOpp, oldOpp.StageName);
            }
        }
    }
    public static void handleAfterUpdate(List<Opportunity> newOpps, Map<Id, Opportunity> oldOpps) {
        OpportunityHelper helper = new OpportunityHelper();
        for (Opportunity newOpp : newOpps) {
            Opportunity oldOpp = oldOpps.get(newOpp.Id);
            if (newOpp.OwnerId != oldOpp.OwnerId || newOpp.CS_Assignee__c != oldOpp.CS_Assignee__c) {
                helper.handleSharingRefresh(newOpp);
            }
        }
    }
}