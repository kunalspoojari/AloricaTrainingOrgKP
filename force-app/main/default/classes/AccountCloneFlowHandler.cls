public with sharing class AccountCloneFlowHandler {
    
    public class CloneRequest {
        @InvocableVariable(required=true)
        public Id sourceAccountId;
        
        @InvocableVariable
        public Boolean cloneContacts;
    }
    
    public class CloneResponse {
        @InvocableVariable
        public Id newAccountId;
        
        @InvocableVariable
        public String message;
    }

    @InvocableMethod(label='Clone Account with Contacts' description='Clone an Account record and optionally its related Contacts.')
    public static List<CloneResponse> cloneAccountWithContacts(List<CloneRequest> requests) {
        List<CloneResponse> responses = new List<CloneResponse>();

        for (CloneRequest req : requests) {
            CloneResponse resp = new CloneResponse();
            try {
                if (req.sourceAccountId == null) {
                    throw new AuraHandledException('Source Account Id is required.');
                }

                // ✅ Step 1: Get source Account
                Account src = [
                    SELECT Id, Name, Type, Phone, Website, Industry, Rating,
                           BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,
                           ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry,
                           Description, Fax
                    FROM Account
                    WHERE Id = :req.sourceAccountId
                    LIMIT 1
                ];

                // ✅ Step 2: Clone Account
                Account cloned = src.clone(false, true, false, false);
                cloned.Name = src.Name + ' - Clone';
                insert cloned;

                // ✅ Step 3: Optionally clone related Contacts
                if (req.cloneContacts == true) {
                    List<Contact> relatedContacts = [
                        SELECT FirstName, LastName, Email, Phone, Title, MailingStreet, MailingCity, MailingState, MailingPostalCode
                        FROM Contact
                        WHERE AccountId = :src.Id
                    ];
                    if (!relatedContacts.isEmpty()) {
                        List<Contact> newContacts = new List<Contact>();
                        for (Contact c : relatedContacts) {
                            Contact nc = c.clone(false, true, false, false);
                            nc.AccountId = cloned.Id;
                            newContacts.add(nc);
                        }
                        insert newContacts;
                    }
                }

                // ✅ Step 4: Prepare response
                resp.newAccountId = cloned.Id;
                resp.message = 'Account cloned successfully' + (req.cloneContacts ? ' with Contacts.' : '.');
            } catch (Exception e) {
                resp.message = 'Error: ' + e.getMessage();
            }
            responses.add(resp);
        }

        return responses;
    }
}