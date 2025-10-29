trigger ClosedWonLostQuestionaireShareTrig on Closed_Won_Lost_Questionaire__c (after insert, after update) {
   //String triggerController = System.label.Closed_Won_Lost_Questionaire_Check;
   TriggerSwitch__c triggerCheck = TriggerSwitch__c.getInstance();
   if (Trigger.isAfter && triggerCheck.Seller_Survey_Check__c==true) {
        if (Trigger.isInsert) {
            ClosedWonLostQuestionnaireHandler.handleAfterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            ClosedWonLostQuestionnaireHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}