@isTest
private class approvalQuoteLinesControllerTest {
    /*@isTest
    private static void testQLController() {
		Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Industry = 'Communications';
        acc.Inside_Sales_Owner__c = 'Account Owner';   
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
		insert customPB;
        
        insert acc;
            
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        /*opp.Additional_Notes_to_Pricing_Team__c = 'test';*/
        /*opp.Name = 'Test Opportunity';
        opp.CloseDate = Date.today().addMonths(12).addDays(-1);
        opp.StageName = 'Qualified Opportunity';
        opp.Deal_Type__c = 'New Logo';
        opp.Vertical__c = 'Energy & Utilities';
        opp.Outsourcing_Maturity__c = 'Experienced [2-5 years]';
        opp.Business_Type__c = 'B2B';
        opp.RecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Lightning').getRecordTypeId();
        opp.PriceBook2Id = customPB.id;
        insert opp;
         
        Product2 prod = new Product2();
        prod.Name = 'Customer Care';
        prod.ProductCode = 'CORE-CC';
        prod.IsActive = true;
        insert prod;  
        
        //Opportunity tmp = [Select PriceBook2Id from Opportunity Where Id = :opp.id];   
        
        PriceBookEntry newPb2 = new  PriceBookEntry();
        newPb2.Product2Id = prod.Id;
        newPb2.PriceBook2Id = test.getStandardPricebookId();
        newPb2.UnitPrice = 2200;
        newPb2.IsActive = true;
        insert newPb2;

        PriceBookEntry newPb1 = new  PriceBookEntry();
        newPb1.Product2Id = prod.Id;
        newPb1.PriceBook2Id = opp.Pricebook2Id;
        newPb1.UnitPrice = 2200;
        newPb1.IsActive = true;
        insert newPb1;    
        
        
        
        SBQQ__Quote__c q = new SBQQ__Quote__c();
        
        insert q;
        SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c();
        ql.RecordTypeId =  Schema.SObjectType.SBQQ__QuoteLine__c.getRecordTypeInfosByName().get('Quote Line Default').getRecordTypeId();

        ql.SBQQ__Quote__c = q.Id;
        ql.SBQQ__Product__c = prod.Id;
        insert ql;
        
        approvalQuoteLinesController controller = new approvalQuoteLinesController();
        controller.quoteId = q.Id;
        List<SBQQ__QuoteLine__c> qlList = controller.quotelines;
    }*/
}