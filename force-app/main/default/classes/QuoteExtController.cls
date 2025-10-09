@isTest //Not a test class
public class QuoteExtController {
   /* private Id quoteId;
    public QuoteExtController(ApexPages.StandardController stdController) {
        quoteId = stdController.getId();
    }
    public PageReference onSubmit() {
       List<SBQQ__Quote__c> myQuote = [SELECT SBQQ__Primary__c FROM SBQQ__Quote__c WHERE Id =:quoteId LIMIT 1];
      
        if (quoteId != null && myQuote[0].SBQQ__Primary__c) {
            SBAA.ApprovalAPI.submit(quoteId, SBAA__Approval__c.Quote__c);
              return new PageReference('/' + quoteId);
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please ensure your quote is marked primary before submitting for approval.')); 
         return null;
        }
      
    }
    public PageReference onRecall() {
        if (quoteId != null) {
            SBAA.ApprovalAPI.recall(quoteId, SBAA__Approval__c.Quote__c);
        }
        return new PageReference('/' + quoteId);
    }*/
}