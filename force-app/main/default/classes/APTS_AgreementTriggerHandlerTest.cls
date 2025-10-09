@isTest
public class APTS_AgreementTriggerHandlerTest {

    public static testMethod void test() {

        Decimal counter = Math.random();
         Profile intgProfile = [Select Id From Profile Where Name = 'System Administrator' Limit 1];
        //User testUser = [Select Id from User where FirstName = 'Gary' and LastName = 'Aaront' and CommunityNickname = 'gary.aaront' Limit 1];
        User testUser = new User(alias = 'clmuser', 
                                    email='clmuser@testorg.com',
                                    emailencodingkey='UTF-8', 
                                    firstname='clmuser',
                                    lastname='clmuser'+counter, 
                                    languagelocalekey='en_US',
                                    localesidkey='en_US', 
                                    profileid = intgProfile.Id, 
                                    timezonesidkey='America/Los_Angeles', 
                                    username='clmuser'+counter+'@testorg.com');
        insert testUser; 



        System.runAs(testUser){
            List<RecordType > recTypes = [SELECT Id, Name FROM RecordType WHERE Name IN ('MSA','MNDA','SOW','NDA')];
            Map<String,Id> recordTypeMap = new Map<String,Id> ();
            for(RecordType recType : recTypes)
                recordTypeMap.put(recType.Name,recType.Id);

            Apttus__APTS_Agreement__C a = new Apttus__APTS_Agreement__C();
            a.Apts_Call_Center_Location__c = 'Albuquerque';
            a.Apttus__Status_Category__c = 'In Authoring';
            a.Apttus__Status__c = 'Author Contract';
            a.RecordTypeId = recordTypeMap.get('MNDA');
            a.Apttus__Source__c = 'Alorica Paper';

            Apttus__APTS_Template__c temp = new Apttus__APTS_Template__c(Name = 'test1',
                                                                        Apttus__Description__c= 'test',
                                                                        Apttus__Agreement_Types__c ='NDA',
                                                                        Apttus__IsActive__c = true,
                                                                        Apttus__Type__c = 'Agreement');
            insert a;
            insert temp;
            APTS_AgreementTriggerHandler.onBeforeUpdate = false;
            APTS_AgreementTriggerHandler.onBeforeInsert = false;

            a.Apttus__Status__c = 'Submitted Request';
            update a;
            APTS_AgreementTriggerHandler.onBeforeUpdate = false;

            a.Apttus__Status__c = null;
            update a;
            APTS_AgreementTriggerHandler.onBeforeUpdate = false;

            a.Apttus__Status_Category__c = 'In Signatures';
            a.Apttus__Status__c = 'Other Party Signatures';
            update a;
            APTS_AgreementTriggerHandler.onBeforeUpdate = false;
        }
    }
}