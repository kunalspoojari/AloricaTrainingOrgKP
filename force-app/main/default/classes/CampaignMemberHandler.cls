/*
*********************************************************
Apex Class Name    : CampaignMemberHandler
Created Date       : November 20, 2025
@description       : This is Handler for CampaignMember
@author            : Kunal Poojari
Modification Log:
Ver   Date         Author                               Modification
1.0   20-11-2025   Kunal Poojari                      Initial Version
*********************************************************
*/
public class CampaignMemberHandler {

    public static void updateContactStatusWhenContactSelected(
        List<CampaignMember> newList,
        Map<Id, CampaignMember> oldMap
    ) {
        Set<Id> contactIds = new Set<Id>();

        // Collect ContactIds from records in trigger context
        for (CampaignMember cm : newList) {
            if (cm.ContactId != null) {
                contactIds.add(cm.ContactId);
            }
        }

        if (contactIds.isEmpty()) return;

        // -------------------------------------------------------------------
        // STEP 1: Fetch the LATEST CampaignMember for each Contact
        // -------------------------------------------------------------------
        Map<Id, CampaignMember> latestCMByContact = new Map<Id, CampaignMember>();

        for (CampaignMember cm : [
            SELECT Id, ContactId, Status, CreatedDate
            FROM CampaignMember
            WHERE ContactId IN :contactIds
            ORDER BY CreatedDate DESC
        ]) {
            // pick only first (latest) CM per contact
            if (!latestCMByContact.containsKey(cm.ContactId)) {
                latestCMByContact.put(cm.ContactId, cm);
            }
        }

        // -------------------------------------------------------------------
        // STEP 2: Determine if the latest CM had a status change
        // -------------------------------------------------------------------
        Map<Id, String> contactToNewStatus = new Map<Id, String>();

        for (CampaignMember newCM : newList) {
            
            CampaignMember latestCM = latestCMByContact.get(newCM.ContactId);

            // Only consider the LATEST CampaignMember for that contact
            if (latestCM == null || latestCM.Id != newCM.Id) {
                continue; // ignore older CM records
            }

            Boolean shouldUpdate = false;

            // INSERT → latest CM automatically affects contact
            if (Trigger.isInsert) {
                shouldUpdate = true;
            }

            // UPDATE → only if status changed for the latest CM
            if (Trigger.isUpdate) {
                CampaignMember oldCM = oldMap != null ? oldMap.get(newCM.Id) : null;

                if (oldCM != null && newCM.Status != oldCM.Status) {
                    shouldUpdate = true;
                }
            }

            if (shouldUpdate) {
                contactToNewStatus.put(newCM.ContactId, newCM.Status);
            }
        }

        if (contactToNewStatus.isEmpty()) return;

        // -------------------------------------------------------------------
        // STEP 3: Update Contact with the new status
        // -------------------------------------------------------------------
        List<Contact> toUpdate = new List<Contact>();
        for (Id conId : contactToNewStatus.keySet()) {
            toUpdate.add(new Contact(
                Id = conId,
                Campaign_Status__c = contactToNewStatus.get(conId)
            ));
        }

        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }
}