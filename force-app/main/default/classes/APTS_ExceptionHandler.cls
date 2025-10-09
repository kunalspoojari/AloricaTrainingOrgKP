/*************************************************************
@Name: APTS_ExceptionHandler
@Author: PS - Apttus
@CreateDate: 8/08/2016
@Description: Class to for handling Exceptions 
******************************************************************/
public with sharing class APTS_ExceptionHandler {
    public static void handleTriggerException(Exception e, List<sObject> objList) {     
        String exceptionType = e.getTypeName();
        String errorMessage;
        if(exceptionType == 'System.DmlException') {
            errorMessage = e.getDmlMessage(0);
        } else {
            errorMessage = e.getMessage();
        }
        
        for(sObject obj : objList) {
            obj.addError(errorMessage);
        }
    }

    public static void handleException(Exception e, String action, String className, String methodName) {
        
        String exceptionType = e.getTypeName();
        String errorMessage;
        
        if(exceptionType == 'System.DmlException') {
            errorMessage = e.getDmlMessage(0);
        } else {
            errorMessage = e.getMessage();
        }
      
        system.debug('Error occured while ' + action + ' in \"' + methodName + '\" method of \"' + className + '\" class.');
        system.debug('Error Description: ' + errorMessage);
    }  
}