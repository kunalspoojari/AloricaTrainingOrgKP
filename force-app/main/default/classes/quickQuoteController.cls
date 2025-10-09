@isTest //Not a test class
public class quickQuoteController {
    
    /*public pageReference editLinesRedirect()
    {
        Id quoteId = ApexPages.currentPage().getParameters().get('qId');
        ///apex/quickQuotePage?qId={!Opportunity.Id}&aId={!Opportunity.AccountId}
        // MUST PASS ACCOUNT ID TO URL
        String targetUrl = returnUrl(quoteId);
        return new PageReference(targetURL);
    }
    
    public pageReference genQuote()
    {
        String quoteId;
        // MUST PASS ACCOUNT ID TO URL
        Id acctId = ApexPages.currentPage().getParameters().get('aId');
        
        // IF GENERATING A QUICK QUOTE FROM OPPORTUNITY, PASS OPPORTUNITY ID TO URL
        Id oppId = ApexPages.currentPage().getParameters().get('oId');
        
        // IF NO OPPORTUNITY ID IS PASSED TO THE URL, A NEW OPPORTUNITY IS CREATED
        if(oppId==null){
            Opportunity opp = new Opportunity(AccountID = acctId, stagename = 'Proposal/Price Quote', name = 'New Opportunity', closedate = Date.today());
            Database.insert(opp);
            oppId = opp.id;
        }

        // CREATE NEW QUOTE
        SBQQ__Quote__c q = new SBQQ__Quote__c (SBQQ__Opportunity2__c = oppId, SBQQ__Status__c='Draft', SBQQ__Type__c='Quote', SBQQ__Account__c = acctId, SBQQ__Primary__c = true);
        Database.Insert(q);
        quoteId = q.Id;
        String targetUrl = returnUrl(quoteId);
        return new PageReference(targetURL);
        

    }
    
    public String returnUrl(Id quoteId)
    {
        //If(quoteId != null){
        // CONSTRUCT URL FOR CPQ CART
            String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();        
            //String targetURL = sfdcBaseURL.replace('-c.','-sbqq.') + '/apex/sbqq__sb?scontrolCaching=1&id='+quoteID+'#/product/lookup?qId='+quoteId+'&aId='+acctId;
            String targetURL = sfdcBaseURL.replace('-c.','-sbqq.') + '/apex/sbqq__sb?id='+quoteID;
            return targetURL;
        //} 
	}*/
}