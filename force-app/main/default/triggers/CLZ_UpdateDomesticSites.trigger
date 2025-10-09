trigger CLZ_UpdateDomesticSites on Opportunity (before update) {
 for(Opportunity o: Trigger.new){
      o.CLZ_Domestic_Sites_Raw__c = o.Site_selected__c;
   }
}