trigger ClosedWonLostQuestionaireShareTrig on Closed_Won_Lost_Questionaire__c (after insert, after update) {
   String triggerController = System.label.Closed_Won_Lost_Questionaire_Check;
   if (Trigger.isAfter && triggerController=='True') {
        if (Trigger.isInsert) {
            ClosedWonLostQuestionnaireHandler.handleAfterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            ClosedWonLostQuestionnaireHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}