@IsTest
private class CWLQuestionaireGuard_T {

    private static Opportunity makeOpp(String name) {
        Opportunity o = new Opportunity(
            Name = name,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30)
        );
        insert o;
        return o;
    }

    @IsTest
    static void insert_one_then_block_second() {
        Opportunity o = makeOpp('O1');

        Closed_Won_Lost_Questionaire__c a = new Closed_Won_Lost_Questionaire__c(Opportunity__c = o.Id);
        insert a;
        System.assertNotEquals(null, a.Id);

        Closed_Won_Lost_Questionaire__c b = new Closed_Won_Lost_Questionaire__c(Opportunity__c = o.Id);
        try {
            insert b;
            System.assert(false, 'Second should be blocked');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('already exists'));
        }
    }

    @IsTest
    static void update_allowed_on_existing() {
        Opportunity o = makeOpp('O2');
        Closed_Won_Lost_Questionaire__c s = new Closed_Won_Lost_Questionaire__c(Opportunity__c = o.Id);
        insert s;

        s.put('Name', 'Edited'); // replace with any editable field that exists
        update s; // should succeed
    }

    @IsTest
    static void prevent_move_to_occupied_opportunity() {
        Opportunity o1 = makeOpp('A');
        Opportunity o2 = makeOpp('B');

        Closed_Won_Lost_Questionaire__c sA = new Closed_Won_Lost_Questionaire__c(Opportunity__c = o1.Id);
        insert sA;

        Closed_Won_Lost_Questionaire__c sB = new Closed_Won_Lost_Questionaire__c(Opportunity__c = o2.Id);
        insert sB;

        sB.Opportunity__c = o1.Id; // move into occupied Opp → block
        try {
            update sB;
            System.assert(false, 'Update should be blocked');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('already exists'));
        }
    }

    @IsTest
    static void bulk_block_in_same_batch() {
        Opportunity o = makeOpp('Bulk');

        Closed_Won_Lost_Questionaire__c a = new Closed_Won_Lost_Questionaire__c(Opportunity__c = o.Id);
        Closed_Won_Lost_Questionaire__c b = new Closed_Won_Lost_Questionaire__c(Opportunity__c = o.Id);

        Test.startTest();
        try {
            insert new List<Closed_Won_Lost_Questionaire__c>{ a, b };
            System.assert(false, 'One should fail');
        } catch (DmlException e) {
            // Expect partial success: one insert ok, one blocked
            System.assert(e.getDmlIndex(0) == 1 || e.getNumDml() == 1);
        }
        Test.stopTest();
    }
}