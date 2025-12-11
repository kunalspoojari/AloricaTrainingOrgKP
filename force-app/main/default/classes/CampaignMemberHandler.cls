/*
*********************************************************
Apex Class Name    : CampaignMemberHandler
Created Date       : November 20, 2025
@description       : This is Handler for CampaignMember
@author            : Kunal Poojari
Modification Log:
Ver   Date         Author                               Modification
1.0   20-11-2025   Kunal Poojari                        Initial Version
2.0   26-11-2025   Kunal Poojari                        Fixed Attended priority logic
2.1   26-11-2025   Kunal Poojari                        Handle updates to non-latest Attended records
*********************************************************
*/
public class CampaignMemberHandler {

    /* ==========================================================
       HELPER: Determine which contacts STILL have Attended
       AFTER applying newList changes (simulate final state)
       ========================================================== */
    private static Map<Id, Boolean> getCorrectedAttendedStatus(
        Set<Id> contactIds,
        List<CampaignMember> newList,
        Map<Id, CampaignMember> oldMap
    ) {
        Map<Id, Boolean> attendedMap = new Map<Id, Boolean>();

        if (contactIds == null || contactIds.isEmpty()) return attendedMap;

        // Query DB Attended records
        for (CampaignMember cm : [
            SELECT ContactId
            FROM CampaignMember
            WHERE ContactId IN :contactIds
            AND Status = 'Attended'
        ]) {
            if (cm.ContactId != null) attendedMap.put(cm.ContactId, true);
        }

        // Overlay trigger new values to simulate final state
        for (CampaignMember cmNew : newList) {
            if (cmNew.ContactId == null) continue;
            CampaignMember oldCM = oldMap != null ? oldMap.get(cmNew.Id) : null;

            // If old was Attended and new is not → remove attended for that contact (may be re-added below)
            if (oldCM != null && oldCM.Status == 'Attended' && cmNew.Status != 'Attended') {
                attendedMap.remove(cmNew.ContactId);
            }

            // If new is Attended → ensure it's present
            if (cmNew.Status == 'Attended') {
                attendedMap.put(cmNew.ContactId, true);
            }
        }

        return attendedMap;
    }

    /* ==========================================================
       HELPER: Get latest CM per contact (DB view)
       ========================================================== */
    private static Map<Id, CampaignMember> getLatestCM(Set<Id> contactIds) {
        Map<Id, CampaignMember> result = new Map<Id, CampaignMember>();
        if (contactIds == null || contactIds.isEmpty()) return result;

        for (CampaignMember cm : [
            SELECT Id, ContactId, Status, CreatedDate
            FROM CampaignMember
            WHERE ContactId IN :contactIds
            ORDER BY CreatedDate DESC
        ]) {
            if (cm.ContactId != null && !result.containsKey(cm.ContactId)) {
                result.put(cm.ContactId, cm);
            }
        }
        return result;
    }

    /* ==========================================================
       INSERT + UPDATE LOGIC (fixed)
       ========================================================== */
    public static void updateContactStatusWhenContactSelected(
        List<CampaignMember> newList,
        Map<Id, CampaignMember> oldMap
    ) {
        Set<Id> contactIds = new Set<Id>();
        for (CampaignMember cm : newList) {
            if (cm.ContactId != null) contactIds.add(cm.ContactId);
        }
        if (contactIds.isEmpty()) return;

        // Final attended map (simulate end-of-transaction state)
        Map<Id, Boolean> finalHasAttended = getCorrectedAttendedStatus(contactIds, newList, oldMap);

        // Latest CM per contact (DB view)
        Map<Id, CampaignMember> latestCMByContact = getLatestCM(contactIds);

        // Build list of contacts that must be re-evaluated regardless of whether the updated record is latest:
        // 1) any trigger record changed from Attended -> not Attended (older record case)
        // 2) any trigger record changed to Attended (adds priority)
        Set<Id> contactsToForceEval = new Set<Id>();
        for (CampaignMember cmNew : newList) {
            if (cmNew.ContactId == null) continue;
            CampaignMember oldCM = oldMap != null ? oldMap.get(cmNew.Id) : null;

            // Case: old was Attended and new is not → we must re-evaluate contact
            if (oldCM != null && oldCM.Status == 'Attended' && cmNew.Status != 'Attended') {
                contactsToForceEval.add(cmNew.ContactId);
            }

            // Case: new record (insert) or update to Attended → re-evaluate
            if (cmNew.Status == 'Attended') {
                contactsToForceEval.add(cmNew.ContactId);
            }

            // Also, if the trigger record is the latest and its status changed, we will handle below.
            if (Trigger.isUpdate && oldCM != null && oldCM.Status != cmNew.Status) {
                contactsToForceEval.add(cmNew.ContactId);
            }
            if (Trigger.isInsert) {
                contactsToForceEval.add(cmNew.ContactId);
            }
        }

        Map<Id, String> contactToNewStatus = new Map<Id, String>();

        // First, handle trigger records that are the latest and whose status changed (existing behavior, optimized)
        for (CampaignMember cmNew : newList) {
            if (cmNew.ContactId == null) continue;
            CampaignMember latest = latestCMByContact.get(cmNew.ContactId);
            if (latest == null) continue;

            // If this trigger record equals the latest by Id, and status changed (or insert), evaluate normally
            if ((latest.Id != null && cmNew.Id != null && latest.Id == cmNew.Id) ||
                Trigger.isInsert) {

                Boolean shouldUpdate = false;
                if (Trigger.isInsert) shouldUpdate = true;
                if (Trigger.isUpdate) {
                    CampaignMember oldCM = oldMap != null ? oldMap.get(cmNew.Id) : null;
                    if (oldCM != null && oldCM.Status != cmNew.Status) shouldUpdate = true;
                }

                if (!shouldUpdate) continue;

                if (finalHasAttended.containsKey(cmNew.ContactId)) {
                    contactToNewStatus.put(cmNew.ContactId, 'Attended');
                } else {
                    contactToNewStatus.put(cmNew.ContactId, cmNew.Status);
                }
            }
        }

        // Next, ensure we handle contacts that need forced re-evaluation (including updates to non-latest Attended)
        // For each such contact, compute final status (Attended if any, else latest CM's status or null)
        for (Id conId : contactsToForceEval) {

            // If already determined above, skip (avoid overwrite)
            if (contactToNewStatus.containsKey(conId)) continue;

            if (finalHasAttended.containsKey(conId)) {
                contactToNewStatus.put(conId, 'Attended');
                continue;
            }

            // Use latest CM's status (latestCMByContact is DB latest; it's OK because we want latest created record)
            CampaignMember latest = latestCMByContact.get(conId);

            // If latest is null (no DB records) attempt to find in trigger's newList (insert before Id assigned)
            if (latest == null) {
                // find any trigger new record for this contact and prefer its status
                for (CampaignMember cmNew : newList) {
                    if (cmNew.ContactId == conId) {
                        latest = cmNew;
                        break;
                    }
                }
            }

            if (latest != null) {
                contactToNewStatus.put(conId, latest.Status);
            } else {
                contactToNewStatus.put(conId, null);
            }
        }

        if (contactToNewStatus.isEmpty()) return;

        // Perform update
        List<Contact> toUpdate = new List<Contact>();
        for (Id conId : contactToNewStatus.keySet()) {
            toUpdate.add(new Contact(
                Id = conId,
                Campaign_Status__c = contactToNewStatus.get(conId)
            ));
        }
        if (!toUpdate.isEmpty()) update toUpdate;
    }

    /* ==========================================================
       DELETE LOGIC
       ========================================================== */
    public static void handleDelete(List<CampaignMember> oldList) {
        Set<Id> contactIds = new Set<Id>();
        for (CampaignMember cm : oldList) {
            if (cm.ContactId != null) contactIds.add(cm.ContactId);
        }
        if (contactIds.isEmpty()) return;

        // After delete, simulate final state with empty trigger list (deleted rows removed from DB)
        Map<Id, Boolean> finalHasAttended = getCorrectedAttendedStatus(contactIds, new List<CampaignMember>(), null);
        Map<Id, CampaignMember> latestCMByContact = getLatestCM(contactIds);

        List<Contact> toUpdate = new List<Contact>();
        for (Id conId : contactIds) {
            if (finalHasAttended.containsKey(conId)) {
                toUpdate.add(new Contact(Id = conId, Campaign_Status__c = 'Attended'));
            } else {
                CampaignMember latest = latestCMByContact.get(conId);
                if (latest != null) {
                    toUpdate.add(new Contact(Id = conId, Campaign_Status__c = latest.Status));
                } else {
                    toUpdate.add(new Contact(Id = conId, Campaign_Status__c = null));
                }
            }
        }
        if (!toUpdate.isEmpty()) update toUpdate;
    }

   
}