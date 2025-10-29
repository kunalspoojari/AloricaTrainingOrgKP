public class AccountCloneController {
    @AuraEnabled
    public static void cloneContactsForAccount(Id sourceAccountId, Id targetAccountId) {
        List<Contact> contacts = [
            SELECT FirstName, LastName, Email, Phone
            FROM Contact
            WHERE AccountId = :sourceAccountId
        ];

        // Create a list to store the new AccountContactRelation records
        List<AccountContactRelation> accountContactRelations = new List<AccountContactRelation>();
        
        for (Contact c : contacts) {
            AccountContactRelation acr = new AccountContactRelation();
            acr.AccountId = targetAccountId;
            acr.ContactId = c.Id;
            
            accountContactRelations.add(acr);
        }

        // Insert the new AccountContactRelation records
        if (!accountContactRelations.isEmpty())
            Database.insert(accountContactRelations,false);
    }
}