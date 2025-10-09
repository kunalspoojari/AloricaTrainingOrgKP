public with sharing class ClosedWonLostQuestionnaireHandler {
    private static final String ALL_INTERNAL_USERS_GROUP = 'Internal_Read_Surveys';
    private static final String SHARE_ROW_CAUSE = 'Manual';

    public static void handleAfterInsert(List<Closed_Won_Lost_Questionaire__c> newQuestionnaires) {
        createSharingRecords(newQuestionnaires, null);
    }

    public static void handleAfterUpdate(List<Closed_Won_Lost_Questionaire__c> newQuestionnaires, Map<Id, Closed_Won_Lost_Questionaire__c> oldMap) {
        // Identify records where Opportunity__c has changed
        List<Closed_Won_Lost_Questionaire__c> questionnairesToProcess = new List<Closed_Won_Lost_Questionaire__c>();
        for (Closed_Won_Lost_Questionaire__c questionnaire : newQuestionnaires) {
            Closed_Won_Lost_Questionaire__c oldQuestionnaire = oldMap.get(questionnaire.Id);
            if (questionnaire.Opportunity__c != oldQuestionnaire.Opportunity__c) {
                questionnairesToProcess.add(questionnaire);
            }
        }
        if (!questionnairesToProcess.isEmpty()) {
            createSharingRecords(questionnairesToProcess, oldMap);
        }
    }

    private static void createSharingRecords(List<Closed_Won_Lost_Questionaire__c> questionnaires, Map<Id, Closed_Won_Lost_Questionaire__c> oldMap) {
        List<Closed_Won_Lost_Questionaire__Share> sharesToInsert = new List<Closed_Won_Lost_Questionaire__Share>();
        List<Closed_Won_Lost_Questionaire__Share> sharesToDelete = new List<Closed_Won_Lost_Questionaire__Share>();
        
        // Get the ID of the 'All Internal Users' public group
        Id allInternalUsersGroupId = [SELECT Id FROM Group WHERE Name = :ALL_INTERNAL_USERS_GROUP AND Type = 'Regular' LIMIT 1].Id;
        
        // Collect Opportunity IDs
        Set<Id> opportunityIds = new Set<Id>();
        Set<Id> questionnaireIds = new Set<Id>();
        for (Closed_Won_Lost_Questionaire__c questionnaire : questionnaires) {
            if (questionnaire.Opportunity__c != null) {
                opportunityIds.add(questionnaire.Opportunity__c);
            }
            questionnaireIds.add(questionnaire.Id);
        }
        
        // Query Opportunities for OwnerId and CS_Assignee__c
        Map<Id, Opportunity> opportunitiesMap = new Map<Id, Opportunity>([
            SELECT Id, OwnerId, CS_Assignee__c 
            FROM Opportunity 
            WHERE Id IN :opportunityIds
        ]);
        
        // For updates, collect existing manual shares to delete
        if (oldMap != null) {
            sharesToDelete = [
                SELECT Id 
                FROM Closed_Won_Lost_Questionaire__Share 
                WHERE ParentId IN :questionnaireIds 
                AND RowCause = :SHARE_ROW_CAUSE
            ];
        }
        
        for (Closed_Won_Lost_Questionaire__c questionnaire : questionnaires) {
            // Share with 'All Internal Users' for Read access
            Closed_Won_Lost_Questionaire__Share groupShare = new Closed_Won_Lost_Questionaire__Share();
            groupShare.ParentId = questionnaire.Id;
            groupShare.UserOrGroupId = allInternalUsersGroupId;
            groupShare.AccessLevel = 'Read';
            groupShare.RowCause = SHARE_ROW_CAUSE;
            sharesToInsert.add(groupShare);
            
            if (questionnaire.Opportunity__c == null) {
                continue;
            }
            
            Opportunity opp = opportunitiesMap.get(questionnaire.Opportunity__c);
            if (opp == null) {
                continue;
            }
            
            // Collect unique user IDs for Edit access
            Set<Id> usersForEdit = new Set<Id>();
            if (opp.OwnerId != null) {
                usersForEdit.add(opp.OwnerId);
            }
            if (opp.CS_Assignee__c != null) {
                usersForEdit.add(opp.CS_Assignee__c);
            }
            
            for (Id userId : usersForEdit) {
                if (userId != questionnaire.OwnerId) { // Avoid sharing with the record owner
                    Closed_Won_Lost_Questionaire__Share userShare = new Closed_Won_Lost_Questionaire__Share();
                    userShare.ParentId = questionnaire.Id;
                    userShare.UserOrGroupId = userId;
                    userShare.AccessLevel = 'Edit';
                    userShare.RowCause = SHARE_ROW_CAUSE;
                    sharesToInsert.add(userShare);
                }
            }
        }
        
        // Execute DML operations
        if (!sharesToDelete.isEmpty()) {
            delete sharesToDelete;
        }
        if (!sharesToInsert.isEmpty()) {
            insert sharesToInsert;
        }
    }
}