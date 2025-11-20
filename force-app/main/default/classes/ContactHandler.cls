public class ContactHandler {
    public static void handleAfter(List<Contact> newList, Map<Id, Contact> oldMap) {
        ContactTriggerHelper.updateContactStatusFromCampaign(newList, oldMap);
    }

}