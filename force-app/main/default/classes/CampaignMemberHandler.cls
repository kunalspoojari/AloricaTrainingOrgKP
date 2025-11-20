public class CampaignMemberHandler {

    public static void updateContactStatusWhenContactSelected(
        List<CampaignMember> newList,
        Map<Id, CampaignMember> oldMap
    ) {

        Map<Id, String> contactToStatus = new Map<Id, String>();

        for (CampaignMember cm : newList) {

            Boolean updateNeeded = false;

            CampaignMember oldCM = oldMap != null ? oldMap.get(cm.Id) : null;

            // -----------------------------
            // Contact newly selected
            // -----------------------------
            if (Trigger.isInsert && cm.ContactId != null) {
                updateNeeded = true;
            }
            else if (Trigger.isUpdate) {
                if (oldCM.ContactId == null && cm.ContactId != null) {
                    updateNeeded = true;
                }
            }

            // -----------------------------
            // Status updated (Latest CM)
            // -----------------------------
            if (Trigger.isUpdate && cm.ContactId != null) {
                if (oldCM != null && cm.Status != oldCM.Status) {
                    updateNeeded = true;
                }
            }

            // If no change → skip
            if (!updateNeeded) continue;

            // Add mapping only if status is available
            if (cm.ContactId != null && cm.Status != null) {
                contactToStatus.put(cm.ContactId, cm.Status);
            }
        }

        if (contactToStatus.isEmpty()) return;

        // -----------------------------
        // Update Contact records
        // -----------------------------
        List<Contact> updateList = new List<Contact>();

        for (Id conId : contactToStatus.keySet()) {
            updateList.add(new Contact(
                Id = conId,
                Campaign_Status__c = contactToStatus.get(conId)
            ));
        }

        if (!updateList.isEmpty()) {
            update updateList;
        }
    }

}