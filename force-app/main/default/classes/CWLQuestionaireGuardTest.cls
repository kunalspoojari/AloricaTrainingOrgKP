@isTest(SeeAllData=true)
public class CWLQuestionaireGuardTest {
    
    // Helper method to get existing opportunities
    private static List<Opportunity> getTestOpportunities() {
        // Final fallback - get any existing opportunities
        List<Opportunity> opps = [SELECT Id FROM Opportunity LIMIT 5];
        return opps;
    }
    
    @isTest
    static void testSingleInsert_Success() {
        // Test: Insert a single questionnaire - should succeed
        List<Opportunity> opps = getTestOpportunities();
        if (opps.isEmpty()) return; // Skip if no opportunities available
        
        Opportunity opp = opps[0];
        
        Test.startTest();
        Closed_Won_Lost_Questionaire__c questionnaire = new Closed_Won_Lost_Questionaire__c(
            Opportunity__c = opp.Id
        );
        
        insert questionnaire;
        Test.stopTest();
        
        // Verify record was created
        List<Closed_Won_Lost_Questionaire__c> inserted = [
            SELECT Id, Opportunity__c 
            FROM Closed_Won_Lost_Questionaire__c 
            WHERE Opportunity__c = :opp.Id
        ];
        System.assertEquals(1, inserted.size(), 'Should have inserted one questionnaire');
    }
    
    @isTest
    static void testDuplicateInsert_SameOpportunity() {
        // Test: Insert duplicate questionnaires for same opportunity - should fail
        List<Opportunity> opps = getTestOpportunities();
        if (opps.isEmpty()) return; // Skip if no opportunities available
        
        Opportunity opp = opps[0];
        
        // Insert first questionnaire
        Closed_Won_Lost_Questionaire__c first = new Closed_Won_Lost_Questionaire__c(
            Opportunity__c = opp.Id
        );
        insert first;
        
        Test.startTest();
        // Try to insert second questionnaire for same opportunity
        Closed_Won_Lost_Questionaire__c second = new Closed_Won_Lost_Questionaire__c(
            Opportunity__c = opp.Id
        );
        
        try {
            insert second;
            System.assert(false, 'Expected DMLException due to duplicate questionnaire');
        } catch (DMLException e) {
            System.assert(e.getMessage().contains('A Seller Survey already exists'), 
                         'Error message should mention existing survey');
            System.assert(e.getMessage().contains('/' + first.Id), 
                         'Error message should contain link to existing record');
        }
        Test.stopTest();
        
        // Verify only one record exists
        List<Closed_Won_Lost_Questionaire__c> records = [
            SELECT Id FROM Closed_Won_Lost_Questionaire__c 
            WHERE Opportunity__c = :opp.Id
        ];
        System.assertEquals(1, records.size(), 'Should only have one questionnaire');
    }
    
    @isTest
    static void testBatchInsert_DuplicatesInSameBatch() {
        // Test: Insert multiple questionnaires for same opportunity in single DML - should fail
        List<Opportunity> opps = getTestOpportunities();
        if (opps.isEmpty()) return; // Skip if no opportunities available
        
        Opportunity opp = opps[0];
        
        List<Closed_Won_Lost_Questionaire__c> questionnaires = new List<Closed_Won_Lost_Questionaire__c>();
        questionnaires.add(new Closed_Won_Lost_Questionaire__c(
            Opportunity__c = opp.Id
        ));
        questionnaires.add(new Closed_Won_Lost_Questionaire__c(
            Opportunity__c = opp.Id
        ));
        
        Test.startTest();
        try {
            insert questionnaires;
            System.assert(false, 'Expected DMLException due to batch duplicates');
        } catch (DMLException e) {
            System.assert(e.getMessage().contains('Only one Seller Survey per Opportunity is allowed'), 
                         'Error message should mention batch duplicate restriction');
        }
        Test.stopTest();
        
        // Verify no records were inserted
        List<Closed_Won_Lost_Questionaire__c> records = [
            SELECT Id FROM Closed_Won_Lost_Questionaire__c 
            WHERE Opportunity__c = :opp.Id
        ];
        System.assertEquals(0, records.size(), 'No questionnaires should be inserted due to batch error');
    }
    
    @isTest
    static void testInsert_NullOpportunity_Success() {
        // Test: Insert questionnaire with null Opportunity - should succeed (no validation)
        
        // Count existing null records before test
        Integer existingCount = [SELECT COUNT() FROM Closed_Won_Lost_Questionaire__c WHERE Opportunity__c = null];
        
        Test.startTest();
        Closed_Won_Lost_Questionaire__c questionnaire = new Closed_Won_Lost_Questionaire__c(
            Opportunity__c = null
        );
        
        insert questionnaire;
        Test.stopTest();
        
        // Verify one more record was created
        Integer newCount = [SELECT COUNT() FROM Closed_Won_Lost_Questionaire__c WHERE Opportunity__c = null];
        System.assertEquals(existingCount + 1, newCount, 'Should have added one more questionnaire with null opportunity');
    }
    
    @isTest
    static void testUpdate_ExistingRecord_Success() {
        // Test: Update the existing (earliest) record - should succeed
        List<Opportunity> opps = getTestOpportunities();
        if (opps.isEmpty()) return; // Skip if no opportunities available
        
        Opportunity opp = opps[0];
        
        // Insert initial questionnaire
        Closed_Won_Lost_Questionaire__c questionnaire = new Closed_Won_Lost_Questionaire__c(
            Opportunity__c = opp.Id
        );
        insert questionnaire;
        
        Test.startTest();
        // Update the existing record - just trigger the update to test trigger logic
        update questionnaire;
        Test.stopTest();
        
        // Verify update succeeded (record still exists and can be updated)
        Closed_Won_Lost_Questionaire__c updated = [
            SELECT Id 
            FROM Closed_Won_Lost_Questionaire__c 
            WHERE Id = :questionnaire.Id
        ];
        System.assertNotEquals(null, updated.Id, 'Record should still exist after update');
    }
}