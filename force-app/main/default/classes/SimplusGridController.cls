@isTest //Not a test class
public class SimplusGridController {
   /* public static final String DEFAULT_LIST_SOURCE = 'SimplusGrid';
    public static final Integer DEFAULT_PAGE_SIZE = 200;
    private static Integer pageMax = 1;
    private static Boolean isBeyond = false;
    
    @AuraEnabled
    public static List<Revenue_Forecast__c> regenerateQuoteLineRecords(String quoteLineId){
    	deleteQuoteLineRecords(quoteLineId);
        return generateQuoteLineRecords(quoteLineId);
    }
    
    @AuraEnabled
    public static List<Revenue_Forecast__c> generateQuoteLineRecords(String quoteLineId){
        
        
        
        List <SBQQ__QuoteLine__c> quoteLineList = [SELECT SBQQ__EffectiveSubscriptionTerm__c, SBQQ__NetTotal__c, SBQQ__EffectiveStartDate__c, SBQQ__Quote__r.SBQQ__Account__c,  SBQQ__Quote__r.SBQQ__Opportunity2__c, Estimated_Go_Live_Date__c,Target_Training_Launch_Date__c   
                                                   FROM SBQQ__QuoteLine__c WHERE Id =: quoteLineId LIMIT 1];
        
        List<Revenue_Forecast__c> revForecastList = new List<Revenue_Forecast__c>();
        
        if(!quoteLineList.isEmpty()) {
            SBQQ__QuoteLine__c ql = quoteLineList[0];
            Integer counter = ql.SBQQ__EffectiveSubscriptionTerm__c.intValue();
          
            for(Integer i = 0; i < counter; i += 1) {
                Revenue_Forecast__c revForecast = new Revenue_Forecast__c();
                revForecast.Month_Number__c = i + 1;
                
                if(ql.Target_Training_Launch_Date__c!=null){
                   revForecast.Revenue_Expected_Date__c = ql.Target_Training_Launch_Date__c.addMonths(i); 
                }
                else{
                    revForecast.Revenue_Expected_Date__c = ql.Estimated_Go_Live_Date__c.addMonths(i); 
                }       
                revForecast.Expected_Revenue__c = ql.SBQQ__NetTotal__c / ql.SBQQ__EffectiveSubscriptionTerm__c;
                revForecast.Quote_Line__c = ql.Id;
                revForecast.Opportunity__c = ql.SBQQ__Quote__r.SBQQ__Opportunity2__c;
                revForecast.Account__c = ql.SBQQ__Quote__r.SBQQ__Account__c;
                revForecastList.add(revForecast);
            } 
        }
        insert revForecastList;
        return revForecastList;
    }
    
    @AuraEnabled
    public static void deleteQuoteLineRecords(String quoteLineId){
        List<Revenue_Forecast__c> revForecastList = [SELECT Id, Quote_Line__c 
                                                     FROM Revenue_Forecast__c 
                                                     WHERE Quote_Line__c =: quoteLineId];
  		delete revForecastList;
    }
    
    
    
    @AuraEnabled
    public static Map<String, FieldGridControl> getControlFields(List<String> fieldSetNames){
        Map<String, FieldGridControl> fieldAccess = new Map<String, FieldGridControl>();
        for(SimplusGridControlField__mdt gfa : [SELECT Id,FieldApi__c,MasterLabel,Editable__c,EnableMassUpdate__c,MassUpdateType__c,MultiUpdateParameters__c,SortOrder__c, MultiFieldDecision__c
                                                FROM SimplusGridControlField__mdt WHERE ListSource__c IN :fieldSetNames AND Active__c = true ORDER BY SortOrder__c]) {
                                                    fieldAccess.put(gfa.FieldApi__c, new FieldGridControl(gfa));
                                                }
        return fieldAccess;
    }
    
    
    @AuraEnabled
    public static FieldSetWrapperGroup getFieldSet(String sObjectName, String parentId, List<FieldSetConfig> fieldSets, String mainListSource){
        if(mainListSource == null || mainListSource == '') mainListSource = DEFAULT_LIST_SOURCE;
        String displayFieldSet = '';
        String filterFieldSet = '';
        List<String> fieldSetNames = new List<String>();
        system.debug('Field set configs: ' + fieldSets);
        for (FieldSetConfig config : fieldSets) {
            if (config.type == 'display') {
                displayFieldSet = config.name;
            } else if (config.type == 'filter') {
                filterFieldSet = config.name;
            }
            fieldSetNames.add(config.name);
        }
        Map<String, FieldGridControl> fieldAccess = getControlFields(fieldSetNames);
        
        //GET SCHEMA DEFINITION TO CHECK IF FIELD IS EDITABLE ON A PROFILE LEVEL
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Revenue_Forecast__c.fields.getMap();
        FieldSetWrapperGroup fieldSetWrapperClassList = new FieldSetWrapperGroup();
        
        String result = '';
        //try{
        SObjectType objToken = Schema.getGlobalDescribe().get(sObjectName);
        Schema.DescribeSObjectResult d = objToken.getDescribe();
        Map<String, Schema.FieldSet> FsMap = d.fieldSets.getMap();
        system.debug('>>>>>>> FsMap >>> ' + FsMap);
        for(String s : FsMap.keySet()) {
            System.debug(s + ' >>> ' + FsMap.get(s));
        }
        
        if(FsMap.containsKey(displayFieldSet)) {
            List<FieldSetWrapper> fieldSetWrapperClass = new List<FieldSetWrapper>();
            fieldSetWrapperClassList.sortingFieldSet = new List<FieldSetWrapper>();
            for(Schema.FieldSetMember f : FsMap.get(displayFieldSet).getFields()) {
                FieldSetWrapper fs = new FieldSetWrapper();
                fs.fieldLabel = f.getLabel();
                fs.fieldRequired = f.getDBRequired() || f.getRequired();
                fs.fieldType = string.valueOf(f.getType());
                fs.fieldName = f.getFieldPath();
                if(fieldAccess.containsKey(f.getFieldPath()) && fieldMap.containsKey(f.getFieldPath())) {
                    Boolean isUpdateable = false;
                    if(fieldMap.get(f.getFieldPath()).getDescribe().isUpdateable()) {
                        isUpdateable = fieldAccess.get(f.getFieldPath()).editable;
                    }
                    fs.fieldEditable = isUpdateable;
                } else {
                    fs.fieldEditable =  false;
                }
                fieldSetWrapperClassList.sortingFieldSet.add(fs);
            }
        }
        
        if(FsMap.containsKey(filterFieldSet)) {
            List<FieldSetWrapper> fieldSetWrapperClass = new List<FieldSetWrapper>();
            fieldSetWrapperClassList.filteringFieldSet = new List<FieldSetWrapper>();
            for(Schema.FieldSetMember f : FsMap.get(filterFieldSet).getFields()) {
                FieldSetWrapper fs = new FieldSetWrapper();
                fs.fieldLabel = f.getLabel();
                fs.fieldRequired = f.getDBRequired() || f.getRequired();
                fs.fieldType = string.valueOf(f.getType());
                fs.fieldName = f.getFieldPath();
                if(fieldAccess.containsKey(f.getFieldPath())) {
                    Boolean isUpdateable = false;
                    if(fieldMap.get(f.getFieldPath()).getDescribe().isUpdateable()) {
                        isUpdateable = fieldAccess.get(f.getFieldPath()).editable;
                    }
                    fs.fieldEditable = isUpdateable;
                } else {
                    fs.fieldEditable =  false;
                }
                fieldSetWrapperClassList.filteringFieldSet.add(fs);
            }
        }
        system.debug('List Source: ' + mainListSource);
        system.debug('List Source: ' + fieldSetWrapperClassList.sortingFieldSet);
        fieldSetWrapperClassList.sortingWrapper = querySort(sObjectName, mainListSource); //lstSortingWrapper;
        fieldSetWrapperClassList.filteringWrapper = queryFilter(sObjectName, mainListSource); //lstFilteringWrapper;
        fieldSetWrapperClassList.sortingOrderResult = dynamicQuerySort(mainListSource); // Dynamic query for Sorting
        fieldSetWrapperClassList.filteringOrderResult = dynamicQueryFilter(mainListSource); // Dynamic query for Filtering
        
        Set<String> setfieldNames = new Set<String>();
        for(FieldSetWrapper fs : fieldSetWrapperClassList.sortingFieldSet) {
            if(fs.fieldName != null) {
                setfieldNames.add(fs.fieldName);
                if(fs.fieldType == 'REFERENCE') {
                    if(fs.fieldName.indexOf('__c') == -1) {
                        setfieldNames.add(fs.fieldName.substring(0, fs.fieldName.indexOf('Id')) + '.Name');
                    } else {
                        setfieldNames.add(fs.fieldName.substring(0, fs.fieldName.indexOf('__c')) + '__r.Name');
                    }
                }
            }
        }
        
        String quotelines = '';
        //if(sObjectName == 'sbaa__Approval__c') {
        //    quotelines = getRecords('sbaa__Approval__c', JSON.serialize(setfieldNames), fieldSetWrapperClassList.sortingOrderResult, fieldSetWrapperClassList.filteringOrderResult, 1);
        //} else {
        //    quotelines = getRecords('SBQQ__QuoteLine__c', JSON.serialize(setfieldNames), fieldSetWrapperClassList.sortingOrderResult, fieldSetWrapperClassList.filteringOrderResult, 1);
        //}
        quotelines = getRecords(sObjectName, parentId, JSON.serialize(setfieldNames), fieldSetWrapperClassList.sortingOrderResult, fieldSetWrapperClassList.filteringOrderResult, 1);
        List<sObject> lstSobject = (List<sObject>) JSON.deserialize(quotelines, List<sObject>.class);
        fieldSetWrapperClassList.lstObject = lstSobject;
        fieldSetWrapperClassList.pageMax = pageMax;
        fieldSetWrapperClassList.isBeyond = isBeyond;
        //}
        //catch(Exception e){
        //result += e.getLineNumber() + ' : ' + e.getMessage();
        //}
        return fieldSetWrapperClassList;
    }
    @AuraEnabled
    public static List<SortColumWrapper> querySort(String sObjectName, String mainListSource){
        if(mainListSource == null || mainListSource == '') mainListSource = DEFAULT_LIST_SOURCE;
        List<SortColumWrapper> lstSortingWrapper = new List<SortColumWrapper>();
        List<SimplusGrid_Sorting__c> lstSortingRec = new List<SimplusGrid_Sorting__c>();
        
        system.debug('querySort ELSE ');
        lstSortingRec = [SELECT Id, Global__c, Column__c, Column_Name__c, Order__c, Priority__c, OwnerId, Active__c
                         FROM SimplusGrid_Sorting__c
                         WHERE (OwnerId =: userInfo.getUserId() OR Global__c = true)
                         AND List_Source__c = :mainListSource
                         ORDER BY Global__c DESC, Priority__c];
        
        
        for(SimplusGrid_Sorting__c sortingList : lstSortingRec) {
            SortColumWrapper wrapperSort = new SortColumWrapper();
            wrapperSort.id = sortingList.id;
            wrapperSort.sortUser = sortingList.OwnerId;
            wrapperSort.sortColumn = sortingList.Column__c;
            wrapperSort.sortColumnName = sortingList.Column_Name__c;
            wrapperSort.sortOrder = sortingList.Order__c;
            wrapperSort.sortPriority = integer.valueOf(sortingList.Priority__c);
            wrapperSort.isActive = sortingList.Active__c;
            wrapperSort.isGlobal = sortingList.Global__c;
            lstSortingWrapper.add(wrapperSort);
        }     
        return lstSortingWrapper;                                             
    }
    
    @AuraEnabled
    public static List<FilterColumWrapper> queryFilter(String sObjectName, String mainListSource){
        if(mainListSource == null || mainListSource == '') mainListSource = DEFAULT_LIST_SOURCE;
        List<FilterColumWrapper> lstFilteringWrapper = new List<FilterColumWrapper>();
        List<SimplusGrid_Filtering__c> lstFilteringRec = new List<SimplusGrid_Filtering__c>();
        
        lstFilteringRec = [SELECT Id, Column__c, Column_Name__c, Operation__c, Value__c, Priority__c, OwnerId, Active__c, Global__c
                           FROM SimplusGrid_Filtering__c
                           WHERE (OwnerId =: userInfo.getUserId() OR Global__c = true)
                           AND List_Source__c = :mainListSource
                           ORDER BY Global__c DESC, Priority__c];
        
        
        
        for(SimplusGrid_Filtering__c filteringList : lstFilteringRec) {
            FilterColumWrapper wrapperFilter = new FilterColumWrapper();
            wrapperFilter.id = filteringList.id;
            wrapperFilter.filterUser = filteringList.OwnerId;
            wrapperFilter.filterColumn = filteringList.Column__c;
            wrapperFilter.filterColumnName = filteringList.Column_Name__c;
            wrapperFilter.filterOperation = filteringList.Operation__c;
            wrapperFilter.filterValue = filteringList.Value__c;
            wrapperFilter.filterPriority = integer.valueOf(filteringList.Priority__c);
            wrapperFilter.isActive = filteringList.Active__c;
            wrapperFilter.isGlobal = filteringList.Global__c;
            lstFilteringWrapper.add(wrapperFilter); 
        }
        return lstFilteringWrapper;
    }
    
    
    @AuraEnabled
    public static FieldSetWrapperGroup toggle(String sObjectName, String parentId, String mainListSource, Integer page){
        if(page == null) page = 1;
        if(mainListSource == null || mainListSource == '') mainListSource = DEFAULT_LIST_SOURCE;
        List<FieldSetConfig> lstFieldSetConfig = new List<FieldSetConfig>();
        FieldSetConfig fieldSetConfig = new FieldSetConfig();
        fieldSetConfig.name = 'SimplusGrid';
        fieldSetConfig.type = 'display';
        lstFieldSetConfig.add(fieldSetConfig);
        
        fieldSetConfig = new FieldSetConfig();
        fieldSetConfig.name = 'SimplusGrid_Filter';
        fieldSetConfig.type = 'filter';
        lstFieldSetConfig.add(fieldSetConfig);
        
        
        FieldSetWrapperGroup filterGroup = new FieldSetWrapperGroup();
        filterGroup = getFieldSet(sObjectName, parentId, lstFieldSetConfig, mainListSource);
        
        
        List<FieldSetWrapper> lstFieldSet = new List<FieldSetWrapper>();
        lstFieldSet = filterGroup.sortingFieldSet;
        
        Set<String> setfieldNames = new Set<String>();
        for(FieldSetWrapper fs:lstFieldSet) {
            if(fs.fieldName != null) {
                setfieldNames.add(fs.fieldName);
                if(fs.fieldType == 'REFERENCE') {
                    if(fs.fieldName.indexOf('__c') == -1) {
                        setfieldNames.add(fs.fieldName.substring(0, fs.fieldName.indexOf('Id')) + '.Name');
                    } else {
                        setfieldNames.add(fs.fieldName.substring(0, fs.fieldName.indexOf('__c')) + '__r.Name');
                    }
                }
            }
        }
        
        system.debug('toggleSort >> ' + JSON.serialize(setfieldNames));
        String quotelines = '';
        
        quotelines = getRecords(sObjectName, parentId, JSON.serialize(setfieldNames), filterGroup.sortingOrderResult, filterGroup.filteringOrderResult, page);
        
        
        List<sObject> lstSobject = (List<sObject>) JSON.deserialize(quotelines, List<sObject>.class);
        System.debug('LIST SOBJECT ' + lstSobject);
        filterGroup.lstObject = lstSobject;
        filterGroup.pageMax = pageMax;
        filterGroup.isBeyond = isBeyond;
        return filterGroup;                                             
    }
    
    @AuraEnabled
    public static String dynamicQuerySort(String mainListSource){
        if(mainListSource == null || mainListSource == '') mainListSource = DEFAULT_LIST_SOURCE;
        List<SimplusGrid_Sorting__c> lstSortingRec = [SELECT Id, Column__c, Column_Name__c, Order__c, Priority__c, OwnerId, Active__c
                                                      FROM SimplusGrid_Sorting__c
                                                      WHERE (OwnerId =: userInfo.getUserId() OR Global__c = true)
                                                      AND List_Source__c = :mainListSource
                                                      ORDER BY Priority__c];
        system.debug('SORT query >> ' + lstSortingRec);
        String sortingQuery = '';
        Integer sortingCount = 0;
        for(SimplusGrid_Sorting__c sortingList : lstSortingRec) {
            if(sortingList.Active__c) {
                sortingCount++;
                if(sortingCount > 1) {
                    sortingQuery += ', ';
                } else if(sortingCount == 1) {
                    sortingQuery += ' ORDER BY ';
                }
                sortingQuery += sortingList.Column__c + ' ' + sortingList.Order__c;
            }
        }
        system.debug('SORT >> ' + sortingQuery);
        return sortingQuery;
    }
    
    @AuraEnabled
    public static String dynamicQueryFilter(String mainListSource){
        if(mainListSource == null || mainListSource == '') mainListSource = DEFAULT_LIST_SOURCE;
        
        List<SimplusGrid_Filtering__c> lstFilteringRec = [SELECT Id, Column__c, Column_Name__c, Column_Type__c, Operation__c, Value__c, Priority__c, OwnerId, Active__c, Global__c
                                                          FROM SimplusGrid_Filtering__c
                                                          WHERE (OwnerId =: userInfo.getUserId() OR Global__c = true)
                                                          AND List_Source__c = :mainListSource];
        
        String filteringQuery = '';
        Integer filterCounter = 0;
        for(SimplusGrid_Filtering__c filteringList : lstFilteringRec) {
            if(filteringList.Active__c) {
                filterCounter++;
                if(filterCounter > 1) {
                    filteringQuery += 'AND';
                } else if(filterCounter == 1) {
                    filteringQuery += ' WHERE';
                }
                
                String filterUsed = '';
                
                //Date formatting for SOQL use.  Use dateTimeValue.formatGMT with format string as comparison.
                String dateValStr;
                Date dateValue;
                Datetime dateTimeValue;
                
                /////////////////////sdhjfdsfsdjhfsdfsdfds
                if(filteringList.Column_Type__c == 'DATE') {
                    dateValue = Date.valueOf(filteringList.Value__c);
                    dateValStr = (Date.valueOf(filteringList.Value__c) + '').split(' ')[0];
                    dateTimeValue = DateTime.newInstance(dateValue, Time.newInstance(0, 0, 0, 0));
                } else if (filteringList.Column_Type__c == 'DATETIME') {
                    dateTimeValue = Datetime.valueOf(filteringList.Value__c);
                }
                
                if(filteringList.Operation__c == 'starts with') {
                    filterUsed = 'LIKE' + ' \'' + filteringList.Value__c + '%\' ';
                } else if(filteringList.Operation__c == 'ends with') {
                    filterUsed = 'LIKE' + ' \'%' + filteringList.Value__c + '\' ';
                } else if(filteringList.Operation__c == 'contains') {
                    filterUsed = 'LIKE' + ' \'%' + filteringList.Value__c + '%\' ';
                } else if(filteringList.Operation__c == 'equals') {
                    filterUsed = '=' + ' \'' + filteringList.Value__c + '\' ';
                } else if(filteringList.Operation__c == 'not equals') {
                    filterUsed = '!=' + ' \'' + filteringList.Value__c + '\' ';
                } else if(filteringList.Operation__c == 'is null') {
                    filterUsed = '= null ';
                } else if(filteringList.Operation__c == 'not null') {
                    filterUsed = '!= null ';
                } else if(filteringList.Operation__c == 'eq') {
                    filterUsed = '= ' + filteringList.Value__c + ' ';
                } else if(filteringList.Operation__c == 'lt') {
                    filterUsed = '< ' + filteringList.Value__c + ' ';
                } else if(filteringList.Operation__c == 'gt') {
                    filterUsed = '> ' + filteringList.Value__c + ' ';
                    
                } else if(filteringList.Column_Type__c == 'DATE' && filteringList.Operation__c == 'equal') {
                    filterUsed = '= ' + dateValStr;//.formatGMT('yyyy-MM-dd') + ' ';
                } else if(filteringList.Column_Type__c == 'DATETIME' && filteringList.Operation__c == 'equal') {
                    filterUsed = '= ' + dateTimeValue.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') + ' ';
                    
                } else if(filteringList.Column_Type__c == 'DATE' && filteringList.Operation__c == 'before') {
                    filterUsed = '< ' + dateValStr;//.formatGMT('yyyy-MM-dd') + ' ';
                } else if(filteringList.Column_Type__c == 'DATETIME' && filteringList.Operation__c == 'before') {
                    filterUsed = '< ' + dateTimeValue.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') + ' ';
                    
                } else if(filteringList.Column_Type__c == 'DATE' && filteringList.Operation__c == 'after') {
                    filterUsed = '> ' + dateValStr;//.formatGMT('yyyy-MM-dd') + ' ';
                } else if(filteringList.Column_Type__c == 'DATETIME' && filteringList.Operation__c == 'after') {
                    filterUsed = '> ' + dateTimeValue.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') + ' ';
                }
                
                filteringQuery += ' ' + filteringList.Column__c + ' ' + filterUsed;
            }
        }
        system.debug('FILTER >> ' + filteringQuery);
        return filteringQuery;
    }
    
    @AuraEnabled 
    public static FieldSetWrapperGroup deleteSortFilterItem(String sObjectName, String parentId, String type, Id id, Integer page) {
        String listSrc;
        if(type == 'sort') {
            SimplusGrid_Sorting__c sortItem = [SELECT Id, List_Source__c FROM SimplusGrid_Sorting__c WHERE Id = :id LIMIT 1];
            listSrc = sortItem.List_Source__c;
            delete new SimplusGrid_Sorting__c(Id = id);
        } else if(type == 'filter') {
            SimplusGrid_Filtering__c filterItem = [SELECT Id, List_Source__c FROM SimplusGrid_Filtering__c WHERE Id = :id LIMIT 1];
            listSrc = filterItem.List_Source__c;
            delete new SimplusGrid_Filtering__c(Id = id);
        }
        return toggle(sObjectName, parentId, listSrc, page);
    }
    
    @AuraEnabled 
    public static FieldSetWrapperGroup toggleSortFilterItem(String sObjectName, String parentId, String type, Id id, Boolean currentState, Integer page) {
        String listSrc;
        if(type == 'sort') {
            SimplusGrid_Sorting__c sortItem = [SELECT Id, List_Source__c FROM SimplusGrid_Sorting__c WHERE Id = :id LIMIT 1];
            listSrc = sortItem.List_Source__c;
            update new SimplusGrid_Sorting__c(Id = id, Active__c = !currentState);
        } else if(type == 'filter') {
            SimplusGrid_Filtering__c filterItem = [SELECT Id, List_Source__c FROM SimplusGrid_Filtering__c WHERE Id = :id LIMIT 1];
            listSrc = filterItem.List_Source__c;
            update new SimplusGrid_Filtering__c(Id = id, Active__c = !currentState);
        }
        return toggle(sObjectName, parentId, listSrc, page);
    }
    
    @AuraEnabled
    public static FieldSetWrapperGroup deleteAllSortFilterItem(String type, String wrapperList) {
        List<SortColumWrapper> lstSortWrapper = new List<SortColumWrapper>();
        List<FilterColumWrapper> lstFilterWrapper = new List<FilterColumWrapper>();
        List<SimplusGrid_Sorting__c> lstSorting = new List<SimplusGrid_Sorting__c>();
        List<SimplusGrid_Filtering__c> lstFiltering = new List<SimplusGrid_Filtering__c>();
        FieldSetWrapperGroup filterGroup = new FieldSetWrapperGroup();
        
        if(type == 'sort') {
            lstSortWrapper = (List<SortColumWrapper>)JSON.deserialize(wrapperList, List<SortColumWrapper>.class);
        } else if(type == 'filter') {
            lstFilterWrapper = (List<FilterColumWrapper>)JSON.deserialize(wrapperList, List<FilterColumWrapper>.class);
        }
        
        if(type == 'sort') {
            if(lstSortWrapper != null) {
                for(SortColumWrapper sortWrapper : lstSortWrapper) {
                    SimplusGrid_Sorting__c newSorting = new SimplusGrid_Sorting__c(Id = sortWrapper.id);
                    lstSorting.add(newSorting);
                }
                delete lstSorting;
                filterGroup.sortingWrapper = new List<SortColumWrapper>();
            }
            
        } else if(type == 'filter') {
            if(lstFilterWrapper != null) {
                for(FilterColumWrapper filterWrapper : lstFilterWrapper) {
                    if(!filterWrapper.isGlobal) {
                        SimplusGrid_Filtering__c newFiltering = new SimplusGrid_Filtering__c(Id = filterWrapper.id);
                        lstFiltering.add(newFiltering);
                    }
                }
                delete lstFiltering;
                filterGroup.filteringWrapper = new List<FilterColumWrapper>();
            }
        }
        return filterGroup;
    }
    
    @AuraEnabled
    public static FieldSetWrapperGroup dragAndDrop(String type, String wrapperList) {
        List<SortColumWrapper> lstSortWrapper = new List<SortColumWrapper>();
        List<FilterColumWrapper> lstFilterWrapper = new List<FilterColumWrapper>();
        List<SimplusGrid_Sorting__c> lstSorting = new List<SimplusGrid_Sorting__c>();
        List<SimplusGrid_Filtering__c> lstFiltering = new List<SimplusGrid_Filtering__c>();
        FieldSetWrapperGroup filterGroup = new FieldSetWrapperGroup();
        if(type == 'sort') {
            lstSortWrapper = (List<SortColumWrapper>)JSON.deserialize(wrapperList, List<SortColumWrapper>.class);
        } else if(type == 'filter') {
            lstFilterWrapper = (List<FilterColumWrapper>)JSON.deserialize(wrapperList, List<FilterColumWrapper>.class);
        }
        
        Integer counter = 0;
        if(type == 'sort') {
            
            for(SortColumWrapper sortWrapper : lstSortWrapper) {
                counter++;
                sortWrapper.sortPriority = counter;
                SimplusGrid_Sorting__c newSorting = new SimplusGrid_Sorting__c(Id = sortWrapper.id, Priority__c = counter);
                lstSorting.add(newSorting);
            }
            update lstSorting;
            filterGroup.sortingWrapper = lstSortWrapper;
            
        } else if(type == 'filter') {
            
            for(FilterColumWrapper filterWrapper : lstFilterWrapper) {
                counter++;
                filterWrapper.filterPriority = counter;
                SimplusGrid_Filtering__c newFiltering = new SimplusGrid_Filtering__c(Id = filterWrapper.id, Priority__c = counter);
                lstFiltering.add(newFiltering);
            }
            update lstFiltering;
            filterGroup.filteringWrapper = lstFilterWrapper;
        }
        return filterGroup;
    }
    
    @AuraEnabled
    public static String getRecords(String sObjectName, String parentId, String fieldNameJson, String sortingOrderResult, String filteringOrderResult, Integer page){
        
        List<sObject> lstResult = new List<sObject>();
        String result = '[]';
        //try{
        List<String> fieldNames = (List<String>) JSON.deserialize(fieldNameJson, List<String>.class);
        
        
        Set<String> setFieldNames = new Set<String>();
        String query = 'SELECT ' + String.join(fieldNames, ',') + ' FROM ' + sObjectName;
        String queryCount = 'SELECT COUNT(Id) cnt FROM ' + sObjectName;
        String currentUser = userInfo.getUserId();
        
        if(filteringOrderResult != '' && filteringOrderResult != null){
            query += ' ' + filteringOrderResult;
            queryCount += ' ' + filteringOrderResult;
        }
        
        if(parentId != null) {
            query += ((filteringOrderResult != '' && filteringOrderResult != null) ? ' AND ' : ' WHERE ') + ' Quote_Line__c = \'' + parentId + '\'';
            queryCount += ((filteringOrderResult != '' && filteringOrderResult != null) ? ' AND ' : ' WHERE ') + ' Quote_Line__c = \'' + parentId + '\'';
        }
        if (sortingOrderResult != '' && sortingOrderResult != null){
            query += ' ' + sortingOrderResult;
        }  else {
            query += ' ORDER BY CreatedDate DESC';
        }
        
        query += ' LIMIT ' + DEFAULT_PAGE_SIZE;
        query += ' OFFSET ' + ((page - 1) * DEFAULT_PAGE_SIZE);
        
        system.debug('>>>>>>> query >>> ' + query);
        
        AggregateResult ag = Database.query(queryCount);
        
        Integer recordCnt = Integer.valueOf(ag.get('cnt'));
        System.debug('COUNT: ' + ag);
        pageMax = recordCnt / DEFAULT_PAGE_SIZE;
        if(Math.mod(recordCnt,DEFAULT_PAGE_SIZE) > 0) pageMax +=1;
        
        if(pageMax > 40) {
            isBeyond = true;
            pageMax = 40;
        } else if(pageMax == 0) {
            pageMax = 1;
        }
        
        for(sObject s : Database.query(query)){
            lstResult.add(s);
        }
        if(lstResult.size() > 0) {
            result = JSON.serialize(lstResult);
        }
        //} catch(Exception e){
        //system.debug('Error: >> ' + e.getLineNumber() + ' : ' + e.getMessage());
        //return '[]';
        //}
        system.debug('RESULT >> ' + result);
        return result;
    }
    
    @AuraEnabled
    public static String saveRecords(String saveList){
        System.debug(saveList);
        List<sObject> sobjSaveList = (List<sObject>) JSON.deserialize(saveList, List<sObject>.class);
        
        try {
            update sobjSaveList;
        } catch(Exception e) {
            return e.getMessage();
        }
        
        return '';
    }
    
    @AuraEnabled
    public static string updateGridRecord(SObject s){
        String retMsg = '';
        try {
            update s;
        } catch(Exception e) {
            retMsg = e.getMessage();
        }
        return retMsg;
    }
    
    @AuraEnabled 
    public static user fetchUser(){
        User u = [SELECT Id, Name FROM User WHERE id =: userInfo.getUserId()];
        return u;
    }
    
    @AuraEnabled
    public static FieldSetWrapperGroup sortColumns(String objWrapper, String objWrapperList, String mainListSource){
        if(mainListSource == null || mainListSource == '') mainListSource = DEFAULT_LIST_SOURCE;
        List<SortColumWrapper> lstSortWrapper = (List<SortColumWrapper>)JSON.deserialize(objWrapperList, List<SortColumWrapper>.class);
        SortColumWrapper sortWrapper = (SortColumWrapper)JSON.deserialize(objWrapper, SortColumWrapper.class);
        system.debug('sortWrapper >> ' + sortWrapper);
        
        SimplusGrid_Sorting__c newSortingRec = new SimplusGrid_Sorting__c();
        newSortingRec.OwnerId = sortWrapper.sortUser;
        newSortingRec.Column__c = sortWrapper.sortColumn;
        newSortingRec.Column_Name__c = sortWrapper.sortColumnName;
        newSortingRec.Order__c = sortWrapper.sortOrder;
        newSortingRec.Priority__c = lstSortWrapper.size() + 1;
        newSortingRec.Active__c = true;
        newSortingRec.List_Source__c = mainListSource;
        insert newSortingRec;
        sortWrapper.id = newSortingRec.Id;
        lstSortWrapper.add(sortWrapper);
        for(SortColumWrapper wrapper : lstSortWrapper) {
            wrapper.sortCurrentOrder = sortWrapper.sortOrder;
        }
        lstSortWrapper.sort();
        
        FieldSetWrapperGroup sortGroup = new FieldSetWrapperGroup();
        sortGroup.sortingWrapper = lstSortWrapper;
        sortGroup.sortingOrderResult = dynamicQuerySort(mainListSource);
        return sortGroup;
    }
    
    @AuraEnabled
    public static FieldSetWrapperGroup filterColumns(String objWrapper, String objWrapperList, String mainListSource){
        if(mainListSource == null || mainListSource == '') mainListSource = DEFAULT_LIST_SOURCE;
        List<FilterColumWrapper> lstFilterWrapper = (List<FilterColumWrapper>)JSON.deserialize(objWrapperList, List<FilterColumWrapper>.class);
        FilterColumWrapper filterWrapper = (FilterColumWrapper)JSON.deserialize(objWrapper, FilterColumWrapper.class);
        system.debug('filterWrapper >> ' + JSON.serialize(filterWrapper));
        
        SimplusGrid_Filtering__c newFilteringRec = new SimplusGrid_Filtering__c();
        newFilteringRec.OwnerId = filterWrapper.filterUser;
        newFilteringRec.Column__c = filterWrapper.filterColumn;
        newFilteringRec.Column_Name__c = filterWrapper.filterColumnName;
        newFilteringRec.Column_Type__c = filterWrapper.filterColumnType;
        newFilteringRec.Operation__c = filterWrapper.filterOperation;
        newFilteringRec.Value__c = filterWrapper.filterValue;
        newFilteringRec.Priority__c = lstFilterWrapper.size() + 1;
        newFilteringRec.Active__c = true;
        newFilteringRec.List_Source__c = mainListSource;
        insert newFilteringRec;
        system.debug('INSERT >> ' + JSON.serialize(newFilteringRec));
        filterWrapper.id = newFilteringRec.Id;
        lstFilterWrapper.add(filterWrapper);
        
        FieldSetWrapperGroup filterGroup = new FieldSetWrapperGroup();
        filterGroup.filteringWrapper = lstFilterWrapper;
        filterGroup.filteringOrderResult = dynamicQueryFilter(mainListSource);
        return filterGroup;
    }
    
    public class FieldGridControl {
        @AuraEnabled public String name;
        @AuraEnabled public String label;
        @AuraEnabled public Boolean editable;
        @AuraEnabled public Boolean enableMassUpdate;
        @AuraEnabled public String massUpdateType;
        @AuraEnabled public String massUpdateParams;
        @AuraEnabled public String multiDecision;
        @AuraEnabled public Decimal sortOrder;
        
        public FieldGridControl(SimplusGridControlField__mdt control) {
            this.name = control.FieldApi__c;
            this.label = control.MasterLabel;
            this.editable = control.Editable__c;
            this.enableMassUpdate = control.EnableMassUpdate__c;
            this.massUpdateType = control.MassUpdateType__c;
            this.massUpdateParams = control.MultiUpdateParameters__c;
            this.sortOrder = control.SortOrder__c;
            this.multiDecision = control.MultiFieldDecision__c;
        }
    }
    
    public class FieldSetConfig {
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String type {get;set;}
    }
    
    public class FieldSetWrapper {
        @AuraEnabled public String fieldLabel {get;set;}
        @AuraEnabled public Boolean fieldRequired {get;set;}
        @AuraEnabled public String fieldType {get;set;}
        @AuraEnabled public String fieldName {get;set;}
        @AuraEnabled public Boolean fieldEditable {get;set;}
    }
    
    public class FieldSetWrapperGroup {
        @AuraEnabled public List<FieldSetWrapper> sortingFieldSet {get;set;}
        @AuraEnabled public List<FieldSetWrapper> filteringFieldSet {get;set;}
        @AuraEnabled public List<SortColumWrapper> sortingWrapper {get;set;}
        @AuraEnabled public List<FilterColumWrapper> filteringWrapper {get;set;}
        @AuraEnabled public String sortingOrderResult {get;set;}
        @AuraEnabled public String filteringOrderResult {get;set;}
        @AuraEnabled public List<sObject> lstObject {get;set;}
        @AuraEnabled public Integer pageMax {get;set;}
        @AuraEnabled public Boolean isBeyond = false;
    }
    
    public class SortColumWrapper implements Comparable {
        @AuraEnabled public String id {get;set;}
        @AuraEnabled public String sortUser {get;set;}
        @AuraEnabled public String sortColumn {get;set;}
        @AuraEnabled public String sortColumnName {get;set;}
        @AuraEnabled public String sortOrder {get;set;}
        @AuraEnabled public Integer sortPriority {get;set;}
        @AuraEnabled public String sortCurrentOrder {get;set;}
        @AuraEnabled public Boolean isActive {get;set;}
        @AuraEnabled public Boolean isGlobal {get;set;}
        
        public Integer compareTo(Object compareTo) {
            SortColumWrapper compareColumn = (SortColumWrapper)compareTo;
            if(sortCurrentOrder == 'ASC') {
                if(sortPriority == compareColumn.sortPriority) return 0;
                if(sortPriority < compareColumn.sortPriority) return -1;
                return 1;   
            } else {
                if(sortPriority == compareColumn.sortPriority) return 0;
                if(sortPriority < compareColumn.sortPriority) return 1;
                return -1;   
            }
        }
    }
    
    public class FilterColumWrapper {
        @AuraEnabled public String id {get;set;}
        @AuraEnabled public String filterUser {get;set;}
        @AuraEnabled public String filterColumn {get;set;}
        @AuraEnabled public String filterColumnName {get;set;}
        @AuraEnabled public String filterColumnType {get;set;}
        @AuraEnabled public String filterOperation {get;set;}
        @AuraEnabled public String filterValue {get;set;}
        @AuraEnabled public Integer filterPriority {get;set;}
        @AuraEnabled public Boolean isActive {get;set;}
        @AuraEnabled public Boolean isGlobal {get;set;}
    }
    
    
    @AuraEnabled   
    public static string getmydomain(){   
        String urlInstance = String.valueof(System.URL.getSalesforceBaseURL().gethost());
        String s2 = urlInstance.removeEndIgnoreCase('.my.salesforce.com');
        return s2;
    }

	@AuraEnabled
    public static Boolean getRecState(String quoteLineId) {
        List<Revenue_Forecast__c> refore = [SELECT Id FROM Revenue_Forecast__c WHERE Quote_Line__c = :quoteLineid];
        return !refore.isEmpty();
    }*/
    
}