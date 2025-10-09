@isTest
public class TestPricingCalculatorService {
    
    static testMethod void Testmethod1() {
        Account a = new Account(Name ='icrm testing acc');
        insert a;
        
        Contact con = new Contact(FirstName = 'Test',LastName = 'Contact',Email = 'testcontact' + Math.abs(Crypto.getRandomInteger()) + '@example.com',AccountId = a.Id);
        insert con;
        
        Date myDate = date.today();
        opportunity oppr = new opportunity(Name='opp1' ,  AccountId= a.Id,Client_Contact__c = con.Id,StageName = 'Qualified Opportunity', CloseDate = myDate,No_Business_Development_Assignee__c = true);
        insert oppr;
        
        Site__c s = new Site__c(name = 'site', Lost_Time__c = 12.00, Annual_Agent_Hours__c =12.00,Offsite_Shrink__c = 12.00,Attrition_Production__c = 9.00, Attrition_Training__c = 7.00);
        insert s;
        
        PricingCalculator__c pc = new PricingCalculator__c(Training_Length__c = 12.00,Hours_of_Operation__c = 'Full 24 hours 7 days',Handle_Minutes__c = 11.00,Handle_Hours__c = 12.00,Gross_Profit_Cost__c = 12.00,GP__c = 12.00, FTE__c = 10.00, Facilities__c = 12.00,Facililtes_per_Seat__c = 12.00,Services__c = 'Voice',CS_WF_Costs__c = 11.00, Corp_SGA_Costs__c = 3.00,Commissions_Costs__c = 2.00, Training_Billable__c = 'Yes',Billing_Mechanism__c = 'Per Minute', Billable_Payroll_Hours__c = 12.00, Attrition_Training_Costs__c =12.00, ApplyPremiumWage__c = true, Allocated_Corp_SGA_Costs__c = 12.00, AHT__c = 12.00, Agent_Wage_Cost__c = 12.00, Agent_Incentive_Cost__c = 12.00, Agent_Profile__c = 'Tier 1',Site__c = s.id, Agent_Wage__c = 11.00, Opportunity__c = oppr.id); 
        insert pc;
        
        Test.startTest();
        Decimal value = 12000.00;
        double tenToXpower = 1.00;
        PricingCalculatorService.roundToPowerOfTen(value, tenToXpower);
        PricingCalculatorService.roundUpFiftyCents(value);       
        Test.stopTest();      
    }
    
    static testMethod void Testmethod2() {
        Account a = new Account(Name ='icrm testing acc');
        insert a;
        
        Contact con = new Contact(FirstName = 'Test',LastName = 'Contact',Email = 'testcontact' + Math.abs(Crypto.getRandomInteger()) + '@example.com',AccountId = a.Id);
        insert con;
        
        Date myDate = date.today();
        opportunity oppr = new opportunity(Name='opp1' ,Client_Contact__c = con.Id,No_Business_Development_Assignee__c = true,  AccountId= a.Id,StageName = 'Qualified Opportunity', CloseDate = myDate);
        insert oppr;
        
        Site__c s = new Site__c(name = 'site', Lost_Time__c = 12.00, Annual_Agent_Hours__c =12.00,Offsite_Shrink__c = 12.00,Attrition_Production__c = 9.00, Attrition_Training__c = 7.00);
        insert s;
        
        PricingCalculator__c pc = new PricingCalculator__c(Training_Length__c = 12.00,Hours_of_Operation__c = 'Full 24 hours 7 days',Handle_Minutes__c = 11.00,Handle_Hours__c = 12.00,Gross_Profit_Cost__c = 12.00,GP__c = 12.00, FTE__c = 10.00, Facilities__c = 12.00,Facililtes_per_Seat__c = 12.00,Services__c = 'Voice',CS_WF_Costs__c = 11.00, Corp_SGA_Costs__c = 3.00,Commissions_Costs__c = 2.00, Training_Billable__c = 'Yes',Billing_Mechanism__c = 'Per Minute', Billable_Payroll_Hours__c = 12.00, Attrition_Training_Costs__c =12.00, ApplyPremiumWage__c = true, Allocated_Corp_SGA_Costs__c = 12.00, AHT__c = 12.00, Agent_Wage_Cost__c = 12.00, Agent_Incentive_Cost__c = 12.00, Agent_Profile__c = 'Tier 2',Site__c = s.id, Agent_Wage__c = 110.00, Opportunity__c = oppr.id); 
        insert pc;
        
        Test.startTest();
        Decimal value = 12000.00;
        double tenToXpower = 1.00;
        PricingCalculatorService.roundToPowerOfTen(value, tenToXpower);
        PricingCalculatorService.roundUpFiftyCents(value);
        
        Test.stopTest();
        
    }
    
    static testMethod void Testmethod3() {
        Account a = new Account(Name ='icrm testing acc');
        insert a;
        
        Contact con = new Contact(FirstName = 'Test',LastName = 'Contact',Email = 'testcontact' + Math.abs(Crypto.getRandomInteger()) + '@example.com',AccountId = a.Id);
        insert con;
        
        Date myDate = date.today();
        opportunity oppr = new opportunity(Name='opp1' ,Client_Contact__c = con.Id,No_Business_Development_Assignee__c = true,  AccountId= a.Id,StageName = 'Qualified Opportunity', CloseDate = myDate);
        insert oppr;
        
        Site__c s = new Site__c(TM_Wages__c = 1.00,Agent_Incentives__c = 100.00, OT_Premium__c = 10.00, Facililtes_Total__c = 100, Total_Seats_in_Site__c = 12, Site_Payroll_Total_Cost__c = 100, TrainingRate__c = 120.00, Recruiting_Cost__c = 100,name = 'site', Agents_Wages_Tier_3__c = 12.00, Lost_Time__c = 1.00,Agent_Wage_Premium__c = 12.00, Annual_Agent_Hours__c =12.00,Onsite_Shrink__c =1.00,Offsite_Shrink__c = 1.00,Attrition_Production__c = 90.00, Attrition_Training__c = 700.00);
        insert s;
        
        PricingCalculator__c pc = new PricingCalculator__c(Training_Length__c = 1200.00,Hours_of_Operation__c = 'Full 24 hours 7 days',Handle_Minutes__c = 11.00,Handle_Hours__c = 12.00,Gross_Profit_Cost__c = 12.00,GP__c = 12.00, FTE__c = 100.00, Facilities__c = 12.00,Facililtes_per_Seat__c = 12.00,Services__c = 'Voice',CS_WF_Costs__c = 11.00, Corp_SGA_Costs__c = 3.00,Commissions_Costs__c = 2.00, Training_Billable__c = 'Yes',Billing_Mechanism__c = 'Per Minute', Billable_Payroll_Hours__c = 1200.00, Attrition_Training_Costs__c =12.00, ApplyPremiumWage__c = true, Allocated_Corp_SGA_Costs__c = 12.00, AHT__c = 12.00, Agent_Wage_Cost__c = 12.00, Agent_Incentive_Cost__c = 12.00, Agent_Profile__c = 'Tier 3',Site__c = s.id, Agent_Wage__c = 1100.00, Opportunity__c = oppr.id); 
        insert pc;
        
        Test.startTest();
        Decimal value = 12000.00;
        double tenToXpower = 1.00;
        PricingCalculatorService.roundToPowerOfTen(value, tenToXpower);
        PricingCalculatorService.roundUpFiftyCents(value);
        
        Test.stopTest();
        
    }
    
    static testMethod void Testmethod4() {
        Account a = new Account(Name ='icrm testing acc');
        insert a;
        
        Contact con = new Contact(FirstName = 'Test',LastName = 'Contact',Email = 'testcontact' + Math.abs(Crypto.getRandomInteger()) + '@example.com',AccountId = a.Id);
        insert con;
        
        Date myDate = date.today();
        opportunity oppr = new opportunity(Name='opp1' ,Client_Contact__c = con.Id,No_Business_Development_Assignee__c = true,  AccountId= a.Id,StageName = 'Qualified Opportunity', CloseDate = myDate);
        insert oppr;
        
        Site__c s = new Site__c(Payment_Terms_Percent__c = 10.00,COLA_percent__c = 10.00,Deal_Years__c = 5.00,Target_EBITDA__c = 5.00,Commissions__c = 10.00,CS_Workforce__c = 10, Corp_SGA__c = 10, Other_Costs__c = 10.00,Regional_Support__c = 100, Ops_Manager_Bonus__c = 10.00,Tax_and_Benefits__c = 1.00,Trainers_Wages__c =1.00,Ops_Managers_Ratio__c = 10.00,Ops_Manager_Wages__c = 1000.00,QA_Wages__c = 10.00,Trainers_Ratio__c = 100.00,QA_Ratio__c = 100.00,TM_Incentives__c = 1.00,TM_Ratio__c = 1, TM_Wages__c = 1.00,Agent_Incentives__c = 100.00, OT_Premium__c = 10.00, Facililtes_Total__c = 100, Total_Seats_in_Site__c = 12, Site_Payroll_Total_Cost__c = 100, TrainingRate__c = 120.00, Recruiting_Cost__c = 100,name = 'site', Agents_Wages_Tier_3__c = 12.00, Lost_Time__c = 1.00,Agent_Wage_Premium__c = 12.00, Annual_Agent_Hours__c =12.00,Onsite_Shrink__c =1.00,Offsite_Shrink__c = 1.00,Attrition_Production__c = 90.00, Attrition_Training__c = 700.00);
        insert s;
        
        PricingCalculator__c pc = new PricingCalculator__c(Payroll_Base_Rate__c = 10.00,Training_Rate__c = 10.00,Total_Estimated_Cost__c = 1000.00,Regional_Support_Costs__c = 10.00,IT_Maintenance_Cost__c = 10.00, Other_Uptfront_Travel_Telco__c = 10.00,Recruiting__c = 10.00,Payroll__c = 10.00,IT_Maintenance__c = 10.00, Seat_Count__c = 10.00,Ops_Mgmt_bonus_Cost__c = 10.00,Trainer_Wage_Cost__c = 100.00,Ops_Mgmt_Cost__c =10.00,QA_Wage_Cost__c = 100.00,TM_Incentive_Cost__c = 10.00,TM_Cost__c =100.00, Overtime_Cost__c = 100.00,Ramp_Training_Costs__c = 100.00,Training_Length__c = 1200.00,Hours_of_Operation__c = 'Full 24 hours 7 days',Handle_Minutes__c = 11.00,Handle_Hours__c = 12.00,Gross_Profit_Cost__c = 12.00,GP__c = 12.00, FTE__c = 100.00, Facilities__c = 12.00,Facililtes_per_Seat__c = 12.00,Services__c = 'Voice',CS_WF_Costs__c = 11.00, Corp_SGA_Costs__c = 3.00,Commissions_Costs__c = 2.00, Training_Billable__c = 'Yes',Billing_Mechanism__c = 'Per Minute', Billable_Payroll_Hours__c = 1200.00, Attrition_Training_Costs__c =12.00, ApplyPremiumWage__c = true, Allocated_Corp_SGA_Costs__c = 12.00, AHT__c = 12.00, Agent_Wage_Cost__c = 12.00, Agent_Incentive_Cost__c = 12.00, Agent_Profile__c = 'Tier 3',Site__c = s.id, Agent_Wage__c = 1100.00, Opportunity__c = oppr.id); 
        insert pc;
        
        Test.startTest();
        Decimal value = 12000.00;
        double tenToXpower = 1.00;
        PricingCalculatorService.roundToPowerOfTen(value, tenToXpower);
        PricingCalculatorService.roundUpFiftyCents(value);
        
        Test.stopTest();
        
    }
    // New test method: getRecordTypeInfoForObject
    static testMethod void testGetRecordTypeInfoForObject() {
        List<Schema.RecordTypeInfo> rtList = SObjectUtility.getRecordTypeInfoForObject('Account');
        System.assert(rtList.size() > 0, 'Should return at least one record type');
    }

    // New test method: getPicklistInfoForObject
    static testMethod void testGetPicklistInfoForObject() {
        List<Schema.PicklistEntry> pickList = SObjectUtility.getPicklistInfoForObject('Industry', 'Account');
        System.assert(pickList.size() > 0, 'Should return picklist entries');
    }

    // New test method: createMapWithIdKeyFromList & getIdsFromList
    static testMethod void testIdMapUtilities() {
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Test A'),
            new Account(Name = 'Test B')
        };
        insert accounts;

        // getIdsFromList
        Set<Id> ids = SObjectUtility.getIdsFromList('Id', accounts);
        System.assertEquals(accounts.size(), ids.size(), 'ID set should match list size');

        // createMapWithIdKeyFromList
        Map<Id, List<SObject>> idMap = SObjectUtility.createMapWithIdKeyFromList('Id', accounts);
        System.assert(idMap.containsKey(accounts[0].Id), 'Should contain account Id key');
    }

    // New test method: createMapWithStringKeyFromList
    static testMethod void testCreateMapWithStringKeyFromList() {
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Alpha', Industry = 'Technology'),
            new Account(Name = 'Beta', Industry = 'Technology')
        };
        insert accounts;

        Map<String, List<SObject>> industryMap = SObjectUtility.createMapWithStringKeyFromList('Industry', accounts);
        System.assert(industryMap.containsKey('Technology'), 'Industry map should include "Technology"');
    }
}