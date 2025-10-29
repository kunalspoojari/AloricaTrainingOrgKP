public without sharing class ClosedWonLostQuestionnaireHandler {

    private static final String SHARE_ROW_CAUSE = 'Manual';

    public static void handleAfterInsert(List<Closed_Won_Lost_Questionaire__c> newQuestionnaires) {
        createSharingRecords(newQuestionnaires, null);
    }

    public static void handleAfterUpdate(List<Closed_Won_Lost_Questionaire__c> newQuestionnaires, Map<Id, Closed_Won_Lost_Questionaire__c> oldMap) {
        createSharingRecords(newQuestionnaires, oldMap);
    }

    private static void createSharingRecords(List<Closed_Won_Lost_Questionaire__c> questionnaires, Map<Id, Closed_Won_Lost_Questionaire__c> oldMap) {
        
        List<Closed_Won_Lost_Questionaire__Share> sharesToInsert = new List<Closed_Won_Lost_Questionaire__Share>();
        List<Closed_Won_Lost_Questionaire__Share> sharesToDelete = new List<Closed_Won_Lost_Questionaire__Share>();

        // Collect Opportunity and Questionnaire IDs
        Set<Id> oppIds = new Set<Id>();
        Set<Id> qIds = new Set<Id>();

        for (Closed_Won_Lost_Questionaire__c q : questionnaires) {
            if (q.Opportunity__c != null)
                oppIds.add(q.Opportunity__c);

            qIds.add(q.Id);
        }

        // Delete existing shares only on update
        if (oldMap != null) {
            sharesToDelete = [
                SELECT Id FROM Closed_Won_Lost_Questionaire__Share
                WHERE ParentId IN :qIds AND RowCause = :SHARE_ROW_CAUSE
            ];
        }

        // Get Opportunity Owner + CS Assignee
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([
            SELECT Id, OwnerId, CS_Assignee__c 
            FROM Opportunity WHERE Id IN :oppIds
        ]);

        for (Closed_Won_Lost_Questionaire__c q : questionnaires) {
            
            if (q.Opportunity__c == null) continue;

            Opportunity opp = oppMap.get(q.Opportunity__c);
            if (opp == null) continue;

            // Add users for edit access
            Set<Id> usersForEdit = new Set<Id>();

            if (opp.OwnerId != null) usersForEdit.add(opp.OwnerId);
            if (opp.CS_Assignee__c != null) usersForEdit.add(opp.CS_Assignee__c);

            for (Id userId : usersForEdit) {
                if (userId == q.OwnerId) continue; // Already has edit access

                Closed_Won_Lost_Questionaire__Share s = new Closed_Won_Lost_Questionaire__Share();
                s.ParentId = q.Id;
                s.UserOrGroupId = userId;
                s.AccessLevel = 'Edit';
                s.RowCause = SHARE_ROW_CAUSE;
                sharesToInsert.add(s);
            }
        }

        if (!sharesToDelete.isEmpty())
            delete sharesToDelete;

        if (!sharesToInsert.isEmpty())
            insert sharesToInsert;
    }
}