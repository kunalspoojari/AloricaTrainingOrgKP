({
	sortByOrder : function(array, key) {
		return array.sort(function(a, b) {
			var x = a["sortOrder"]; var y = b["sortOrder"];
			return ((x < y) ? -1 : ((x > y) ? 1 : 0));
		});
	},
    getState : function(component, helper) {
        var getRecState = component.get("c.getRecState");
        getRecState.setParams({
            quoteLineId : component.get("v.recordId")
        });
        getRecState.setCallback(this, function(a) {
            component.set("v.stateTaken", true);
            component.set("v.hasrecs", a.getReturnValue());
        });
        $A.enqueueAction(getRecState);
    }
})