global class AccountTeamReviewScheduler implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        // Execute the batch job with a scope size of 200 to respect email limits
        Database.executeBatch(new AccountTeamReviewBatch(), 200);
    }
}