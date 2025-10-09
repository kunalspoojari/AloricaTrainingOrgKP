trigger CalculateVOCSurvey on Contact (after update) {
    
     for(Contact c1:trigger.New) {
             if(c1.VOC_Survey__c !=null && c1.VOC_Survey__c != trigger.oldMap.get(c1.Id).VOC_Survey__c){
              	Integer VOCSurveyCount = [SELECT COUNT() FROM Contact WHERE AccountId =: c1.AccountId AND VOC_Survey__c != null];
                if(VOCSurveyCount > 0){ 
                    Double countPromoters;
                    Double countDetractors;
                    
                    Double percentPromoters;
                    Double percentDetractors;
                    Double NPS;
                    List<Contact> contactList = [SELECT VOC_Survey__c FROM Contact WHERE AccountId =: c1.AccountID AND VOC_Survey__c != null];
                    List<Contact> contactPromotersList = new List<Contact>();
                    List<Contact> contactDetractorsList = new List<Contact>();
                    
                    for(Contact c: contactList){  
                        System.Debug(c.VOC_Survey__c);
                        if(c.VOC_Survey__c >= 0 && c.VOC_Survey__c <= 6){
                            System.Debug('Added to detractors');
                            contactDetractorsList.Add(c);
                        }else if(c.VOC_Survey__c >= 9 && c.VOC_Survey__c <= 10){
                            System.Debug('Added to promoter');
                            contactPromotersList.Add(c);
						}
                        
                    }
                    
                    countPromoters  = contactPromotersList.size();
                    countDetractors  = contactDetractorsList.size();
                    percentPromoters = (countPromoters / contactList.size())*100;
                    percentDetractors = (countDetractors / contactList.size())*100;
                    System.Debug('Promoters: ' + percentPromoters);
                    System.Debug('Detractors: ' + percentDetractors);
                    
                    NPS =  percentPromoters - percentDetractors;
                    System.debug('NPS: ' + NPS);
                    
                    Account a = [Select Id, VOC_Net_Promoter_Score__c FROM Account Where Id = : c1.AccountId LIMIT 1];
                    a.VOC_Net_Promoter_Score__c = NPS;
                    update a;
                    
                }  
             }
    }
}