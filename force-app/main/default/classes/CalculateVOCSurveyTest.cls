@isTest(SeeAllData=true)
public class CalculateVOCSurveyTest {
	 @isTest static void NewVOCSurvey(){
        // Setup test data
        // Create a unique UserName
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName=uniqueUserName);
 
        System.runAs(u) {
            
            String u1 = [Select Id FROM User WHERE IsActive = TRUE ORDER BY Id ASC LIMIT 1 ].Id;
            String a1 = [Select Id FROM Account LIMIT 1 ].Id;
            
            Contact c = new Contact();
            c.AccountId = a1;
            c.FirstName = 'Aldrin';
            c.LastName = 'Song';
            c.Title = 'Test';
            insert c;
            
            c.VOC_Survey__c = 9;
            update c;
            
            c.VOC_Survey__c = 5;
            update c;
        }
    }
}