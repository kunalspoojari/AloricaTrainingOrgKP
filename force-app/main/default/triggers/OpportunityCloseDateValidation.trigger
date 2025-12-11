trigger OpportunityCloseDateValidation on Opportunity (before update) {

    // Collect all Opp IDs where CloseDate is changed AND Is_Edited_From_Flow__c = false
    Set<Id> oppIdsToCheck = new Set<Id>();

    for (Opportunity newOpp : Trigger.new) {
        Opportunity oldOpp = Trigger.oldMap.get(newOpp.Id);

        // Run only if NOT edited from flow
        if (newOpp.Is_Edited_From_Flow__c == true) {

            // Check CloseDate changed
            if (newOpp.CloseDate != oldOpp.CloseDate) {
                oppIdsToCheck.add(newOpp.Id);
            }
        }
    }

    if (oppIdsToCheck.isEmpty()) return;

    // Query related Service__c records
    Map<Id, List<Service__c>> oppToServicesMap = new Map<Id, List<Service__c>>();

    for (Service__c svc : [
        SELECT Id, Go_Live_Date__c, Opportunity__c
        FROM Service__c
        WHERE Opportunity__c IN :oppIdsToCheck
    ]) {
        if (!oppToServicesMap.containsKey(svc.Opportunity__c)) {
            oppToServicesMap.put(svc.Opportunity__c, new List<Service__c>());
        }
        oppToServicesMap.get(svc.Opportunity__c).add(svc);
    }

    // Validation
    for (Opportunity opp : Trigger.new) {
        if (!oppIdsToCheck.contains(opp.Id)) continue;

        List<Service__c> servicesList = oppToServicesMap.get(opp.Id);

        if (servicesList == null) continue;

        for (Service__c svc : servicesList) {
            if (svc.Go_Live_Date__c != null && svc.Go_Live_Date__c < opp.CloseDate) {

                opp.addError('Please check Service Revenue Start Date for related Services before updating CloseDate.');
                break;
            }
        }
    }
}