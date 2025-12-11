trigger ServiceValidationTrigger on Service__c (before update) {

    Set<Id> serviceIdsToCheck = new Set<Id>();
    Set<Id> oppIds = new Set<Id>();

    // Step 1: Identify Service__c records where Go_Live_Date__c changed AND Is_Edit_From_Flow__c = true
    for (Service__c newSvc : Trigger.new) {
        Service__c oldSvc = Trigger.oldMap.get(newSvc.Id);

        // Run only if edited from flow + Go_Live_Date__c changed
        if (
            newSvc.Go_Live_Date__c != oldSvc.Go_Live_Date__c) {

            serviceIdsToCheck.add(newSvc.Id);

            if (newSvc.Opportunity__c != null) {
                oppIds.add(newSvc.Opportunity__c);
            }
        }
    }

    if (oppIds.isEmpty()) return;

    // Step 2: Query Opportunities with CloseDate
    Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(
        [SELECT Id, CloseDate FROM Opportunity WHERE Id IN :oppIds]
    );

    // Step 3: Query all Service__c related to these Opportunities
    Map<Id, List<Service__c>> oppToServicesMap = new Map<Id, List<Service__c>>();

    for (Service__c svc : [
        SELECT Id, Go_Live_Date__c, Opportunity__c
        FROM Service__c
        WHERE Opportunity__c IN :oppIds
    ]) {
        if (!oppToServicesMap.containsKey(svc.Opportunity__c)) {
            oppToServicesMap.put(svc.Opportunity__c, new List<Service__c>());
        }
        oppToServicesMap.get(svc.Opportunity__c).add(svc);
    }

    // Step 4: Validate Go_Live_Date__c >= Opportunity.CloseDate
    for (Service__c svc : Trigger.new) {

        if (!serviceIdsToCheck.contains(svc.Id)) continue;

        Opportunity opp = oppMap.get(svc.Opportunity__c);
        if (opp == null) continue;

        List<Service__c> allServices = oppToServicesMap.get(svc.Opportunity__c);

        if (allServices == null) continue;
        
System.debug('opp.CloseDate-->'+opp.CloseDate);
        for (Service__c s : allServices) {
            if (s.Go_Live_Date__c != null &&
                opp.CloseDate != null &&
                s.Go_Live_Date__c < opp.CloseDate) {

                svc.addError(
                    'Service Revenue Start Date cannot be earlier than Opportunity Close Date.'
                );
                break;
            }
        }
    }
}