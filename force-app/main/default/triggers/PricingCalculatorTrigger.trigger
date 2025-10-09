trigger PricingCalculatorTrigger on PricingCalculator__c (before insert, before update,after insert, after update, after delete, before delete, after undelete) {
     
	 /*Not needed yet: before delete, after insert, after delete, after undelete */ 

	if (Trigger.isBefore) {

        if (Trigger.isInsert) {
            PricingCalculatorTriggerHandler.beforeInsert(Trigger.new);
        }
        else if (Trigger.isUpdate) {
            PricingCalculatorTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        else if (Trigger.isDelete) {
            // PricingCalculatorTriggerHandler.beforeDelete(Trigger.oldMap);
        }
    }
    else if (Trigger.isAfter) {

        if (Trigger.isInsert) {
            PricingCalculatorTriggerHandler.afterInsert(Trigger.new);
        }
        else if (Trigger.isUpdate) {
            PricingCalculatorTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        else if (Trigger.isDelete) {
            // PricingCalculatorTriggerHandler.afterDelete(Trigger.oldMap);
        }
        else if (Trigger.isUndelete) {
            // PricingCalculatorTriggerHandler.afterUndelete(Trigger.new);
        }
    }
}