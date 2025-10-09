public class PricingCalculatorTriggerHandler  {

    //all operations to be performed before an record is inserted
    public static void beforeInsert(List<PricingCalculator__c> newList) {
        
        //Always calculate fields on BeforeInsert
        PricingCalculatorService.recalculatePrices(newList);
    }

    //all operations to be performed after an record is inserted
    public static void afterInsert(List<PricingCalculator__c> newList) {
           
    }

    //all operations to be performed before an record is updated
    public static void beforeUpdate(List<PricingCalculator__c> newList, Map<Id, PricingCalculator__c> oldMap) {
        
        //get Calculators where any of the User Inputs fields changed to determine if we should re-calculate.
        List<PricingCalculator__c> pcsToRecalculate = SObjectUtility.getRecordsWhereFieldsChanged(newList, oldMap, PricingCalculatorService.CALCULATOR_INPUTS);

        if (pcsToRecalculate != null && pcsToRecalculate.size() > 0) {          
            
            PricingCalculatorService.recalculatePrices(pcsToRecalculate);
        }
    }

    //all operations to be performed after an record is updated
    public static void afterUpdate(List<PricingCalculator__c> newList, Map<Id, PricingCalculator__c> oldMap) {
    
        List<OpportunityLineItem> allOlis = new List<OpportunityLineItem>();
        allOlis = [select id,Name__c,PrimaryDirectional__c,OpportunityId from OpportunityLineItem where PrimaryDirectional__c in :newList];
        if(allOlis.size() > 0){
            update allOlis;
        }
    }
    //all operations to be performed before an record is deleted
  /*  public static void beforeDelete(Map<Id, PricingCalculator__c> oldMap) {

    }

    //all operations to be performed after an record is deleted
    public static void afterDelete(Map<Id, PricingCalculator__c> oldMap) {

    }

    //all operations to be performed after an record is undeleted
 	 public static void afterUndelete(List<PricingCalculator__c> newList) {

    } */
    
}