@isTest
public class TestDefaultCSAssignee {
      @TestSetup static void setup(){
         //Creating Account
         Account a = new Account (
             Name = 'Test',
             Industry = 'Technology'
         );
         insert a;
     }
	   @isTest static void testCreateOpportunity(){
         Opportunity opp = new Opportunity();
         opp.Name ='Test';
         opp.CloseDate = date.today() +1 ;
         opp.StageName = 'Qualified Opportunity';
         insert opp; 
        
     }
}