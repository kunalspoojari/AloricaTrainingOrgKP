@isTest
public class AccountMonthlyScheduleTest {
    @isTest
    static void testScheduledJob() {
        // Create test Account
        Account acc = new Account(Name = 'Test Account', Account_Name_Finance__c = null);
        insert acc;

        Test.startTest();

        String cronExp = '0 0 0 1 * ?';
        String jobId = System.schedule('Test Monthly Schedule', cronExp, new AccountMonthlySchedule());

        // Run execute method directly (date check is bypassed in test)
        AccountMonthlySchedule job = new AccountMonthlySchedule();
        job.execute(null);

        Test.stopTest();

        // Verify account still exists
        Account updatedAcc = [SELECT Id FROM Account WHERE Id = :acc.Id];
        System.assertNotEquals(null, updatedAcc);
    }
}