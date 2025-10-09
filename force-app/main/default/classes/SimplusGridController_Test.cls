@isTest//(SeeAllData=true)
public class SimplusGridController_Test {
        
    /*@testSetup static void generateRecordsTest() {
        
        // Create Account
        Account testAccount1 = new Account(
            Inside_Sales_Owner__c = ' Test Account ',
            Name = 'Test Account 01',
            Industry = 'Technology',
            LID__LinkedIn_Company_Id__c = '123400000'
        );
        insert testAccount1;
        
        Account testAccount2 = new Account(
            Inside_Sales_Owner__c = 'Jae Parkoa',
            Name = 'Test Account 02',
            Industry = 'Test Industry',
            LID__LinkedIn_Company_Id__c = '1222333400000'
        );
        insert testAccount2;
        
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
    
        // Create Opportunity 
        Opportunity testOpportunity1 = new Opportunity(
            AccountId = testAccount1.Id,
            Pricebook2Id = testPriceBook.Id,
            Name = 'Test Opportunity 01',
            CloseDate = date.newInstance(2020, 03, 01),
            StageName = 'Proposal',
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

        /* Create Quote */
       /* SBQQ__Quote__c testQuote = new SBQQ__Quote__c(
            SBQQ__Opportunity2__c = testOpportunity1.Id,
            SBQQ__Account__c = testAccount1.Id,
            SBQQ__PriceBook__c = testPriceBook.Id,
            SBQQ__Primary__c = true
        );
        insert testQuote;
        
        // Create QuoteLine
        SBQQ__QuoteLine__c testQuoteLine = new  SBQQ__QuoteLine__c(
            SBQQ__Quote__c = testQuote.Id,
            SBQQ__Product__c = testProduct.Id,
            SBQQ__StartDate__c = date.newInstance(2019, 04, 01),
            SBQQ__OriginalQuoteLineId__c = 'OriginalQuoteLine Test',
            SBQQ__Quantity__c = 10,
            SBQQ__ListPrice__c = 50,
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
    

    testMethod static void generateQuoteLineRecordsTest() {
        
        List <SBQQ__QuoteLine__c> quoteLineList = [SELECT Id, SBQQ__EffectiveSubscriptionTerm__c, SBQQ__NetTotal__c, SBQQ__EffectiveStartDate__c  
                                                   FROM SBQQ__QuoteLine__c where  SBQQ__OriginalQuoteLineId__c = 'OriginalQuoteLine Test'];

        SimplusGridController.generateQuoteLineRecords(quoteLineList[0].Id);
  
    }
 
    testMethod static void regenerateQuoteLineRecordsTest() {
         
        List <SBQQ__QuoteLine__c> quoteLineList = [SELECT Id, SBQQ__EffectiveSubscriptionTerm__c, SBQQ__NetTotal__c, SBQQ__EffectiveStartDate__c  
                                                   FROM SBQQ__QuoteLine__c where  SBQQ__OriginalQuoteLineId__c = 'OriginalQuoteLine Test'];
        
        SimplusGridController.regenerateQuoteLineRecords(quoteLineList[0].Id);
        SimplusGridController.getmydomain();
        SimplusGridController.getRecState(quoteLineList[0].Id);
  
    }
    
      testMethod static void deleteQuoteLineRecordsTest() {
        
        List <SBQQ__QuoteLine__c> quoteLineList = [SELECT Id, SBQQ__EffectiveSubscriptionTerm__c, SBQQ__NetTotal__c, SBQQ__EffectiveStartDate__c  
                                                   FROM SBQQ__QuoteLine__c];

        SimplusGridController.deleteQuoteLineRecords(quoteLineList[0].Id);
  
    }

    
    // CONTROL FIELD TEST
     testMethod static void controlFieldTest() {
        List<String> fieldset = new List<String>();
        fieldset.add('SimplusGrid');
        SimplusGridController.getControlFields(fieldset);
    }
    

    // GET FIELD SET TEST
    testMethod static void getFieldSetTest() {

        String fieldSets = '[{"name": "SimplusGrid", "type": "display"}, {"name": "SimplusGrid_Filter", "type": "filter"}]';
        
        List <SBQQ__QuoteLine__c> quoteLineList = [SELECT Id, SBQQ__EffectiveSubscriptionTerm__c, SBQQ__NetTotal__c, SBQQ__EffectiveStartDate__c  
                                                   FROM SBQQ__QuoteLine__c];
        
        List<SimplusGridController.FieldSetConfig> configs = (List<SimplusGridController.FieldSetConfig>)JSON.deserialize(fieldSets, List<SimplusGridController.FieldSetConfig>.class);
        SimplusGridController.FieldSetWrapperGroup fieldSet = SimplusGridController.getFieldSet('Revenue_Forecast__c', quoteLineList[0].Id, configs, 'SimplusGrid');
        
        System.assertNotEquals(fieldSet, null);
        
    }
    
    
    // GET USER TEST
    testMethod static void getUserTest() {
        Test.startTest();
        user testingUser = SimplusGridController.fetchUser();
        System.assertNotEquals(testingUser, null);
        
        List<Id> quoteIds = new List<Id>();
        for(SBQQ__Quote__c q : [SELECT Id FROM SBQQ__Quote__c LIMIT 10]) {
            quoteIds.add(q.Id);
        }
        //SimplusGridController.getQuotesForCloning(quoteIds);
        Test.stopTest();
    }

    
    
    // TOGGLE
    testMethod static void toggle() {
        
        List <SBQQ__QuoteLine__c> quoteLineList = [SELECT Id, SBQQ__EffectiveSubscriptionTerm__c, SBQQ__NetTotal__c, SBQQ__EffectiveStartDate__c  
                                                   FROM SBQQ__QuoteLine__c];
        
        SimplusGridController.FieldSetWrapperGroup wrapperGroup = SimplusGridController.toggle('Revenue_Forecast__c', quoteLineList[0].Id, 'SimplusGrid', 1);
        System.assertNotEquals(wrapperGroup, null);
    }
    
   /* testMethod static void testCustomUtilites() {
        Test.startTest();
        CustomUtilitiesController.doSearch('Account', new List<String>{'Id','Name'}, 'Name <> \'a\'', '', 'tes', new List<String>{'Id','Name'});
        Test.stopTest();
    }
   */
    
    
    // SORT FILTER TESTS
   /* testMethod static void sortFilterTests() {
      
        List<SimplusGrid_Sorting__c> sortGroup = new List<SimplusGrid_Sorting__c>();
        
        SimplusGrid_Sorting__c sort1 = new SimplusGrid_Sorting__c (
            Column__c = 'SBQQ__ProductCode__c',
            Column_Name__c = 'Product Code',
            Order__c = 'ASC',
            Priority__c = 1,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid'
        );
       
        sortGroup.add(sort1);
        SimplusGrid_Sorting__c sort2 = new SimplusGrid_Sorting__c(
            Column__c = 'SBQQ__ProductName__c',
            Column_Name__c = 'Product Name',
            Order__c = 'ASC',
            Priority__c = 2,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid'
        );
        sortGroup.add(sort2);
        
        SimplusGrid_Sorting__c sort3 = new SimplusGrid_Sorting__c(
            Column__c = 'SBQQ__ListPrice__c',
            Column_Name__c = 'Base Price',
            Order__c = 'DESC',
            Priority__c = 3,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid'
        );
        sortGroup.add(sort3);
        insert sortGroup;
        
        
        List<SimplusGrid_Filtering__c> filterGroup = new List<SimplusGrid_Filtering__c>();
        
        
        filterGroup.add(new SimplusGrid_Filtering__c(
            Column__c = 'SBQQ__ProductName__c',
            Column_Name__c = 'Product Name',
            Column_Type__c = 'STRING',
            Operation__c = 'starts with',
            Value__c = 'AIRSTONE 550E',
            Priority__c = 1,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid'
        ));
        filterGroup.add(new SimplusGrid_Filtering__c(
            Column__c = 'SBQQ__ProductName__c',
            Column_Name__c = 'Product Name',
            Column_Type__c = 'STRING',
            Operation__c = 'ends with',
            Value__c = 'AIRSTONE 550E',
            Priority__c = 2,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid'
        ));
        
        filterGroup.add(new SimplusGrid_Filtering__c(
            Column__c = 'SBQQ__ProductName__c',
            Column_Name__c = 'Product Name',
            Column_Type__c = 'STRING',
            Operation__c = 'contains',
            Value__c = 'AIRSTONE 550E',
            Priority__c = 3,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid_Filter'
        ));
        
        
        // FOR NOT NULL, IS NULL
        
           filterGroup.add(new SimplusGrid_Filtering__c(
            Column__c = 'SBQQ__ProductName__c',
            Column_Name__c = 'Product Name',
            Column_Type__c = 'STRING',
            Operation__c = 'not equals',
            Value__c = 'AIRSTONE 550E',
            Priority__c = 4,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid'
        ));
         
        filterGroup.add(new SimplusGrid_Filtering__c(
            Column__c = 'SBQQ__ProductName__c',
            Column_Name__c = 'Product Name',
            Column_Type__c = 'STRING',
            Operation__c = 'is null',
            Value__c = 'AIRSTONE 550E',
            Priority__c = 4,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid'
        ));
      
        filterGroup.add(new SimplusGrid_Filtering__c(
            Column__c = 'SBQQ__ProductName__c',
            Column_Name__c = 'Product Name',
            Column_Type__c = 'STRING',
            Operation__c = 'not null',
            Value__c = 'AIRSTONE 550E',
            Priority__c = 6,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid_Filter'
        ));
        
       
 
        filterGroup.add(new SimplusGrid_Filtering__c(
            Column__c = 'SBQQ__ListPrice__c',
            Column_Name__c = 'Base Price',
            Column_Type__c = 'DOUBLE',
            Operation__c = 'eq',
            Value__c = '0',
            Priority__c = 7,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid_Filter'
        ));
        filterGroup.add(new SimplusGrid_Filtering__c(
            Column__c = 'SBQQ__ListPrice__c',
            Column_Name__c = 'Base Price',
            Column_Type__c = 'DOUBLE',
            Operation__c = 'lt',
            Value__c = '1',
            Priority__c = 8,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid_Filter'
        ));
        filterGroup.add(new SimplusGrid_Filtering__c(
            Column__c = 'SBQQ__ListPrice__c',
            Column_Name__c = 'Base Price',
            Column_Type__c = 'DOUBLE',
            Operation__c = 'gt',
            Value__c = '-1',
            Priority__c = 9,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid_Filter'
        ));
        filterGroup.add(new SimplusGrid_Filtering__c(
            Column__c = 'Price_Firm_Date__c',
            Column_Name__c = 'Price Firm Date',
            Column_Type__c = 'DATE',
            Operation__c = 'before',
            Value__c = '2019-01-31',
            Priority__c = 10,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid_Filter'
        ));
        filterGroup.add(new SimplusGrid_Filtering__c(
            Column__c = 'Price_Firm_Date__c',
            Column_Name__c = 'Price Firm Date',
            Column_Type__c = 'DATE',
            Operation__c = 'after',
            Value__c = '2019-01-29',
            Priority__c = 11,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid_Filter'
        ));
        filterGroup.add(new SimplusGrid_Filtering__c(
            Column__c = 'Price_Firm_Date__c',
            Column_Name__c = 'Price Firm Date',
            Column_Type__c = 'DATE',
            Operation__c = 'equal',
            Value__c = '2019-01-30',
            Priority__c = 12,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid_Filter'
        ));
        filterGroup.add(new SimplusGrid_Filtering__c(
            Column__c = 'Price_Firm_Date__c',
            Column_Name__c = 'Price Firm Date',
            Column_Type__c = 'DATETIME',
            Operation__c = 'before',
            Value__c = '2019-01-31 00:00:01',
            Priority__c = 13,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid_Filter'
        ));
        filterGroup.add(new SimplusGrid_Filtering__c(
            Column__c = 'Price_Firm_Date__c',
            Column_Name__c = 'Price Firm Date',
            Column_Type__c = 'DATETIME',
            Operation__c = 'after',
            Value__c = '2019-01-29 00:00:01',
            Priority__c = 14,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid_Filter'
        ));
        filterGroup.add(new SimplusGrid_Filtering__c(
            Column__c = 'Price_Firm_Date__c',
            Column_Name__c = 'Price Firm Date',
            Column_Type__c = 'DATETIME',
            Operation__c = 'equal',
            Value__c = '2019-01-30 00:00:01',
            Priority__c = 15,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid_Filter'
        ));
        
        filterGroup.add(new SimplusGrid_Filtering__c(
           Column__c = 'SBQQ__ProductName__c',
            Column_Name__c = 'Product Name',
            Column_Type__c = 'STRING',
            Operation__c = 'equals',
            Value__c = 'AIRSTONE 550E',
            Priority__c = 16,
            Active__c = true,
            OwnerId = userInfo.getUserId(),
            List_Source__c = 'SimplusGrid_Filter'
        ));
        insert filterGroup;
        
        
     
        
        
        
        // Create Account
        Account testAccount = new Account(         
            Name = 'Test Account',
            AccountSource = 'Olin Heritage'
        );
        insert testAccount;

        // Create Product
        Product2 testProduct = new Product2(
            Name = 'Test Product',
            ProductCode = '105001' 
        );
        insert testProduct;

        // Create Opportunity 
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            CloseDate = date.newInstance(2019, 03, 01),
            StageName = 'Proposal',
            AccountId = testAccount.Id
        );
        insert testOpportunity;

        // Create Quote
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(   
            SBQQ__Primary__c = true,
            SBQQ__Opportunity2__c = testOpportunity.Id
        );
        insert testQuote;

        // Create Quote Lines
        List<SBQQ__QuoteLine__c> lstTestQuoteLine = new List<SBQQ__QuoteLine__c>();
        SBQQ__QuoteLine__c testQuoteLine = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = testQuote.Id,
            SBQQ__Product__c = testProduct.Id,
            SBQQ__Quantity__c = 1,
            SBQQ__ListPrice__c = 10,
            SBQQ__NetPrice__c = 10,
            SBQQ__Number__c = 1,
            SBQQ__SubscriptionPricing__c = 'Fixed Price'
        );
        lstTestQuoteLine.add(testQuoteLine);
        insert lstTestQuoteLine;
        
        //Generate the filter query
        SimplusGridController.dynamicQueryFilter('SimplusGrid_Filter');

        //Setup the sort and filter wrapper collections
        List<SimplusGridController.SortColumWrapper> sortWrapper = SimplusGridController.querySort('Revenue_Forecast__c','SimplusGrid');
        List<SimplusGridController.FilterColumWrapper> filterWrapper = SimplusGridController.queryFilter('Revenue_Forecast__c','SimplusGrid');
        
        //Test drag and drop
        SimplusGridController.dragAndDrop('sort', JSON.serialize(sortWrapper));
        SimplusGridController.dragAndDrop('filter', JSON.serialize(filterWrapper));
        Test.startTest();
            
            //Ordering updates
            try {
            SimplusGridController.sortColumns(JSON.serialize(sortWrapper[0]), JSON.serialize(sortWrapper), 'SimplusGrid');
            } catch(Exception e) {}
            try {
            SimplusGridController.filterColumns(JSON.serialize(filterWrapper[0]), JSON.serialize(filterWrapper), 'SimplusGrid');
            } catch(Exception e) {}
            
        
        
            //Update the sort and filter wrapper collections        
            sortWrapper = SimplusGridController.querySort('SBQQ__QuoteLine__c','SimplusGrid');  
            filterWrapper = SimplusGridController.queryFilter('SBQQ__QuoteLine__c','SimplusGrid'); 
            SimplusGridController.deleteAllSortFilterItem('sort', JSON.serialize(sortWrapper));
            SimplusGridController.deleteAllSortFilterItem('filter', JSON.serialize(filterWrapper));
        

            SimplusGridController.updateGridRecord(lstTestQuoteLine[0]);
            SimplusGridController.saveRecords(JSON.serialize(lstTestQuoteLine));
    /*
            List<String> lstStr = new List<String>();
            lstStr.add('Test');
            SimplusGridController.cloneRecords(JSON.serialize(lstStr));
            SimplusGridController.cloneandsubmitRecords(JSON.serialize(lstStr));
   */
    /*    Test.stopTest();
    }
    

    
    // TEST SORT FILTER
    public testmethod static void testSortFilter() {
    
        List<SimplusGridController.SortColumWrapper> sortWrapper = SimplusGridController.querySort('SBQQ__QuoteLine__c','SimplusGrid');
        List<SimplusGridController.FilterColumWrapper> filterWrapper = SimplusGridController.queryFilter('SBQQ__QuoteLine__c','SimplusGrid');
        Test.startTest();
        //Test drag and drop
        SimplusGridController.dragAndDrop('sort', JSON.serialize(sortWrapper));
        SimplusGridController.dragAndDrop('filter', JSON.serialize(filterWrapper));
        
        //Ordering updates
        try {
        SimplusGridController.sortColumns(JSON.serialize(sortWrapper[0]), JSON.serialize(sortWrapper), 'SimplusGrid');
        } catch(Exception e) {}
        try {
        SimplusGridController.filterColumns(JSON.serialize(filterWrapper[0]), JSON.serialize(filterWrapper), 'SimplusGrid');
        } catch(Exception e) {}
    }*/
    
    
    
    
    
    
    
  
}