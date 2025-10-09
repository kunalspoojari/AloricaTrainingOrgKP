/* 
    @author: Gian Carlo Cutchon
    @Date: 8/22/2018
    @Name: opportunityTrigger
    @Description: This will update ServiceType__c equal to the value of Service_Type__c with "," separated to be use for SAVO.
*/
trigger opportunityTrigger on Opportunity (before insert, before update) {
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
        string tempString = '';
        set<string> serviceTypeValues = new set<string>();
        for (Opportunity record : trigger.new)
        {
            if (record.service_type__c != null)
            {
                //record.ServiceType__c = tempString.replace(';', ',');
                 tempString = string.valueof(record.service_type__c);
                //system.assertequals('1234' , tempString);
                //Analytics
                if(tempString.contains('Analytics')){
                    serviceTypeValues.add('Analytics');
                }
                //Back Office
                if(tempString.contains('Back Office') || tempString.contains('Fulfillment Services') || tempString.contains('Reverse Logistics') || tempString.contains('Account Services')){
                    serviceTypeValues.add('Back Office');
                }
                //Chat
                if(tempString.contains('Chat')){
                    serviceTypeValues.add('Chat');
                }
                //CRM
                if(tempString.contains('Technology Services - CRM')){
                    serviceTypeValues.add('CRM');
                }
                //Customer Care
                if(tempString.contains('Customer Care')){
                    serviceTypeValues.add('Customer Care');
                }
                //Email
                if(tempString.contains('Email')){
                    serviceTypeValues.add('Email');
                }
                //Financial Solutions - Collections
                if(tempString.contains('Financial Solutions - Collections') || tempString.contains('FC-EOS') || tempString.contains('FC-EPALS') || tempString.contains('FC-OOSMB')){
                    serviceTypeValues.add('Financial Solutions - Collections');
                }
                //IVR
                if(tempString.contains('Technology Services - IVR')){
                    serviceTypeValues.add('IVR');
                }

                //Revenue Generation
                if(tempString.contains('Retention') || tempString.contains('Direct Response') || tempString.contains('Sales - Inbound (B2C)') || tempString.contains('Sales - Outbound (B2B)') || tempString.contains('Sales - Inbound (B2B)') || tempString.contains('Sales - Outbound (B2C)')){
                    serviceTypeValues.add('Revenue Generation');
                }
                //Social Media
                if(tempString.contains('Social Media')){
                    serviceTypeValues.add('Social Media');
                }
                //SST
                if(tempString.contains('SST Backup') || tempString.contains('SST Transfer') || tempString.contains('SST Conduit') || tempString.contains('SST Transfer/Conduit') || tempString.contains('SST Verification') || tempString.contains('SST Custody')){
                    serviceTypeValues.add('SST');
                }
                //Technical Support
                if(tempString.contains('Technical Support')){
                    serviceTypeValues.add('Technical Support');
                }
                String joinedString = String.join(new List<String>(serviceTypeValues), '; ');
                record.ServiceType__c = joinedString;
            }
        }

    }
}