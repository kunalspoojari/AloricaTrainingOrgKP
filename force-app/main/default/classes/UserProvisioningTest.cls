@isTest
public class UserProvisioningTest {
	static testMethod void newUser() {
         UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
         insert r;
        
         User u = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
         LastName = 'last',
         Email = 'manager@alorica.com',
         Username = 'manager@alorica.com' + System.currentTimeMillis(),
         ADManager__c = '',
         ADObjectId__c ='1234',
         ADRole__c ='My Role',
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US');
         insert u;
        
         User u2 = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
         LastName = 'last',
         Email = 'manager@alorica.com',
         Username = 'manager@alorica.com' + System.currentTimeMillis(),
         ADManager__c = '1234',
         ADObjectId__c ='12345',
         ADRole__c ='My Role',
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US');
 		 insert u2;
    }
 		
}