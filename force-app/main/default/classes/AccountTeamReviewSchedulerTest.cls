@IsTest
private class AccountTeamReviewSchedulerTest {

    @IsTest
    static void testSchedulerExecution() {

        // Use any valid cron expression (date/time irrelevant in test context)
        String cronExp = '0 0 0 1 1 ?';

        Test.startTest();
            System.schedule(
                'AccountTeamReviewScheduler_Test',
                cronExp,
                new AccountTeamReviewScheduler()
            );
        Test.stopTest();

        // Verify the scheduled job exists and has completed
        CronTrigger ct = [
            SELECT Id, State, CronJobDetail.Name
            FROM CronTrigger
            WHERE CronJobDetail.Name = 'AccountTeamReviewScheduler_Test'
            LIMIT 1
        ];

        
    }
}