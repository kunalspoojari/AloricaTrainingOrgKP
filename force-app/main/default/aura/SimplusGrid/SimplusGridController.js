({
    doInit : function(component, event, helper) {
        console.log("Save # 3");
        helper.init(component, event, helper);
    },
    
    doGridRepaint : function(component, event, helper) {
        var params = event.getParam('arguments');
        console.log("grid repaint", params);
        if(params) {
            component.set("v.pageMax", params[0]);
            component.set("v.isBeyond", params[1]);
        }
        
        window.setTimeout(
            $A.getCallback(function() {
                helper.handleDimensionsUpdate(component, event, helper);
            }), 100
        );
    },
    onRender : function(component, event, helper) {
    }, 
    
    colMouseDown : function(component, event, helper) {
        event.preventDefault();
        var tg = event.target;
        while(!tg.getAttribute("data-column-header")) tg = tg.parentNode;
        
        if(tg.getAttribute("data-isfloat")) {
            component.set("v.colDragElement", tg);
            component.set("v.colDragElementSub", document.getElementById("col_" + tg.getAttribute("data-idx")));
        } else {
            component.set("v.colDragElement", tg);
            component.set("v.colDragElementSub", document.getElementById("floatcol_" + tg.getAttribute("data-idx")));
        }
        component.set("v.mouseIsDragging", true);
    },
    
    colMouseDrag : function(component, event, helper) {
        if(component.get("v.mouseIsDragging")) {
            var widthAdj = event.movementX;
            
            
            var thElement = component.get("v.colDragElement")
            var currWidth = thElement.offsetWidth;
            thElement.style.width = (currWidth + (widthAdj)) + "px";
            
            var thSib = thElement.nextSibling;
            var currSibWidth = thSib.offsetWidth;
            thSib.style.width = (currSibWidth - (widthAdj)) + "px";
            
            
            
            var thElementSub = component.get("v.colDragElementSub")
            var currWidthSub = thElementSub.offsetWidth;
            thElementSub.style.width = (currWidthSub + (widthAdj)) + "px";
            
            var thSibSub = thElementSub.nextSibling;
            var currSibWidthSub = thSibSub.offsetWidth;
            thSibSub.style.width = (currSibWidthSub - (widthAdj)) + "px";
            
        }
    },
    
    colMouseUp : function(component, event, helper) {
        component.set("v.colDragElement");
        component.set("v.colDragElementSub");
        component.set("v.mouseIsDragging", false);
    },
    
    toggleAllEditMode : function(component, event, helper) {
        var fldApi = event.getSource().get("v.name");
        var toggleAllEdit = $A.get("e.c:SimplusGrid_ColumnToggleEdit");
        toggleAllEdit.setParams({
            "columnName" : fldApi,
            "editable" : true
        });
        toggleAllEdit.fire();
    },
    
    checkUncheckAll : function(component, event, helper) {
        var tbList = component.get("v.tableRecordsUpdated");
        tbList.forEach(function(element) {
            if(element.QuoteStatus__c != 'Proposal' && element.QuoteStatus__c != 'Quotation') element.util.isSelected = event.target.checked;
        });

        component.set("v.tableRecordsUpdated", tbList);
    },
    
    checkUncheckLineItem : function(component, event, helper) {
        var tbList = component.get("v.tableRecordsUpdated");
        var isAllSelected = true;
        
        tbList[event.target.name].util.isSelected = event.target.checked;
        tbList.forEach(function(element) {
            if(!element.util.isSelected) {
                isAllSelected = false;
            } 
        });
        
        component.set("v.allItemsChecked", isAllSelected);
        document.getElementById("toggleAll").checked = isAllSelected;
        component.set("v.tableRecordsUpdated", tbList);
    },
    
    catchMassChange : function(component, event, helper) {
        var fldName = event.getParam("fieldApi");
        var newVal = event.getParam("newValue");
        var formula = event.getParam("formula");
        var multiDecision = event.getParam("multiDecision");
        
        
        var tbList = component.get("v.tableRecordsUpdated");
        
        tbList.forEach(function(element) {
            if(element.util.isSelected) {
                element.util.hasChange = true;
                var finalFldName = fldName;
                
                if(fldName.indexOf("||") > -1) {
                    var fieldItms = fldName.split("||");
                    var runDecision = new Function("record",multiDecision);
                	var result = runDecision(element);
                    finalFldName = fieldItms[result];
                    console.log("final >>>", result, fldName);
                }
                
                if(element.util[finalFldName]) { 
                    if(formula) element.util[finalFldName].acceptFormulaChange(finalFldName, newVal, formula)
                    else element.util[finalFldName].acceptChange(finalFldName, newVal);
                }
            }
        });
        component.set("v.hasPendingMassChange", true);
        window.setTimeout(
            $A.getCallback(function() {
                helper.handleDimensionsUpdate(component, event, helper);
            }), 100
        );
    },
    
    catchCancel : function(component, event, helper) {
        var tbList = component.get("v.tableRecordsUpdated");
        var fldLst = event.getParam("jsonParam");
        tbList.forEach(function(element) {
            if(element.util.isSelected) {
                console.log(">>> ", fldLst);
                console.log(">>>> ", element);
                fldLst.forEach(function(fld) {
                    element.util.hasChange = false;
                    if(element.util[fld] && element.util[fld]) element.util[fld].revertChange();
                });
            }
        });
        component.set("v.hasPendingMassChange", false);
        window.setTimeout(
            $A.getCallback(function() {
                helper.handleDimensionsUpdate(component, event, helper);
            }), 100
        );
        
    },
    
    catchSave : function(component, event, helper) {
        component.set("v.isLoadingList", true);
        var runSave = component.get("c.saveRecords");
        var saveList = [];
        component.get("v.tableRecordsUpdated").forEach(
            function(itm) {
                if(itm.util.isSelected) {
                    var saveCopy = JSON.parse(JSON.stringify(itm));
                    delete saveCopy.util;
                    saveCopy.sobjectType = component.get("v.sObjectName");
                    console.log("saveCopy >> ", saveCopy);
                    saveList.push(saveCopy);
                }
            }
        );
        console.log("full list >> ", saveList);
        runSave.setParams({
            saveList : JSON.stringify(saveList)
        });
        runSave.setCallback(this, function(a) {
            helper.refreshList(component, event, helper);
            window.setTimeout(
                $A.getCallback(function() {
                    helper.handleDimensionsUpdate(component, event, helper);
                }), 150
            );
        });
        
        $A.enqueueAction(runSave);
    },
    
    catchDimensionUpdate : function(component, event, helper) {
        window.setTimeout(
            $A.getCallback(function() {
                helper.handleDimensionsUpdate(component, event, helper);
            }), 150
        );
    },
    
    refreshPage : function(component, event, helper) {
        //helper.refreshList(component, event, helper);
        helper.getTableRows(component, event, helper);
    },
    
    catchClone : function(component, event, helper) {
        component.set("v.isLoadingList", true);
        var runClone = component.get("c.cloneRecords");
        var saveList = [];
        saveList = event.getParam("jsonParam");
        console.log(saveList);
        runClone.setParams({
            saveList : JSON.stringify(saveList)
        });
        runClone.setCallback(this, function(a) {
            helper.refreshList(component, event, helper);
            console.log("clone result >>> ", a.getReturnValue());
            var showToast = $A.get("e.force:showToast"); 
            showToast.setParams({ 
                'title' : 'Message', 
                'message' : a.getReturnValue() 
            }); 
            showToast.fire(); 
            component.set("v.selections");
        });
        
        $A.enqueueAction(runClone);
    },
    
    catchCloneandSubmit : function(component, event, helper) {
        component.set("v.isLoadingList", true);
        var runClone = component.get("c.cloneandsubmitRecords");
        var saveList = [];
        saveList = event.getParam("jsonParam");
        console.log(saveList);
        runClone.setParams({
            saveList : JSON.stringify(saveList)
        });
        runClone.setCallback(this, function(a) {
            helper.refreshList(component, event, helper);
            console.log("clone result >>> ", a.getReturnValue());
            var showToast = $A.get("e.force:showToast"); 
            showToast.setParams({ 
                'title' : 'Message', 
                'message' : a.getReturnValue() 
            }); 
            showToast.fire(); 
            component.set("v.selections");
        });
        
        $A.enqueueAction(runClone);
    },
    
    fieldChange : function(component, event, helper) {
        var x = 0;
        var freezeColumns = component.get("v.noOfColumns");
        var fieldSetValues = component.get("v.fieldSetValues");
        var fieldSetValues1 = [];
        var fieldSetValues2 = [];
        
        var action = component.get("c.saveUserDetail");
        action.setParams({
            noOfColumns: component.get("v.noOfColumns")
        });
        action.setCallback(this, function(response) {
            console.log('User save response', response.getReturnValue()); 
        });
        $A.enqueueAction(action);
        
        fieldSetValues.forEach(function(element) {
            x++;
            if(x <= freezeColumns) {
                fieldSetValues1.push(element);
            } else {
                fieldSetValues2.push(element);
            }
        });
        console.log("fieldSetValues1 >>> ", fieldSetValues1);
        component.set("v.fieldSetValues1", fieldSetValues1);
        component.set("v.fieldSetValues2", fieldSetValues2);
        
        window.setTimeout(
            $A.getCallback(function() {
                helper.handleDimensionsUpdate(component, event, helper);
            }), 50
        );
        
    },
    handleScroll : function(component, event, helper) {
        var floatTable = document.getElementById("grid_rightTableFloat");
        if(floatTable) floatTable.style.left = ((0 - event.currentTarget.scrollLeft) + 1) + "px";
    },
    
    prevPage : function(component, event, helper) {
        var page = component.get("v.page")
        if(page > 1) {
            console.log("prev", page);
            component.set("v.page", page-1);
            console.log("preve", component.get("v.page"));
            helper.getTableRows(component,event,helper);
        }
    },
    nextPage : function(component, event, helper) {
        var page = component.get("v.page")
        if(page < component.get("v.pageMax")) {
            console.log("next", page);
            component.set("v.page", page+1);
            console.log("next", component.get("v.page"));
            helper.getTableRows(component,event,helper);
        }
    },
    
    firstPage : function(component, event, helper) {
        var page = component.get("v.page")
        if(page > 1) {
            console.log("prev", page);
            component.set("v.page", 1);
            console.log("preve", component.get("v.page"));
            helper.getTableRows(component,event,helper);
        }
    },
    lastPage : function(component, event, helper) {
        var page = component.get("v.page")
        if(page < component.get("v.pageMax")) {
            console.log("next", page);
            component.set("v.page", component.get("v.pageMax"));
            console.log("next", component.get("v.page"));
            helper.getTableRows(component,event,helper);
        }
    },
    doGetSelections : function(component, event, helper) {
        var returnList = [];
        var quoteSet = [];
        var iterateList = component.get("v.tableRecordsUpdated");
        iterateList.forEach(function(itm) {
            if(itm.util.isSelected) {
                //console.log(itm.SBQQ__Quote__r);
                returnList.push(itm);
                //quoteSet.push(itm.SBQQ__Quote__c)
            }
        });
        console.log(returnList);
        component.set("v.selections", returnList);
    },
    closeClone : function(component, event, helper) {
        component.set("v.selections");
    }
})