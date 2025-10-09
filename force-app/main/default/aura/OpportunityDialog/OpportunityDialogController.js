({
	doInit: function(component, event, helper) {
        var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        var createRecordEvent = $A.get("e.force:createRecord");
        console.log(recordTypeId);
        if (recordTypeId == '012f3000000IjD3AAK'){
            console.log('Inside Lightning');
            createRecordEvent.setParams({
                "entityApiName": "Opportunity",
                "recordTypeId" : recordTypeId,
                "defaultFieldValues": {
                    'Name' : 'Auto Generated'
                }
            
        	});
        }else if(recordTypeId == '0124y0000005jDlAAI'){
             console.log('Inside Alorica Digital');
             createRecordEvent.setParams({
                "entityApiName": "Opportunity",
                "recordTypeId" : '0124y0000005jDlAAI',
                "defaultFieldValues": {
                    'Name' : ''
                }
        	});
		} else {
            console.log('Inside Else');
            createRecordEvent.setParams({
                "entityApiName": "Opportunity",
                "recordTypeId" : '012f3000000IjD3AAK',
                "defaultFieldValues": {
                    'Name' : 'Auto Generated'
                }
        	});
        }
        
        createRecordEvent.fire();
    }
})