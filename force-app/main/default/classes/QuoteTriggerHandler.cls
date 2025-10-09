@isTest //Not a test class
public class QuoteTriggerHandler {
 /*public static boolean firstRun = true;
 public static void QuoteErrorChecker (List<SBQQ__Quote__c> quotes){
        for(SBQQ__Quote__c q : quotes) { 
          if(q.Error_Message__c!=NULL){
              q.addError(q.Error_Message__c);
          }
        }    
    }
    
    public static void updateOLIs (List<SBQQ__Quote__c> newQuotes, Map<Id, SBQQ__Quote__c> oldQuotes){
        Set<Id> oppIds = new set<Id>();
      List<OpportunityLineItem> oliLoopList = new List<OpportunityLineItem>();
      List<OpportunityLineItem> olisToUpdate = new List<OpportunityLineItem>();
        for(SBQQ__Quote__c q : newQuotes) {
            if(q.ApprovalStatus__c == 'Pending' && q.ApprovalStatus__c != oldQuotes.get(q.Id).ApprovalStatus__c){
                 oppIds.add(q.SBQQ__Opportunity2__c);
            }
           
        }
        for(Id o: oppIds){
            oliLoopList = [SELECT Id, ProductCode, Pricing_Model_DQM_Snapshot__c, OpportunityId FROM OpportunityLineItem where ProductCode LIKE 'CORE%' AND OpportunityId =: o];
        olisToUpdate.addAll(oliLoopList);
        }
        for(OpportunityLineItem oli: olisToUpdate){
            oli.Pricing_Model_DQM_Snapshot__c = true;
        }
       update olisToUpdate;
    }*/
}