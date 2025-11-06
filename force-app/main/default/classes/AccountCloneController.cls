public class AccountCloneController {
    @AuraEnabled
    public static void cloneContactsForAccount(Id sourceAccountId, Id targetAccountId) {
        Set<String> contactIdSet = new Set<String>();
        
        for(Contact con : [SELECT Id,FirstName, LastName, Email, Phone
            			   FROM Contact
            			   WHERE AccountId = :sourceAccountId
        				  ])
        {
            contactIdSet.add(con.Id);
        }
        
        for(AccountContactRelation acr : [SELECT ContactId FROM AccountContactRelation
                                          WHERE AccountId = : sourceAccountId
                                         ])
        {
            contactIdSet.add(acr.ContactId);                                    
        }

        // Create a list to store the new AccountContactRelation records
        List<AccountContactRelation> accountContactRelations = new List<AccountContactRelation>();
        
        for (String c : contactIdSet) {
            AccountContactRelation acr = new AccountContactRelation();
            acr.AccountId = targetAccountId;
            acr.ContactId = c;

            accountContactRelations.add(acr);
        }

        // Insert the new AccountContactRelation records
        if (!accountContactRelations.isEmpty())
            Database.insert(accountContactRelations,false);
    }
}