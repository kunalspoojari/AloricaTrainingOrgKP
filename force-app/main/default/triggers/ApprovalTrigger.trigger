trigger ApprovalTrigger on sbaa__Approval__c (after insert,after update) {

   /* Set<Id> quoteIds = new set<Id>();
    for(sbaa__Approval__c a : trigger.new){
        if(a.Quote__c != null){ quoteIds.add(a.Quote__c); }
    }
    
    if(QuoteIds.size() > 0){
        List<AggregateResult> AllQuoteApprovals = [SELECT Quote__c, COUNT(Id) total FROM sbaa__Approval__c WHERE Quote__c =:QuoteIds GROUP BY Quote__c];
        List<AggregateResult> CompletedQuoteApprovals = [SELECT Quote__c, COUNT(Id) total FROM sbaa__Approval__c WHERE Quote__c =:QuoteIds AND (sbaa__Status__c = 'Approved' OR sbaa__Status__c = 'Rejected') GROUP BY Quote__c];
        List<SBQQ__Quote__c> AllQuoteList = New List<SBQQ__Quote__c>();
        List<SBQQ__Quote__c> CompletedQuoteList = New List<SBQQ__Quote__c>();
        
        for(AggregateResult a : AllQuoteApprovals){
            SBQQ__Quote__c tempQuote = New SBQQ__Quote__c();
            tempQuote.Id = (Id)a.get('Quote__c');
            tempQuote.Count_of_Approvals__c = (Integer)a.get('total');
            AllQuoteList.add(tempQuote);
        }
        update AllQuoteList;
        
        for(AggregateResult a : CompletedQuoteApprovals){
            SBQQ__Quote__c tempQuote = New SBQQ__Quote__c();
            tempQuote.Id = (Id)a.get('Quote__c');
            tempQuote.Count_of_Completed_Approvals__c = (Integer)a.get('total');
            CompletedQuoteList.add(tempQuote);
        }
        update CompletedQuoteList;
    }*/

}