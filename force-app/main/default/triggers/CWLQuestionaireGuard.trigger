trigger CWLQuestionaireGuard on Closed_Won_Lost_Questionaire__c (before insert, before update) {
    // Collect Opportunity Ids from the batch
    Set<Id> oppIds = new Set<Id>();
    for (Closed_Won_Lost_Questionaire__c s : Trigger.new) {
        if (s.Opportunity__c != null) oppIds.add(s.Opportunity__c);
    }
    if (oppIds.isEmpty()) return;

    // Earliest existing record per Opportunity from DB
    Map<Id, Closed_Won_Lost_Questionaire__c> firstByOpp = new Map<Id, Closed_Won_Lost_Questionaire__c>();
    for (Closed_Won_Lost_Questionaire__c e : [
        SELECT Id, Opportunity__c, CreatedDate
        FROM Closed_Won_Lost_Questionaire__c
        WHERE Opportunity__c IN :oppIds
        ORDER BY Opportunity__c, CreatedDate ASC
    ]) {
        if (!firstByOpp.containsKey(e.Opportunity__c)) {
            firstByOpp.put(e.Opportunity__c, e);
        }
    }

    // Handle duplicates within the same DML batch
    Map<Id, Closed_Won_Lost_Questionaire__c> batchFirst = new Map<Id, Closed_Won_Lost_Questionaire__c>();

    for (Closed_Won_Lost_Questionaire__c s : Trigger.new) {
        if (s.Opportunity__c == null) continue;

        Closed_Won_Lost_Questionaire__c dbExisting = firstByOpp.get(s.Opportunity__c);

        if (dbExisting != null) {
            // Allow editing the earliest record only
            Boolean editingEarliest = (Trigger.isUpdate && s.Id == dbExisting.Id);
            if (!editingEarliest) {
                s.addError(
                    'A Seller Survey already exists for this Opportunity. ' +
                    'Open and edit it: /' + dbExisting.Id
                );
            }
            continue;
        }

        // No DB record yet → allow first in-batch, block the rest
        if (!batchFirst.containsKey(s.Opportunity__c)) {
            batchFirst.put(s.Opportunity__c, s);
        } else {
            s.addError(
                'Only one Seller Survey per Opportunity is allowed. ' +
                'Another record in this save targets the same Opportunity.'
            );
        }
    }
}