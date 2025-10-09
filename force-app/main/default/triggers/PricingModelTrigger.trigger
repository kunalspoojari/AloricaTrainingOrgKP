trigger PricingModelTrigger on Pricing_Model__c (before insert, before update,after update, after insert, after delete) {

Set<Id> opptyIds = new Set<Id>();
Set<Id> PMIds = new Set<Id>();
List<OpportunityLineItem> allOlis = new List<OpportunityLineItem>();

Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Lightning').getRecordTypeId();
    
    if(Trigger.isBefore){
    
        for(Pricing_Model__c pm: Trigger.new){
                         
            opptyIds.add(pm.Opportunity__c);
        }
        
        for(Opportunity opp : [select id, RecordTypeID from Opportunity where id in :opptyIds]){
        
            if(opp.RecordTypeID == devRecordTypeId){
            
                Map<ID,List<Pricing_Model__c >> PricingModels = new Map<ID,List<Pricing_Model__c >>();
                List<Pricing_Model__c > allPMs = new List<Pricing_Model__c >();
                
                If(Trigger.isInsert){
                    allPMs = [select id,Opportunity__c,Name from Pricing_Model__c where Opportunity__c in : opptyIds];
                }
                else{
                    allPMs = [select id,Opportunity__c,Name from Pricing_Model__c where Opportunity__c in : opptyIds and Id not in :Trigger.NEWMAP.keySet()];
                }
                    
                for(Pricing_Model__c pms : allPMs){
                    if(PricingModels.containsKey(pms.Opportunity__c)){
                        List<Pricing_Model__c > pricingmodelList = PricingModels.get(pms.Opportunity__c);
                        pricingmodelList.add(pms);
                        PricingModels.put(pms.Opportunity__c,pricingmodelList);
                    }
                    else{
                        PricingModels.put(pms.Opportunity__c,new list<Pricing_Model__c>{pms});
                    }
                  
                }
                
                for(Pricing_Model__c newPM :Trigger.NEW){
                        if(PricingModels.containsKey(newPM.Opportunity__c)){
                            for(Pricing_Model__c  ExistingPM : PricingModels.get(newPM.Opportunity__c)){
                                if(ExistingPM.Name == newPM.Name && newPM.Site__c != null && newPM.Service__c != null && newPM.Channel__c != null && newPM.Agent_Profile__c != null && newPM.Pricing_Round__c != null){
                                    newPM.addError('An Pricing Model with the same Site, Service, Channel, Agent Profile, and Round already exists.');
                                }
                            }
                        }
                    }
                }
            }
       }  
       if(Trigger.isAfter){
         
            for(Pricing_Model__c pm: Trigger.new){
                PMIds.add(pm.id);
            }
            
            // ----- to update Total Annualized Revenue in all Opportunity line item ------//
        
            allOlis = [select id,Name__c,Pricing_Model__c ,OpportunityId from OpportunityLineItem where Pricing_Model__c in :PMIds];
            if(allOlis.size() > 0){
            
                update allOlis;
            }
            // ----- to update Total Annualized Revenue in all Opportunity line item ------//
       }   
}