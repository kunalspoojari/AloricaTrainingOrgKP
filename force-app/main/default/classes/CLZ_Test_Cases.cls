@isTest 
public class CLZ_Test_Cases {  
    static testMethod void validateOppTrigger() {
        Account a = new Account(name='TEST');
        a.APTS_Company_Type__c = 'LLC';
        insert a;
        
        Contact con = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'testcontact' + Math.abs(Crypto.getRandomInteger()) + '@example.com',
            AccountId = a.Id);
        insert con;
        
        Opportunity o = new Opportunity(name='TEST - test opp');
        o.StageName = '1 - Initial Development Stage';
        o.CloseDate = System.today();
        o.Current_Vendor__c = 'None';
        o.Contract_Months__c = 4;
        o.Accountid = a.id;
        o.No_Business_Development_Assignee__c = true;
        o.Client_Contact__c = con.Id;
        insert o;
        
        o.Site_selected__c = 'Testing';
        update o;
        
        o = [Select CLZ_Domestic_Sites_Raw__c  from opportunity where id=:o.id];
    }
}