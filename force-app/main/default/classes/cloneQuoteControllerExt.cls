@isTest //Not a test class
public class cloneQuoteControllerExt {
 	/*private Id quoteId;
    public Double lineCount {
        get;
        set;
    }  
    public List<SBQQ__QuoteLine__c> quoteLines{
        get; 
        set;
    }
    
    
    public cloneQuoteControllerExt(ApexPages.StandardController stdController) {
        quoteId = stdController.getId();
    }
    
    public PageReference onClone() {
        if(SBQQ.TriggerControl.isEnabled()){
          SBQQ.TriggerControl.disable();  
        }
        
        if (quoteId != null) {
            String quoteQuery = Utils.getCreatableFieldsSOQL('SBQQ__Quote__c','id=\''+ quoteId +'\'');
            SBQQ__Quote__c q = (SBQQ__Quote__c)Database.query(quoteQuery);
            SBQQ__Quote__c q2 = q.clone(false, true);
            q2.SBQQ__Source__c = q.Id;
            q2.SBQQ__Primary__c = false;       
            insert q2;
            
           String QLQuery = Utils.getCreatableFieldsSOQL('SBQQ__QuoteLine__c','SBQQ__Quote__c=\''+ quoteId +'\''); 
            List<SBQQ__QuoteLine__c> myQLs = (List<SBQQ__QuoteLine__c>)Database.query(QLQuery); 
            List<SBQQ__QuoteLine__c> myQLs2 = myQLs.deepClone();
            Map<Id, Id> oldQLIDToNewQLID = new Map<Id, Id>();
            Map<Id, Id> newQLIDToOldQLID = new Map<Id, Id>();
            for(SBQQ__QuoteLine__c myQL : myQLs2){
                myQL.SBQQ__Quote__c = q2.Id;               
            }
            insert myQLs2; 
            
            Integer i = 0;
            for(SBQQ__QuoteLine__c myQL : myQLs){
                oldQLIDToNewQLID.put(myQL.Id, myQLs2[i].Id);
                newQLIDToOldQLID.put(myQLs2[i].Id, myQL.Id);
                i++;
            }       
            
            i = 0;
            for(SBQQ__QuoteLine__c myQL : myQLs2){
                myQL.SBQQ__RequiredBy__c = oldQLIDToNewQLID.get(myQL.SBQQ__RequiredBy__c);
                myQL.SBQQ__Source__c = newQLIDToOldQLID.get(myQL.Id);
                i++;
            }
            update myQLs2;
            
            SBQQ.TriggerControl.enable();
            
            if(q2.calculationToggler__c == true){
                q2.calculationToggler__c = false;
            }
            else {
                q2.calculationToggler__c = true;
            }
            
            q2.Pricing_Assumptions_Completed__c= null;
            q2.SBQQ__Status__c= '1. Formal Pricing';
            q2.ApprovalStatus__c= 'Draft';
            q2.RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName().get('Draft_Formal').getRecordTypeId();
            update q2;
        return new PageReference('/' + q2.Id);
       }
        else{
        return null;     
        }
    }
    public PageReference onCancel() {
        if (quoteId != null) {
             return new PageReference('/' + quoteId);
        }
        else{
       		 return null;     
        }
    }
    public PageReference onInitClone() {
        if (quoteId != null) {
            List<SBQQ__QuoteLine__c> myQLs = [SELECT Id, SBQQ__Number__c, Line_of_Business__c, SBQQ__ListPrice__c,SBQQ__Quantity__c,SBQQ__NetTotal__c,SBQQ__ProductCode__c,SBQQ__Quote__c,SBQQ__SegmentIndex__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c =:quoteId AND SBQQ__ProductCode__c LIKE '%CORE%' AND SBQQ__SegmentIndex__c = null]; 
            lineCount = myQLs.size();
            quoteLines = myQLs;
            return null;     
        }
        else{
       		 return null;     
        }  
    }*/
}