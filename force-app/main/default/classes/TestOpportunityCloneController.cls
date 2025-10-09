@isTest
private class TestOpportunityCloneController{

    static testMethod void Testmethod1() {

       // setup a reference to the page the controller is expecting with the parameters
        PageReference pref = Page.OppProdClone;
        Test.setCurrentPage(pref);

        Account a = new Account(Name ='icrm testing acc');
        insert a;
        
        Date myDate = date.today();
        opportunity oppr = new opportunity(Name='opp1' ,  AccountId= a.Id,StageName = 'Qualified Opportunity', CloseDate = myDate, Pricebook2Id = Test.getStandardPricebookId());
        insert oppr;
        
        Product2 pro2 = new Product2(Name='BXCDXXX', isActive=true);
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=1,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),isActive=true,UseStandardPrice = false);
        insert pbe2;
        
        Site__c s = new Site__c(name = 'site', Lost_Time__c = 12.00, Annual_Agent_Hours__c =12.00,Offsite_Shrink__c = 12.00,Attrition_Production__c = 9.00, Attrition_Training__c = 7.00);
        insert s;
        
        PricingCalculator__c pc = new PricingCalculator__c(Training_Length__c = 12.00,Hours_of_Operation__c = 'Full 24 hours 7 days',Handle_Minutes__c = 11.00,Handle_Hours__c = 12.00,Gross_Profit_Cost__c = 12.00,GP__c = 12.00, FTE__c = 10.00, Facilities__c = 12.00,Facililtes_per_Seat__c = 12.00,Services__c = 'Voice',CS_WF_Costs__c = 11.00, Corp_SGA_Costs__c = 3.00,Commissions_Costs__c = 2.00, Training_Billable__c = 'Yes',Billing_Mechanism__c = 'Per Minute', Billable_Payroll_Hours__c = 12.00, Attrition_Training_Costs__c =12.00, ApplyPremiumWage__c = true, Allocated_Corp_SGA_Costs__c = 12.00, AHT__c = 12.00, Agent_Wage_Cost__c = 12.00, Agent_Incentive_Cost__c = 12.00, Agent_Profile__c = 'Tier 1',Site__c = s.id, Agent_Wage__c = 11.00, Opportunity__c = oppr.id); 
        insert pc;
        
        
        
        List<OpportunityLineItem> opList = new List<OpportunityLineItem>();
        OpportunityLineItem op = new OpportunityLineItem (Quantity=25, Agent_Profile__c = 'Tier 3' ,Headcount__c = 100,Gross_Profit__c = 0.30, Client_Preferred_Site__c = s.id, Is_Cloned__c = true, Channel_s__c = 'Voice',Primary_Product__c = true, OpportunityId=oppr.Id,UnitPrice=1,PriceBookEntryId=pbe2.Id);                                     
        insert op;
       

        // Construct the standard controller
        ApexPages.StandardController con = new ApexPages.StandardController(op);

        // create the controller
        OpportunityCloneController ext = new OpportunityCloneController(con);

        // Switch to test context
        Test.startTest();

        // call the cloneWithItems method
        PageReference ref = ext.cloneOP();
        // create the matching page reference
        PageReference redir = new PageReference('/'+ext.newRecordId);
 		
        pc.Agent_Wage__c = 12.00;
        update pc;
        
        delete pc;
        
        undelete pc;
        
        Test.stopTest();

    }   
}