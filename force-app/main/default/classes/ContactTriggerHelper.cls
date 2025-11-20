public class ContactTriggerHelper {

    public static void updateContactStatusFromCampaign(List<Contact> newList, Map<Id, Contact> oldMap) {

        Set<Id> campaignIds = new Set<Id>();
        List<Contact> processContacts = new List<Contact>();

        // STEP 1 → Identify Contacts where VOC_Campaign__c is populated or changed
        for (Contact c : newList) {

            Boolean shouldProcess = false;

            // On INSERT → always process
            if (oldMap == null) {
                shouldProcess = true;
            }
            else {
                // On UPDATE → process only if campaign changed
                Contact oldC = oldMap.get(c.Id);

                if (oldC.VOC_Campaign__c != c.VOC_Campaign__c) {
                    shouldProcess = true;
                }
            }

            if (shouldProcess && c.VOC_Campaign__c != null) {
                processContacts.add(c);
                campaignIds.add(c.VOC_Campaign__c);
            }
        }

        if (campaignIds.isEmpty()) return;

        // STEP 2 → Fetch default member status for these campaigns
        Map<Id, String> campaignIdToDefaultStatus = new Map<Id, String>();

        for (CampaignMemberStatus cms : [
            SELECT CampaignId, Label
            FROM CampaignMemberStatus
            WHERE CampaignId IN :campaignIds
            AND IsDefault = TRUE
        ]) {
            campaignIdToDefaultStatus.put(cms.CampaignId, cms.Label);
        }

        // STEP 3 → Prepare updates
        List<Contact> contactsToUpdate = new List<Contact>();

        for (Contact c : processContacts) {
            if (campaignIdToDefaultStatus.containsKey(c.VOC_Campaign__c)) {

                contactsToUpdate.add(new Contact(
                    Id = c.Id,
                    Campaign_Status__c = campaignIdToDefaultStatus.get(c.VOC_Campaign__c)
                ));
            }
        }

        // STEP 4 → Update Contacts
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}