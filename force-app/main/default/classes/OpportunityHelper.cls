/*
*********************************************************
Apex Class Name    : OpportunityHelper
Created Date       : October 27, 2025
@description       : This is class is used as a helper class for Count of Opportunity Stage
@author            : Kunal Poojari
Modification Log:
Ver   Date         Author                               Modification
1.0   27-10-2025   Kunal Poojari                      Initial Version
*********************************************************
*/
public class OpportunityHelper {
    
    // Define stage order (1 = earliest, 4 = latest).
    private static final Map<String, Integer> STAGE_ORDER = new Map<String, Integer>{
        'Prospect'  => 1,
        'Qualified' => 2,
        'Pricing' => 3,
        'Verbal Win' => 4,
        'Contract Negotiation' => 5,
        'Closed Won' => 6,
        'Closed Lost' => 6  // Same level as Closed Won
    };
    
    // Map stage names to their count field API names.
    private static final Map<String, String> STAGE_TO_COUNT_FIELD = new Map<String, String>{
        'Prospect'  => 'ac_Prospect_Count__c',
        'Qualified' => 'ac_Qualified_Count__c',
        'Pricing'   => 'ac_Pricing_Count__c',
        'Verbal Win' => 'ac_Verbal_Win_Count__c',
        'Contract Negotiation' => 'ac_Contract_Negotiation_Count__c',
        'Closed Won' => 'ac_Closed_Won_Count__c',
        'Closed Lost' => 'ac_Closed_Lost__c'
    };
    
    // List of all tracked stages for iteration.
    private static final List<String> TRACKED_STAGES = new List<String>{
        'Prospect','Qualified', 'Pricing', 'Verbal Win', 'Contract Negotiation', 'Closed Won', 'Closed Lost'
    };
    
    public void initializeCounts(Opportunity opp) {
        String stage = opp.StageName;
        if (!STAGE_ORDER.containsKey(stage)) {
            return;  // Ignore non-tracked stages
        }
        
        // Set current to 1, all others to 0 (fresh cycle).
        for (String trackedStage : TRACKED_STAGES) {
            String fieldName = STAGE_TO_COUNT_FIELD.get(trackedStage);
            if (trackedStage == stage) {
                opp.put(fieldName, 1);
            } else {
                opp.put(fieldName, 0);
            }
        }
        System.debug('Initialized counts for stage: ' + stage);
    }
    
    public void handleStageChange(Opportunity newOpp, String oldStage) {
        String newStage = newOpp.StageName;
        System.debug('Stage change: ' + oldStage + ' → ' + newStage);
        
        if (!STAGE_ORDER.containsKey(newStage)) {
            System.debug('New stage not tracked; no changes.');
            return;  // Ignore if new stage not tracked
        }
        
        if (!STAGE_ORDER.containsKey(oldStage)) {
            System.debug('Old stage not tracked; initializing for new stage.');
            initializeCounts(newOpp);
            return;
        }
        
        // Both tracked; apply logic
        Integer newOrder = STAGE_ORDER.get(newStage);
        Integer oldOrder = STAGE_ORDER.get(oldStage);
        System.debug('Orders: old=' + oldOrder + ', new=' + newOrder);
        
        if (newOrder < oldOrder) {
            // Backward: Reset backed-over stages (newOrder < stageOrder <= oldOrder)
            System.debug('Backward move; resetting backed-over stages.');
            for (String stage : TRACKED_STAGES) {
                Integer stageOrder = STAGE_ORDER.get(stage);
                if (stageOrder > newOrder && stageOrder <= oldOrder) {
                    String fieldName = STAGE_TO_COUNT_FIELD.get(stage);
                    newOpp.put(fieldName, 0);
                    System.debug('Reset ' + stage + ' to 0');
                }
            }
        } else {
            // Forward/skip/same level: Reset skipped (oldOrder < stageOrder < newOrder), set new=1, reset future (> newOrder)
            System.debug('Forward/same-level move; handling skips and future.');
            
            // Reset skipped stages
            for (String stage : TRACKED_STAGES) {
                Integer stageOrder = STAGE_ORDER.get(stage);
                if (oldOrder < stageOrder && stageOrder < newOrder) {
                    String fieldName = STAGE_TO_COUNT_FIELD.get(stage);
                    newOpp.put(fieldName, 0);
                    System.debug('Reset skipped ' + stage + ' to 0');
                }
            }
            
            // Set new stage to 1
            String newField = STAGE_TO_COUNT_FIELD.get(newStage);
            newOpp.put(newField, 1);
            System.debug('Set ' + newStage + ' to 1');
            
            // Reset future stages
            for (String stage : TRACKED_STAGES) {
                Integer stageOrder = STAGE_ORDER.get(stage);
                if (stageOrder > newOrder) {
                    String fieldName = STAGE_TO_COUNT_FIELD.get(stage);
                    newOpp.put(fieldName, 0);
                    System.debug('Reset future ' + stage + ' to 0');
                }
            }
        }
    }
    public void handleSharingRefresh(Opportunity opp) {
        // Query related questionnaires for this Opportunity (include OwnerId for sharing logic)
        List<Closed_Won_Lost_Questionaire__c> relatedQuestionnaires = [
            SELECT Id, OwnerId, Opportunity__c
            FROM Closed_Won_Lost_Questionaire__c
            WHERE Opportunity__c = :opp.Id
        ];
        
        if (relatedQuestionnaires.isEmpty()) return;
        
        // Delegate to Questionnaire helper: Use non-null empty oldMap to force delete + reinsert
        Map<Id, Closed_Won_Lost_Questionaire__c> dummyOldMap = new Map<Id, Closed_Won_Lost_Questionaire__c>();
        ClosedWonLostQuestionnaireHandler.handleAfterUpdate(relatedQuestionnaires, dummyOldMap);
    }
}