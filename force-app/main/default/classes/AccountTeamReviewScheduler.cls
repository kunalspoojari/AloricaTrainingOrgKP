global class AccountTeamReviewScheduler implements Schedulable {
  
    
    global void execute(SchedulableContext SC) {
        // Execute the batch job with a scope size of 200 to respect email limits
        Database.executeBatch(new AccountTeamReviewBatch(), 1);
        
        //String cronExp = '0 0 0 1 1,4,7,10 ? *';
        //System.schedule('Account Team Review - Quarterly', cronExp, new AccountTeamReviewScheduler());
        
    }
}