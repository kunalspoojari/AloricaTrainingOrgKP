trigger UpdateOpportunityAmountFromOpptyProduct on Opportunitylineitem (before insert, before update,after update, after insert, after delete) { 

Set<Id> opptyIds = new Set<Id>();
Set<Id> PCIds = new Set<Id>();
Set<Id> picingCalcIds  = new Set<Id>();
Set<Id> pricingModelIds = new Set<Id>();
List<Opportunity> oppToUpdate = new List<Opportunity>();
Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Lightning').getRecordTypeId();
Opportunity opp = new Opportunity();
Boolean primaryproduct;
Double totalprice;
Double totalamount= 0;
Double CalculatedTotalPriceRevenue = 0;
Double CalculatedTotalPricePC;

        if(Trigger.isBefore){
                                
            /* Logic for adding record duplication error - Start */
            for(Opportunitylineitem op : Trigger.new){
                         
                opptyIds.add(op.OpportunityId);
            }
            
            for(Opportunity opp : [select id, RecordTypeID from Opportunity where id in :opptyIds]){
            
                if(opp.RecordTypeID == devRecordTypeId){
                
                    Map<ID,List<OpportunityLineItem>> OpportunityWiseLineItems = new Map<ID,List<OpportunityLineItem>>();
                    List<OpportunityLineItem> allOlis = new List<OpportunityLineItem>();
                    
                    If(Trigger.isInsert){
                        
                        allOlis  = [select id,Name__c,PrimaryDirectional__c,OpportunityId from OpportunityLineItem where OpportunityId in : opptyIds];
                    }
                    else{
                        allOlis  = [select id,Name__c,PrimaryDirectional__c,OpportunityId from OpportunityLineItem where OpportunityId in : opptyIds and Id not in :Trigger.NEWMAP.keySet()];
                    }
                    
                    for(OpportunityLineItem oli : allOlis){
                        if(OpportunityWiseLineItems.containsKey(oli.OpportunityId)){
                            List<OpportunityLineItem> opportunityLines = OpportunityWiseLineItems.get(oli.OpportunityId);
                            opportunityLines.add(oli);
                            OpportunityWiseLineItems.put(oli.OpportunityId,opportunityLines);
                        }
                        else{
                            OpportunityWiseLineItems.put(oli.OpportunityId,new list<OpportunityLineItem>{oli});
                        }
                    }   
                    
                    for(OpportunityLineItem oli :Trigger.NEW){
                        if(OpportunityWiseLineItems.containsKey(oli.OpportunityId)){
                            for(OpportunityLineItem ExistingOli : OpportunityWiseLineItems.get(oli.OpportunityId)){
                                system.debug('ExistingOli' + OpportunityWiseLineItems.get(oli.OpportunityId)); 
                                if(ExistingOli.Name__c == oli.Name__c && oli.Channel_s__c != null && oli.Agent_Profile__c != null && oli.Client_Preferred_Site__c != null){
                                    oli.addError('An Opportunity Product with the same Service, Channel, Agent Profile and Site already exists.');
                                }
                            }
                        }
                    }
                    /* Logic for adding record duplication error - End */
                    If(Trigger.isUpdate || Trigger.isInsert){
                        
                        for(OpportunityLineItem oli : Trigger.new){
                            oli.FTE__C = oli.Quantity;
                        
                          /* Setting "Est Annual Revenue" only when inserting line item */
        
                            if(oli.Est_Annual_Revenue__c == null){
                                oli.Est_Annual_Revenue__c= oli.unitprice * oli.Quantity;
                            }
        
                            if(OpportunityWiseLineItems.containsKey(oli.OpportunityId) && oli.Opportunity.RecordTypeID == devRecordTypeId){
                                for(OpportunityLineItem ExistingOli : OpportunityWiseLineItems.get(oli.OpportunityId)){
                                    if(oli.PrimaryDirectional__c != null && ExistingOli.PrimaryDirectional__c == oli.PrimaryDirectional__c ){
                                        oli.addError('The same Pricing Calculator cannot be associated with multiple Opportunity Products.');
                                }    
                                }
                            }
                        }    
                    
                    }
                }
            }
        }
        
        
        if(Trigger.isBefore && Trigger.isUpdate){
        
            for(Opportunitylineitem op : Trigger.new){
        
                if(op.PrimaryDirectional__c != null){
                    picingCalcIds.add(op.PrimaryDirectional__c);
                }
                if(op.Pricing_Model__c != null){
                    pricingModelIds.add(op.Pricing_Model__c);
                }
                opptyIds.add(op.OpportunityId);
            }
            
            list<opportunityLineItemSchedule> opls = new list<opportunityLineItemSchedule>([select id,Revenue from opportunitylineitemschedule where OpportunityLineItemId =: trigger.new[0].id]);    
            
            
            if(opls.size() > 0){
                
                for(opportunityLineItemSchedule oopls : opls){
                    CalculatedTotalPriceRevenue = CalculatedTotalPriceRevenue + oopls.Revenue;
                }
            }
                
            
            if(pricingModelIds.size() > 0){
                system.debug(pricingModelIds.size());
                for(Pricing_Model__c pm : [select id,Annualized_Revenue__c from Pricing_Model__c where id in :pricingModelIds]){
                
                    if(pm.Annualized_Revenue__c!= null && opls.size() == 0){
                        system.debug('if');
                        totalprice = pm.Annualized_Revenue__c;
                    }
                    
                }
            }
            
            else if(picingCalcIds.size() > 0){
                
                for(PricingCalculator__c pc : [select id,Total_Revenue__c from PricingCalculator__c  where id in :picingCalcIds]){
                
                    if(pc.Total_Revenue__c != null && opls.size() == 0){
                        system.debug('else');
                        totalprice = pc.Total_Revenue__c;
                    }
                }
            }
            
            For(OpportunityLineItem op : Trigger.new){
               
                System.debug('Test :'+totalprice);
                if(totalprice != null && op.primary_product__c == true){
                     op.totalprice = totalprice; 
                }
                
               /* Added logic when "Pricing model" and "Pricing calcutor" is not selected and we have to set "Unitprice" as "TotalPrice" */
    
                /*if(totalprice == null && op.primary_product__c == true){
                     op.totalprice = op.Est_Annual_Revenue__c;
                }
                */  
                
                //if(op.primary_product__c  == false && Trigger.OLDMAP.get(op.Id).primary_product__c != op.primary_product__c){
                if(op.primary_product__c  == false && opls.size() == 0){
                    op.totalprice = 0.00;
                }
                
               if(CalculatedTotalPriceRevenue != null){ 
                    op.Revenue_Scheduled__c = CalculatedTotalPriceRevenue;
               }
              
                // code added by Mehul Parmar as per Erik's Email on 21/08/2019 - Start
                if(op.PrimaryDirectional__c == null && op.Pricing_Model__c == null && opls.size() == 0){
                    op.totalprice = 0.00;
                }
                // code added by Mehul Parmar as per Erik's Email on 21/08/2019 - End
            }
            
        }
   
    /* While clonning Opportunity Product, setting totalprice = null - Start */
    
        if(Trigger.isBefore && Trigger.isInsert){
            For(OpportunityLineItem op : Trigger.new){
                if(op.TotalPrice!= null){
                    op.totalprice = null;
                } 
            
            }    
        } 
    
    if(Trigger.isInsert && Trigger.isAfter){
        List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
        for(OpportunityLineItem oli : [select id,name,totalPrice,PrimaryDirectional__r.Total_Revenue__c,Pricing_Model__r.Annualized_Revenue__c from OpportunityLineItem where id in:Trigger.NEWMAP.keySet()]){
            if(oli.PrimaryDirectional__c != null && oli.PrimaryDirectional__r.Total_Revenue__c != null){
                oli.TotalPrice = oli.PrimaryDirectional__r.Total_Revenue__c;
            }
            if(oli.Pricing_Model__c != null && oli.Pricing_Model__r.Annualized_Revenue__c != null){
                oli.totalPrice = oli.Pricing_Model__r.Annualized_Revenue__c;
            }
            if(oli.PrimaryDirectional__c != null || oli.Pricing_Model__c != null){
                   olis.add(oli);
            }
         
        }
        
        if(!olis.isEmpty()){
            update olis;
        }
    }
   /* While clonning Opportunity Product, setting totalprice = null - End */     
}