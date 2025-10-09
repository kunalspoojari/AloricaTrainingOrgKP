@isTest
public class opportunityprodTest {
    /*@testSetup static void validateopportunityprod() {
        Account testAccount1 = new Account(
            Inside_Sales_Owner__c = ' Test Account ',
            Name = 'Test Account 01',
            Industry = 'Technology',
            LID__LinkedIn_Company_Id__c = '123400000'
        );
        insert testAccount1;
        
        // Create Opportunity 
        Opportunity testOpportunity1 = new Opportunity(
            AccountId = testAccount1.Id,
            //Pricebook2Id = testPriceBook.Id,
            Name = 'Test Opportunity 01',
            CloseDate = date.newInstance(2020, 03, 01),
            StageName = 'Proposal', 
            Deal_Type__c='New Logo',
           zzz_Service_Type__c = 'Customer Care',
            zzz_IT_Development_Required__c = true,
            Type = 'Organic - New',
            zzz_Collections__c = 'Yes',
            zzz_Sales__c = 'Yes',
            zzz_Outbound__c = 'Yes',
            zzz_Payment_Card_Information_PCI__c = 'Yes',
            zzz_Personal_Health_Information_PHI__c = 'Yes',
            zzzPersonal_Identifiable_Information_PII__c = 'Yes',
            //zzz_Automatic_Dialer__c = '',
            zzz_Preview_Dialer__c = 'Yes',
            ForecastCategoryName = 'Omitted',
            zzz_of_FTE_Whole_Number__c = 10,
            LeadSource = 'Inside Sales', // Sales Hotline
            NextStep = 'Next Step Test',
            Description = 'Description Test',
            
            // Reason_Lost_by_Stage - Validation Rule
            Probability = 30,
            Reason_Lost__c = 'Price was too high'
        );
        insert testOpportunity1;
        
        // Create Product
        Product2 testProduct = new Product2(
            Name = 'Test Product', 
            ProductCode = '105001',
            IsActive = true
        );    
        insert testProduct;
        
        // Create Price Book 
        Pricebook2 testPriceBook = new Pricebook2(
            Name = 'Test Pricebook',
            IsActive = true
        );
        insert testPriceBook;
        
        
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(
            SBQQ__Opportunity2__c = testOpportunity1.Id,
            SBQQ__Account__c = testAccount1.Id,
            SBQQ__PriceBook__c = testPriceBook.Id,
            SBQQ__Primary__c = true
        );
        insert testQuote;
        
        // Create QuoteLine
        String qlRecordTypeId = Schema.SObjectType.SBQQ__QuoteLine__c.getRecordTypeInfosByName().get('Quote Line Default').getRecordTypeId();
        
        SBQQ__QuoteLine__c testQuoteLine = new  SBQQ__QuoteLine__c(
            RecordTypeId = qlRecordTypeId,
            SBQQ__Quote__c = testQuote.Id,
            SBQQ__Product__c = testProduct.Id,
            SBQQ__StartDate__c = date.newInstance(2019, 04, 01),
            SBQQ__OriginalQuoteLineId__c = 'OriginalQuoteLine Test',
            SBQQ__Quantity__c = 10,
            SBQQ__ListPrice__c = 50,
            Target_Training_Launch_Date__c=date.newInstance(2019, 04, 01),
            Estimated_Go_Live_Date__c = system.today());  
        
        insert testQuoteLine;  
        system.debug('testQuoteLine'+testQuoteLine);
        
        
        
        // Create Revenue Forecast
        Revenue_Forecast__c testRevenueForecast = new  Revenue_Forecast__c(
            Quote_Line__c = testQuoteLine.Id,
            Opportunity__c = testOpportunity1.Id,
            Revenue_Expected_Date__c = date.newInstance(2019, 05, 02),
            Month_Number__c = 12,
            Expected_Revenue__c = 12000
        );
        Test.startTest();
        insert testRevenueForecast; 
        Test.stopTest();
    } 
    
    testMethod static void insertRevenueRecordTest() {
        List<opportunityprod.monthWrapper> nn=new List<opportunityprod.monthWrapper>();
        opportunityprod.monthWrapper mn=new opportunityprod.monthWrapper();
        mn.comment='Test';
        mn.exprevenue='Test';
        mn.id='Test';
        mn.month='Test';
        mn.monthNo=2;
        mn.quantity='Test';
        nn.add(mn);
        
        List <SBQQ__QuoteLine__c> quoteLineList1 = [SELECT Id, SBQQ__EffectiveSubscriptionTerm__c, SBQQ__NetTotal__c, SBQQ__EffectiveStartDate__c  
                                                    FROM SBQQ__QuoteLine__c where  SBQQ__OriginalQuoteLineId__c = 'OriginalQuoteLine Test'];
        
        opportunityprod.insertRevenueRecord(nn,quoteLineList1[0].Id);
        
    }
    
    testMethod static void getMonthDetailsTest() {
        
        List <SBQQ__QuoteLine__c> quoteLineList2 = [SELECT Id, SBQQ__EffectiveSubscriptionTerm__c, SBQQ__NetTotal__c, SBQQ__EffectiveStartDate__c, 
                                                    Target_Training_Launch_Date__c FROM SBQQ__QuoteLine__c where  SBQQ__OriginalQuoteLineId__c = 'OriginalQuoteLine Test'];
        
        opportunityprod.getMonthDetails(quoteLineList2[0].Id);
        
    }
    testMethod static void deleteQuoteLineRecordsTest() {
        
        List<Revenue_Forecast__c> quoteLineList3= [SELECT ID, Month__c, Quantity_FTE__c, Expected_Revenue__c
                                                   FROM Revenue_Forecast__c];
        
        opportunityprod.deleteQuoteLineRecords(quoteLineList3[0].Id);
        
    }
    testMethod static void UpdateQuoteLineRecordsTest() {
        
        List<SBQQ__QuoteLine__c> quoteLineList4= [SELECT Id, SBQQ__EffectiveSubscriptionTerm__c , Calculated_Rev_per_FTE_Quantity__c, SBQQ__NetTotal__c,  Headcount__c, Target_Training_Launch_Date__c,Total_Revenue__c,
                                                  FY20_Revenue__c,FY21_Revenue__c,First_12_Months_Revenue__c 
                                                  FROM SBQQ__QuoteLine__c];
        
        opportunityprod.UpdateQuoteLineRecords(quoteLineList4[0].Id);
        
    }
    
    testMethod static void monthWrapperTest() {
    }*/
}