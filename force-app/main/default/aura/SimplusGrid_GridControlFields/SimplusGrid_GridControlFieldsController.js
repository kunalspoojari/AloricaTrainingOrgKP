({
    init : function(component, event, helper) {
        
        var getConfigFields = component.get("c.getControlFields");
        getConfigFields.setParams({
            "fieldSetNames" : [component.get("v.mainListSource")]
        });
        
        getConfigFields.setCallback(this, function(a){
            var fieldMap = a.getReturnValue()
            var fldList = [];
            
            for (var key in fieldMap) {
                if (fieldMap.hasOwnProperty(key)) {
                    if(fieldMap[key].enableMassUpdate) {
                        fldList.push(fieldMap[key]);
                    }
                }
            }
            var editableFieldsList = [];
            for (var key in fieldMap) {
                if (fieldMap.hasOwnProperty(key)) {
                    if(fieldMap[key].editable) {
                        component.set("v.showEditAll", true);
                        editableFieldsList.push(fieldMap[key]);
                    }
                }
            }
            
            fldList = helper.sortByOrder(fldList, "sortOrder");
            component.set("v.editableFieldsList", editableFieldsList);
            component.set("v.hasFields", fldList.length > 0 || component.get("v.showEditAll"));
            component.set("v.fieldsList", fldList);
        });
        $A.enqueueAction(getConfigFields);
        
        
        helper.getState(component, helper);
    },
    toggleEditAll : function(component, event, helper) {
        var fldList = component.get("v.editableFieldsList");
        console.log("fldList >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>", fldList);
        fldList.forEach(function(itm) {
            console.log("fldList >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>", itm.name, itm);
            var fldApi = itm.name;
            var toggleAllEdit = $A.get("e.c:SimplusGrid_ColumnToggleEdit");
            toggleAllEdit.setParams({
                "columnName" : fldApi,
                "editable" : true
            });
            toggleAllEdit.fire(); 
        });      
        var pushUpdate = component.getEvent("pushDimensionUpdate");
        pushUpdate.fire();
    },
    
    
    
    
    establishClicked : function(component, event, helper) {
        
        var action = component.get("c.generateQuoteLineRecords");
        action.setParams({
            quoteLineId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            helper.getState(component, helper);
            component.getEvent("pushRefresh").fire();
        });
        $A.enqueueAction(action);
    },
    
   
    doStageReestablish : function(component, event, helper) {
		component.set("v.stageReestablish", true);
    },
    doReestablish : function(component, event, helper) {
        var reestab = component.get("c.regenerateQuoteLineRecords");
        reestab.setParams({
            quoteLineId : component.get("v.recordId")
        });
        reestab.setCallback(this, function(a) {
            helper.getState(component, helper);
			component.set("v.stageReestablish", false);
            component.getEvent("pushRefresh").fire();
        });
        $A.enqueueAction(reestab);
    },
    doStageDelete : function(component, event, helper) {
		component.set("v.stageDeleteAll", true);
    },
    doDelete : function(component, event, helper) {
        console.log(event);
        var deleteAll = component.get("c.deleteQuoteLineRecords");
        deleteAll.setParams({
            quoteLineId : component.get("v.recordId")
        });
        deleteAll.setCallback(this, function(a) {
            helper.getState(component, helper);
			component.set("v.stageDeleteAll", false);
            component.getEvent("pushRefresh").fire();
        });
        $A.enqueueAction(deleteAll);
    },
    doStageCancel : function(component, event, helper) {
		component.set("v.stageReestablish", false);
		component.set("v.stageDeleteAll", false);
    }
    /*
	clearAllClick : function(component, event, helper) {
		var fieldsList = component.get("v.fieldsList");
		fieldsList.forEach(function(entry) {
			entry.clearVal();
		});
	},
    
    toggleEditAll : function(component, event, helper) {
        var fldList = component.get("v.editableFieldsList");
        console.log("fldList >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>", fldList);
        fldList.forEach(function(itm) {
            console.log("fldList >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>", itm.name, itm);
            var fldApi = itm.name;
            var toggleAllEdit = $A.get("e.c:SimplusGrid_ColumnToggleEdit");
            toggleAllEdit.setParams({
                "columnName" : fldApi,
                "editable" : true
            });
            toggleAllEdit.fire(); 
        });      
		var pushUpdate = component.getEvent("pushDimensionUpdate");
		pushUpdate.fire();
    },
    
	applyChangesClick : function(component, event, helper) {
		var fieldsList = component.get("v.fieldsList");
		fieldsList.forEach(function(entry) {
			entry.pushValToTable();
		});
		var pushUpdate = component.getEvent("pushUpdate");
		pushUpdate.fire();
		component.set("v.showEdit", true);
	},

	saveClicked : function(component, event, helper) {
		component.set("v.showEdit", false);
		var pushUpdate = component.getEvent("pushSave");
		pushUpdate.fire();
	},

	cancelClicked : function(component, event, helper) {
		component.set("v.showEdit", false);
		var fldListNames = component.get("v.fieldsList");
		var fldList = [];
		fldListNames.forEach(element => {
			fldList.push(element.name);
		})
		var pushCancel = component.getEvent("pushCancel");
		pushCancel.setParams({"jsonParam" : fldList});
		pushCancel.fire();
	},
	
	cloneClicked : function(component, event, helper) {
		component.set("v.showEdit", false);
		var pushUpdate = component.getEvent("pushClone");
		pushUpdate.fire();
     }*/
    
    
    
})