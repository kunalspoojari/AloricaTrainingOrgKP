/*************************************************************
@Name: APTS_AgreementTrigger
@Author: Meera Kant, PS - Apttus
@CreateDate: 6/06/2016
@Description: Trigger on Agreement object 
@UsedBy: Agreement
******************************************************************
@ModifiedBy: 
@ModifiedDate: 
@ChangeDescription: 
******************************************************************/
trigger APTS_AgreementTrigger on Apttus__APTS_Agreement__c (before insert,before update) {

    List<Apttus__APTS_Agreement__c> errorObjList;
    try {
        if(Trigger.isInsert && Trigger.isBefore) {
            errorObjList = Trigger.new;
            APTS_AgreementTriggerHandler.onBeforeInsert(Trigger.new);
        } 
        if(Trigger.isUpdate && Trigger.isBefore) {
            errorObjList = Trigger.new;
            APTS_AgreementTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);        
        }
    }  catch(Exception e) {
        APTS_ExceptionHandler.handleTriggerException(e, errorObjList);
    }
}