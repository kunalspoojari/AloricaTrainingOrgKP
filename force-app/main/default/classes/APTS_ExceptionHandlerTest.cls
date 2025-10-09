@isTest
public class APTS_ExceptionHandlerTest {
    @isTest
    static void testHandleTriggerExceptionWithDmlException() {
        Apttus__APTS_Agreement__c badAgreement = new Apttus__APTS_Agreement__c(); 
        List<sObject> objList = new List<sObject>{ badAgreement };

        try {
            insert badAgreement;
        } catch (DmlException dmlEx) {
            Test.startTest();
            APTS_ExceptionHandler.handleTriggerException(dmlEx, objList);
            Test.stopTest();

            try {
                insert badAgreement;
            } catch (DmlException e) {
                System.assert(e.getMessage().contains(dmlEx.getDmlMessage(0)));
            }
        }
    }

    @isTest
    static void testHandleTriggerExceptionWithGenericException() {
        Apttus__APTS_Agreement__c agreement = null;
        List<sObject> objList = new List<sObject>{ new Apttus__APTS_Agreement__c(Name = 'Test') };

        try {
            agreement.get('Name');
        } catch (Exception e) {
            Test.startTest();
            APTS_ExceptionHandler.handleTriggerException(e, objList);
            Test.stopTest();

            try {
                insert objList;
            } catch (DmlException de) {
                System.assert(de.getMessage().contains(e.getMessage()));
            }
        }
    }

    @isTest
    static void testHandleExceptionWithDmlException() {
        Apttus__APTS_Agreement__c badAgreement = new Apttus__APTS_Agreement__c();

        try {
            insert badAgreement;
        } catch (DmlException dmlEx) {
            Test.startTest();
            APTS_ExceptionHandler.handleException(
                dmlEx,
                'inserting',
                'APTS_ExceptionHandlerTest',
                'testHandleExceptionWithDmlException'
            );
            Test.stopTest();
        }
    }

    @isTest
    static void testHandleExceptionWithGenericException() {
        String s;
        try {
            Integer len = s.length();
        } catch (Exception e) {
            Test.startTest();
            APTS_ExceptionHandler.handleException(
                e,
                'testing',
                'APTS_ExceptionHandlerTest',
                'testHandleExceptionWithGenericException'
            );
            Test.stopTest();
        }
    }
}