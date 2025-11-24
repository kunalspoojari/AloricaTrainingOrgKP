@isTest
public class AccountCloneControllerTest {
    @testSetup
    public static void setupTestData(){
    	Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(LastName='Contact',AccountId=acc.Id);
        insert con;
        
        Account cloneAcc = new Account(Name='New Clone Account');
        insert cloneAcc;
    }
    
	@isTest
    public static void testCase(){
        List<Account> accList = [SELECT Id FROM Account LIMIT 2];
        
        if(!accList.isEmpty())
        	AccountCloneController.cloneContactsForAccount(accList[0].Id,accList[1].Id);
    }
}