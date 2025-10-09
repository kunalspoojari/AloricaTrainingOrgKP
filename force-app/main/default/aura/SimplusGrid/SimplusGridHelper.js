({
    init : function(component, event, helper) {
        helper.getUserDetails(component, event, helper);
        helper.getTableFieldSet(component, event, helper);
        
        window.addEventListener('resize', $A.getCallback(function(){ 
            helper.handleWindowScroll(component, event, helper); 
            helper.handleDimensionsUpdate(component, event, helper); 
        }));
        window.addEventListener('scroll', $A.getCallback(function(){ 
            helper.handleWindowScroll(component, event, helper); 
        }));
    },
    
    getTableFieldSet : function(component, event, helper) {
        component.set("v.isLoadingList", true);
        var action = component.get("c.getFieldSet");
        action.setParams({
            sObjectName: component.get("v.sObjectName"),
            parentId : component.get("v.recordId"),
            fieldSets: component.get("v.fieldSets")
        });
        console.log("fieldSets >> grid", component.get("v.fieldSets"));
        action.setCallback(this, function(response) {
            console.log('RESPONSE >> ', response.getReturnValue());
            //var fieldSetObj = JSON.parse(response.getReturnValue());
            var fieldSetObj = response.getReturnValue();
            console.log('FIELDSET >> ', fieldSetObj);
            var colFreeze = component.get("v.noOfColumns");
            var leftCols = [], rightCols = [], allCols = [];
            
            if(fieldSetObj.sortingFieldSet) {
                /*for(var i =0; i < colFreeze; i+=1) {
                    if(fieldSetObj.sortingFieldSet[i]) {
                        leftCols.push(fieldSetObj.sortingFieldSet[i]);
                        allCols.push(fieldSetObj.sortingFieldSet[i]);
                    }
                }*/
                console.log(3);
                for(var i = 0/*colFreeze*/; i < fieldSetObj.sortingFieldSet.length; i+=1) {
                    if(fieldSetObj.sortingFieldSet[i]) {
                        rightCols.push(fieldSetObj.sortingFieldSet[i]);
                        allCols.push(fieldSetObj.sortingFieldSet[i]);
                    }
                }
            }
            
            console.log(4, leftCols, allCols);
            component.set("v.fieldSetValues", allCols);
            component.set("v.fieldSetValues1", leftCols);
            component.set("v.fieldSetValues2", rightCols);
            component.set("v.pageMax", fieldSetObj.pageMax);
            component.set("v.isBeyond", fieldSetObj.isBeyond);
            
            console.log(5);
            component.set("v.sortingOrderResult", fieldSetObj.sortingOrderResult);
            component.set("v.filteringOrderResult", fieldSetObj.filteringOrderResult);
            //Call helper method to fetch the records
            //helper.getTableRows(component, event, helper);
            //
            try {
                console.log(fieldSetObj.lstObject);
                var list = fieldSetObj.lstObject;
            } catch (ex) {
                console.log('Error caught: ' + ex);
                return;
            }
            console.log('LIST >> ', list);
            component.set("v.tableRecords", list);
            component.set("v.tableRecordsUpdated", list);
            component.set("v.hasPendingMassChange", false);
            component.set("v.isLoadingList", false);
            
            window.setTimeout(
                $A.getCallback(function() {
                    helper.handleDimensionsUpdate(component, event, helper);
                }), 100
            );
        })
        $A.enqueueAction(action);
    },
    
    getTableRows : function(component, event, helper){
        component.set("v.isLoadingList", true);
        var action = component.get("c.getRecords");
        var fieldSetValues = component.get("v.fieldSetValues");
        
        var setfieldNames = new Set();
        for(var c=0, clang = fieldSetValues.length; c<clang; c++){             
            if(!setfieldNames.has(fieldSetValues[c].fieldName)) {                 
                setfieldNames.add(fieldSetValues[c].fieldName);                   
                if(fieldSetValues[c].fieldType == 'REFERENCE') {                     
                    if(fieldSetValues[c].fieldName.indexOf('__c') == -1) {                     	
                        setfieldNames.add(fieldSetValues[c].fieldName.substring(0, fieldSetValues[c].fieldName.indexOf('Id')) + '.Name');                          
                    }                     
                    else {                     	
                        setfieldNames.add(fieldSetValues[c].fieldName.substring(0, fieldSetValues[c].fieldName.indexOf('__c')) + '__r.Name');                              
                    }                 
                }             
            }         
        }  
        
        var arrfieldNames = [];         
        
        setfieldNames.forEach(v => arrfieldNames.push(v));
        action.setParams({
            sObjectName: component.get("v.sObjectName"),
            parentId : component.get("v.recordId"),
            fieldNameJson: JSON.stringify(arrfieldNames),
            sortingOrderResult: component.get("v.sortingOrderResult"),
            filteringOrderResult: component.get("v.filteringOrderResult"),
            page : component.get("v.page")
        });
        action.setCallback(this, function(response) {
            try {
                var list = JSON.parse(response.getReturnValue());
            } catch (ex) {
                console.log('Error caught: ' + ex);
                return;
            }
            console.log('LIST >> ', list);
            component.set("v.tableRecords", list);
            component.set("v.tableRecordsUpdated", list);
            component.set("v.hasPendingMassChange", false);
            component.set("v.isLoadingList", false);
            
            window.setTimeout(
                $A.getCallback(function() {
                    helper.handleDimensionsUpdate(component, event, helper);
                }), 50
            );
            
        })
        $A.enqueueAction(action);
    },
    
    refreshList : function(component, event, helper) {
        var getSort = component.get("c.toggle");
        getSort.setParams({
            sObjectName: component.get("v.sObjectName"),
            parentId : component.get("v.recordId"),
            mainListSource : component.get("v.mainListSource"),
            page : 1
        });
        getSort.setCallback(this, function(a) {
            var returnValue = a.getReturnValue();
            console.log("refresh From refList");
            component.set("v.tableRecords");
            component.set("v.tableRecords", returnValue.lstObject);
            component.set("v.pageMax", returnValue.pageMax);
            component.set("v.isBeyond", returnValue.isBeyond);
            component.set("v.hasPendingMassChange", false);
            component.set("v.isLoadingList", false);
        });
        $A.enqueueAction(getSort);
    },
    
    handleDimensionsUpdate : function(component, event, helper) {
        try {
            
            var leftFloaterWidth = document.getElementById("grid_fixedColumns").getBoundingClientRect().width,
                leftColumns = document.getElementsByClassName("grid_leftTh"),
                leftColsFloat = document.getElementsByClassName("grid_leftThFloat"),
                
                rightColumn = document.getElementsByClassName("grid_rightColumn"),
                rightColumnFloat = document.getElementsByClassName("grid_rightColumnFloat"),
                
                grid_fixedColumnsTableFloating = document.getElementById("grid_fixedColumnsTableFloating"),
                grid_rightTableFloatContainer = document.getElementById("grid_rightTableFloatContainer"),
            	grid_rightTableFloat = document.getElementById("grid_rightTableFloat"),
                grid_floatersContainers = document.getElementById("grid_floatersContainers"),
                grid_floatersPositioner = document.getElementById("grid_floatersPositioner"),
                grid_fullTableContainer = document.getElementById("grid_fullTableContainer"),
                grid_rightTable = document.getElementById("grid_rightTable");
            
            if(grid_fixedColumnsTableFloating && leftFloaterWidth) grid_fixedColumnsTableFloating.style.width = (leftFloaterWidth - 11) + "px";
            
            if(grid_fullTableContainer) {
                if(grid_rightTableFloatContainer && leftFloaterWidth) grid_rightTableFloatContainer.style.width = (grid_fullTableContainer.getBoundingClientRect().width - leftFloaterWidth + 11) + "px)";
                if(grid_floatersContainers) grid_floatersContainers.style.width = (grid_fullTableContainer.getBoundingClientRect().width) + "px";
                if(grid_floatersPositioner) grid_floatersPositioner.style.width = (grid_fullTableContainer.getBoundingClientRect().width) + "px";
            }
            
            if(grid_rightTableFloat && grid_rightTable) grid_rightTableFloat.style.width = (grid_rightTable.getBoundingClientRect().width) + "px";
            
            for(var i = 0; i < leftColumns.length; i+=1) {
                leftColsFloat[i].style.width = (leftColumns[i].getBoundingClientRect().width - 17) + "px";
            }            
            for(var i = 0; i < rightColumn.length; i+=1) {
                rightColumnFloat[i].style.width = rightColumn[i].getBoundingClientRect().width + "px";
                rightColumnFloat[i].style.minWidth = rightColumn[i].getBoundingClientRect().width + "px";
            }
            
        } catch(e) {
            //console.log(e);
        }
    },
    handleWindowScroll : function(component, event, helper) {
        //floatersContainers
        var grid_floatersPositioner = document.getElementById("grid_floatersPositioner");
        if(window.innerHeight <= 650 && window.scrollY >= 240) {
        	if(grid_floatersPositioner) grid_floatersPositioner.style.top = "135px";
        	if(grid_floatersPositioner) grid_floatersPositioner.style.position = "fixed";
        } else {
        	if(grid_floatersPositioner) grid_floatersPositioner.style.top = "-" + window.scrollY + "px";
        	if(grid_floatersPositioner) grid_floatersPositioner.style.position = "relative";
        }
        
    },
    
    getUserDetails : function(component, event, helper){
        var action = component.get("c.fetchUser");
        
        action.setCallback(this, function(response) {
            var userDetail = response.getReturnValue();
            if(userDetail.Mass_Pricing_Lock_Column__c == null || userDetail.Mass_Pricing_Lock_Column__c == '' || userDetail.Mass_Pricing_Lock_Column__c == 0){
                component.set("v.noOfColumns", 1);
            }
            else{
                component.set("v.noOfColumns", response.getReturnValue().Mass_Pricing_Lock_Column__c);
            }
                        
        });
        $A.enqueueAction(action);
    }
    
})