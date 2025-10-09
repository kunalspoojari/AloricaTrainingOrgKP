@isTest //Not a test class
public class opportunityprod{
   /* @AuraEnabled
    public static list<monthWrapper> getMonthDetails(Id quoteId){
        System.debug('Received qute ID :: ' + quoteId);
        List<monthWrapper> listMonthWrapper = new List<monthWrapper>();

        try{
            //get data from parent
            List<SBQQ__QuoteLine__c> listQuoteline = [SELECT Id, SBQQ__EffectiveSubscriptionTerm__c , Calculated_Rev_per_FTE_Quantity__c, SBQQ__NetTotal__c,  Headcount__c, Target_Training_Launch_Date__c,Total_Revenue__c,
			FY20_Revenue__c,FY21_Revenue__c,First_12_Months_Revenue__c 
                                                      FROM SBQQ__QuoteLine__c
                                                      WHERE ID = :quoteId];
                                                      
                                                      
            DateTime notvaliddate;
            DateTime trainingStartDate;
            Decimal contractDuration;
            Decimal calcValue;
            DateTime expDate;
            String dateFormatString = 'MMM d, yyyy';
            List<String> monthList = new List<String>();

            if (listQuoteline.size() > 0){
                trainingStartDate = listQuoteline[0].Target_Training_Launch_Date__c;
                contractDuration = listQuoteline[0].SBQQ__EffectiveSubscriptionTerm__c ;
                calcValue = listQuoteline[0].Calculated_Rev_per_FTE_Quantity__c;

                for (Decimal i = 1; i <= contractDuration; i++){
                    expDate = trainingStartDate.AddMonths(Integer.ValueOf(i - 1)).addDays(1);//Date.newInstance(trainingStartDate.year(), trainingStartDate.month() + 1, trainingStartDate.day());
                    System.debug(expDate);
                    String expDateFinal = expDate.format(dateFormatString);
                    System.debug(expDateFinal);
                    monthList.add(expDateFinal);
                }

                
            }
            //get data from child object
            List<Revenue_Forecast__c> listRevenueForecast = [SELECT ID, Month__c, Quantity_FTE__c, Expected_Revenue__c, Comments__c
                                                             FROM Revenue_Forecast__c
                                                             WHERE Quote_Line__c = :quoteId];

            System.debug('listRevenueForecast Size :: ' + listRevenueForecast.size());
            monthWrapper mwrapper;

            Integer counter = 0;

            if (listRevenueForecast.size() > 0){
                for (Revenue_Forecast__c forcast : listRevenueForecast){
                    if (listRevenueForecast.size() > contractDuration){
                        if (counter < contractDuration){
                            mwrapper = new monthWrapper();
                            mwrapper.id = forcast.Id;
                            mwrapper.month = monthList[counter];
                            mwrapper.quantity = String.valueOf(forcast.Quantity_FTE__c);
                            if(forcast.Expected_Revenue__c!=null)
                            mwrapper.exprevenue =String.valueOf(forcast.Expected_Revenue__c.setScale(2));// String.valueOf(GetForeCastValue(forcast.Quantity_FTE__c, calcValue));
                            mwrapper.comment = String.valueOf(forcast.Comments__c);
                            listMonthWrapper.add(mwrapper);
                        }

                    } else{
                        mwrapper = new monthWrapper();
                        mwrapper.id = forcast.Id;
                        mwrapper.month = monthList[counter];
                        mwrapper.quantity = String.valueOf(forcast.Quantity_FTE__c);
                        if(forcast.Expected_Revenue__c!=null)
                        mwrapper.exprevenue = String.valueOf(forcast.Expected_Revenue__c.setScale(2));
                        mwrapper.comment = String.valueOf(forcast.Comments__c);
                        listMonthWrapper.add(mwrapper);
                    }


                    counter++;
                }
                if (listRevenueForecast.size() > 0 && listRevenueForecast.size() < contractDuration && listQuoteline[0].Headcount__c != null && calcValue != null){                    System.debug('test');
                    for (Integer i = listRevenueForecast.size(); i < contractDuration; i++){
                        System.debug('test1');
                        mwrapper = new monthWrapper();
                        mwrapper.month = monthList[i];
                        mwrapper.quantity =  string.valueof(listQuoteline[0].Headcount__c);
                        mwrapper.exprevenue = string.valueof(listQuoteline[0].Headcount__c * calcValue);
                        listMonthWrapper.add(mwrapper);
                    }
                }
            } else{
                for (String mnth : monthList){
                    mwrapper = new monthWrapper();
                    //mwrapper.id             =     1;
                    mwrapper.month = mnth;
                    mwrapper.quantity = string.valueof(listQuoteline[0].Headcount__c);
                    mwrapper.exprevenue = string.valueof(listQuoteline[0].Headcount__c * calcValue);

                    listMonthWrapper.add(mwrapper);
                }
            }

            System.debug('list to be return:: ' + listMonthWrapper);
            return listMonthWrapper;
        } catch (Exception ex){
            throw ex;
        }
    }

    @AuraEnabled
    public static void insertRevenueRecord(List<monthWrapper> revenueList, Id quoteId){
        system.debug('revenueList==' + revenueList);
        system.debug('quoteId==' + quoteId);
        List<Revenue_Forecast__c> listRevenueForecastToInsert = new List<Revenue_Forecast__c>();
        List<Revenue_Forecast__c> listRevenueForecastToUpdate = new List<Revenue_Forecast__c>();
        try{
            List<SBQQ__QuoteLine__c> listQuoteline = [SELECT Id, First_12_Months_Revenue__c,SBQQ__EffectiveSubscriptionTerm__c, SBQQ__NetTotal__c, SBQQ__EffectiveStartDate__c, SBQQ__Quote__r.SBQQ__Account__c, SBQQ__Quote__r.SBQQ__Opportunity2__c, Estimated_Go_Live_Date__c, Target_Training_Launch_Date__c
                                                      FROM SBQQ__QuoteLine__c
                                                      WHERE ID = :quoteId];
            List<Revenue_Forecast__c> listRevenueForecast = [SELECT ID, Month__c, Quantity_FTE__c, Expected_Revenue__c
                                                             FROM Revenue_Forecast__c
                                                             WHERE Quote_Line__c = :quoteId];

            if (listRevenueForecast.size() > 0){
                delete listRevenueForecast;
            }

            system.debug('listQuoteline==' + listQuoteline);
            system.debug('listRevenueForecast==' + listRevenueForecast);
            // if (false){
            //     SBQQ__QuoteLine__c ql = listQuoteline[0];
            //     Integer i = 0;
            //     for (monthWrapper mw : revenueList){
            //         Revenue_Forecast__c tempobj = new Revenue_Forecast__c();
            //         tempobj.id = mw.id;
            //         tempobj.Month_Number__c = i + 1;
            //         tempobj.Month__c = mw.month;
            //         if (ql.Target_Training_Launch_Date__c != null){
            //             tempobj.Revenue_Expected_Date__c = ql.Target_Training_Launch_Date__c.addMonths(i);
            //         } else{
            //             tempobj.Revenue_Expected_Date__c = ql.Estimated_Go_Live_Date__c.addMonths(i);
            //         }
            //         tempobj.Quote_Line__c = ql.Id;
            //         tempobj.Opportunity__c = ql.SBQQ__Quote__r.SBQQ__Opportunity2__c;
            //         tempobj.Account__c = ql.SBQQ__Quote__r.SBQQ__Account__c;
            //         system.debug('mw.quantity==' + mw.quantity);
            //         if (String.IsNotBlank(mw.quantity))
            //             tempobj.Quantity_FTE__c = decimal.valueOf(mw.quantity);
            //         if (String.IsNotBlank(mw.exprevenue))
            //             tempobj.Expected_Revenue__c = decimal.valueOf(mw.exprevenue);
            //         tempobj.Comments__c = mw.comment;
            //         listRevenueForecastToUpdate.add(tempobj);
            //         system.debug('tempobj==' + tempobj);
            //         i++;
            //     }
            //     system.debug('listRevenueForecastToUpdate==' + listRevenueForecastToUpdate);
            //     update listRevenueForecastToUpdate;
            // } else{
            SBQQ__QuoteLine__c ql = listQuoteline[0];
            Integer i = 0;
            for (monthWrapper mw : revenueList){
                Revenue_Forecast__c tempobj = new Revenue_Forecast__c();
                tempobj.Month_Number__c = i + 1;
                tempobj.Month__c = mw.month;
                if (ql.Target_Training_Launch_Date__c != null){
                    tempobj.Revenue_Expected_Date__c = ql.Target_Training_Launch_Date__c.addMonths(i);
                } else{
                    tempobj.Revenue_Expected_Date__c = ql.Estimated_Go_Live_Date__c.addMonths(i);
                }
                tempobj.Quote_Line__c = ql.Id;
                tempobj.Opportunity__c = ql.SBQQ__Quote__r.SBQQ__Opportunity2__c;
                tempobj.Account__c = ql.SBQQ__Quote__r.SBQQ__Account__c;
                system.debug('mw.quantity==' + mw.quantity);
                if (String.IsNotBlank(mw.quantity))
                    tempobj.Quantity_FTE__c = decimal.valueOf(mw.quantity);
                if (String.IsNotBlank(mw.exprevenue))
                    tempobj.Expected_Revenue__c = decimal.valueOf(mw.exprevenue);
                tempobj.Comments__c = mw.comment;
                listRevenueForecastToInsert.add(tempobj);
                system.debug('tempobj==' + tempobj);
                i++;
            }
            system.debug('listRevenueForecastToInsert==' + listRevenueForecastToInsert);
            insert listRevenueForecastToInsert;
            //}
        } catch (Exception e){
            System.debug('--->' + e);
            System.debug('LineNumber--->' + e.getLineNumber());
        }
		
    }
	@AuraEnabled
		public static void deleteQuoteLineRecords(String quoteLineId){
			List<Revenue_Forecast__c> revForecastList = [SELECT ID, Month__c, Quantity_FTE__c, Expected_Revenue__c
			FROM Revenue_Forecast__c
			WHERE Quote_Line__c =:quoteLineId];
			  delete revForecastList;
		}
        @AuraEnabled
		public static void UpdateQuoteLineRecords(String quoteId){
			List<SBQQ__QuoteLine__c> revForecastUpdate = [SELECT Id, SBQQ__EffectiveSubscriptionTerm__c , Calculated_Rev_per_FTE_Quantity__c, SBQQ__NetTotal__c,  Headcount__c, Target_Training_Launch_Date__c,Total_Revenue__c,
            FY20_Revenue__c,FY21_Revenue__c,First_12_Months_Revenue__c 
                                                      FROM SBQQ__QuoteLine__c WHERE ID = :quoteId];
			  update revForecastUpdate;

  
		}
     /*   @AuraEnabled(cacheable=true)
    public static SBQQ__QuoteLine__c trainingdt(){
        return [SELECT Id, Target_Training_Launch_Date__c FROM SBQQ__QuoteLine__c LIMIT 1];
    }*/


   /* public static Decimal GetForeCastValue(Decimal qty, Decimal calcVal){
        return qty * calcVal;
    }

    public static String getQty(){
        return '10';
    }

    public class monthWrapper{
        @AuraEnabled
        public string id{ get; set; }

        @AuraEnabled
        public string month{ get; set; }

        @AuraEnabled
        public string quantity{ get; set; }

        @AuraEnabled
        public string exprevenue{ get; set; }

        @AuraEnabled
        public string comment{ get; set; }

        @AuraEnabled
        public Integer monthNo{ get; set; }
    }*/
}