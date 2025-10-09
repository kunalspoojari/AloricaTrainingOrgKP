public class massLeadConversion {
    public static void convertLeadToAccountContact(){
        List<Lead> leadList = [Select Id, Name from Lead WHERE Mass_Update_Check__c=true];
        List<Contact> contactList = new List<Contact>();
        for(Lead l : leadList){
            Contact con = new Contact();
            con.FirstName = l.FirstName;
            con.LastName = l.LastName;
            con.Email = l.Email;
            con.OwnerId='005Ov00000bZQbpIAG';
            con.Contact_Stage__c = 'Marketing Qualified Lead';
            con.AccountId=l.Account__c;
            contactList.add(con);
        }
        insert contactList;
        
    }

}