public class ConvertLeadApex {
    
    @InvocableMethod(label='Convert Lead' description='Converts a lead into an account, a contact, and optionally an opportunity.')
    public static List<LeadConversionResult> convertLead(List<LeadConversionRequest> requests) {
        List<LeadConversionResult> results = new List<LeadConversionResult>();
        
        for (LeadConversionRequest request : requests) {
            LeadConversionResult result = new LeadConversionResult();
            
            try {
                // Set default values for booleans
                request.overWriteLeadSource = request.overWriteLeadSource != null ? request.overWriteLeadSource : false;
                request.createOpportunity = request.createOpportunity != null ? request.createOpportunity : true;
                request.sendEmailToOwner = request.sendEmailToOwner != null ? request.sendEmailToOwner : false;
                
                // Convert the lead and catch any issues
                Map<String, String> conversionResult = convertLead(
                    request.leadID, 
                    request.contactID, 
                    request.createCon, 
                    request.FName, 
                    request.LName,
                    request.conEmail, 
                    request.conOwnerId,
                    request.accountID, 
                    request.createAcc, 
                    request.accOwnerId, 
                    request.accName, 
                    request.accWebsite, 
                    request.accAlVertical, 
                    request.accAlIndustry, 
                    request.convertedStatus, 
                    request.overWriteLeadSource, 
                    request.createOpportunity, 
                    request.opportunityName, 
                    request.sendEmailToOwner
                );
                
                // Store results
                result.accountID = conversionResult.get('AccountID');
                result.contactID = conversionResult.get('ContactID');
                result.opportunityID = conversionResult.get('OpportunityID');
                
            } catch (CustomLeadConversionException e) {
                // Capture the error message and pass it to the Flow screen
                result.errorMessage = e.getMessage();
            }
            
            results.add(result);
        }
        
        return results;
    }
    
    public static Map<String, String> convertLead(
        String leadID,
        String contactID,
        Boolean createCon,
        String FName,
        String LName,
        String conEmail,    
        String conOwnerId, 
        String accountID,
        Boolean createAcc,
        String accOwnerId,        
        String accName,
        String accWebsite,
        String accAlVertical,
        String accAlIndustry,
        String convertedStatus,
        Boolean overWriteLeadSource,
        Boolean createOpportunity,
        String opportunityName,
        Boolean sendEmailToOwner
    ) {
        Map<String, String> result = new Map<String, String>();
        Savepoint sp = Database.setSavepoint();
        
        try {
            if (String.isBlank(leadID)) {
                throw new CustomLeadConversionException('Lead ID cannot be null or empty.');
            }
            
            // Query the Lead with the provided ID
            Lead[] leads = [SELECT Id, FirstName, LastName, Company, Email, Website, Phone, Title, LeadSource, Description, 
                    HasOptedOutOfEmail,
                    pi__Needs_Score_Synced__c, pi__Pardot_Last_Scored_At__c, pi__campaign__c, 
                    pi__comments__c, pi__conversion_date__c, pi__conversion_object_name__c, 
                    pi__conversion_object_type__c, pi__created_date__c, pi__first_activity__c, 
                    pi__first_search_term__c, pi__first_search_type__c, pi__first_touch_url__c, 
                    pi__grade__c, pi__last_activity__c, pi__notes__c, pi__pardot_hard_bounced__c, 
                    pi__score__c, pi__url__c, pi__utm_campaign__c, pi__utm_content__c, 
                    pi__utm_medium__c, pi__utm_source__c, Service_Considering_2__c, pi__utm_term__c, Last_Form_Submission_Date__c
             FROM Lead 
             WHERE Id = :leadID 
             LIMIT 1];

            if (leads.isEmpty()) {
                throw new CustomLeadConversionException('No leads found with Id: "' + leadID + '"');
            }
            Lead lead = leads[0];
            
            // Handle Account creation or retrieval
            if (accountID == null && createAcc) {
                string website = accWebsite;
                Account[] accounts = [SELECT Id, Name, Website FROM Account WHERE Website = :accWebsite LIMIT 1];
                System.debug(accounts);
                if (!accounts.isEmpty() ) {
                    System.debug(accounts);
                    throw new CustomLeadConversionException('An account already exists with the website ' + lead.Website + '. Please choose the existing account.');
                } else if (String.isNotBlank(accOwnerId) && String.isNotBlank(accName) && String.isNotBlank(accWebsite) && String.isNotBlank(accAlVertical) && String.isNotBlank(accAlIndustry)) {
                    Account acct = new Account(
                        Name = accName,
                        Website = accWebsite,
                        Alorica_Industry__c = accAlIndustry,
                        Alorica_Vertical__c = accAlVertical,
                        OwnerId = accOwnerId,
                        Inside_Sales_Contact__c = accOwnerId
                    );
                    insert acct;
                    accountID = acct.Id;
                } else {
                    throw new CustomLeadConversionException('Please provide all required account fields.');
                }
            }
            
            // Handle Contact creation or retrieval
            if (contactID == null && createCon) {
                Contact[] contacts = [SELECT Id, Name, Email FROM Contact WHERE Email = :lead.Email LIMIT 1];
                if (!contacts.isEmpty()) {
                    throw new CustomLeadConversionException('A contact already exists with the email ' + lead.Email + '. Please choose the existing contact.');
                } else if (String.isNotBlank(conOwnerId) && String.isNotBlank(FName) && String.isNotBlank(LName)&& String.isNotBlank(conEmail)) {
                    try {
                        Contact cont = new Contact(
                            FirstName = FName,
                            LastName = LName,
                            Email = lead.Email,
                            AccountId = accountID,
                            OwnerId = conOwnerId,
                            Contact_Stage__c = 'Marketing Qualified Lead',
                            Phone = (lead.Phone != null) ? lead.Phone : null,
                            Title = (lead.Title != null) ? lead.Title : null,
                            LeadSource = (lead.LeadSource != null) ? lead.LeadSource : null,
                            Description = (lead.Description != null) ? lead.Description : null,
                            pi__Needs_Score_Synced__c = lead.pi__Needs_Score_Synced__c,
                            pi__Pardot_Last_Scored_At__c = (lead.pi__Pardot_Last_Scored_At__c != null) ? lead.pi__Pardot_Last_Scored_At__c : null,
                            pi__campaign__c = (lead.pi__campaign__c != null) ? lead.pi__campaign__c : null,
                            pi__comments__c = (lead.pi__comments__c != null) ? lead.pi__comments__c : null,
                            pi__conversion_date__c = (lead.pi__conversion_date__c != null) ? lead.pi__conversion_date__c : null,
                            pi__conversion_object_name__c = (lead.pi__conversion_object_name__c != null) ? lead.pi__conversion_object_name__c : null,
                            pi__conversion_object_type__c = (lead.pi__conversion_object_type__c != null) ? lead.pi__conversion_object_type__c : null,
                            pi__created_date__c = (lead.pi__created_date__c != null) ? lead.pi__created_date__c : null,
                            pi__first_activity__c = (lead.pi__first_activity__c != null) ? lead.pi__first_activity__c : null,
                            pi__first_search_term__c = (lead.pi__first_search_term__c != null) ? lead.pi__first_search_term__c : null,
                            pi__first_search_type__c = (lead.pi__first_search_type__c != null) ? lead.pi__first_search_type__c : null,
                            pi__first_touch_url__c = (lead.pi__first_touch_url__c != null) ? lead.pi__first_touch_url__c : null,
                            pi__grade__c = (lead.pi__grade__c != null) ? lead.pi__grade__c : null,
                            pi__last_activity__c = (lead.pi__last_activity__c != null) ? lead.pi__last_activity__c : null,
                            pi__notes__c = (lead.pi__notes__c != null) ? lead.pi__notes__c : null,
                            pi__pardot_hard_bounced__c = lead.pi__pardot_hard_bounced__c,
                            pi__score__c = (lead.pi__score__c != null) ? lead.pi__score__c : null,
                            pi__url__c = (lead.pi__url__c != null) ? lead.pi__url__c : null,
                            pi__utm_campaign__c = (lead.pi__utm_campaign__c != null) ? lead.pi__utm_campaign__c : null,
                            pi__utm_content__c = (lead.pi__utm_content__c != null) ? lead.pi__utm_content__c : null,
                            pi__utm_medium__c = (lead.pi__utm_medium__c != null) ? lead.pi__utm_medium__c : null,
                            pi__utm_source__c = (lead.pi__utm_source__c != null) ? lead.pi__utm_source__c : null,
                            pi__utm_term__c = (lead.pi__utm_term__c != null) ? lead.pi__utm_term__c : null,
                            Service_Considering__c = (lead.Service_Considering_2__c != null) ? lead.Service_Considering_2__c : null,
                            Last_Form_Submission_Date__c = (lead.Last_Form_Submission_Date__c != null) ? lead.Last_Form_Submission_Date__c : null
                            
                            //HasOptedOutOfEmail = lead.HasOptedOutOfEmail,
                            // Jigsaw = (lead.Jigsaw != null) ? lead.Jigsaw : null,
                            // IndividualId = (lead.IndividualId != null) ? lead.IndividualId : null,
                            //LID__LinkedIn_Company_Id__c = (lead.LID__LinkedIn_Company_Id__c != null) ? lead.LID__LinkedIn_Company_Id__c : null,
                            //LID__LinkedIn_Member_Token__c = (lead.LID__LinkedIn_Member_Token__c != null) ? lead.LID__LinkedIn_Member_Token__c : null,
                            //  Asst_Email__c = (lead.Asst_Email__c != null) ? lead.Asst_Email__c : null,
                            // zisf__ZoomInfo_Email__c = (lead.zisf__ZoomInfo_Email__c != null) ? lead.zisf__ZoomInfo_Email__c : null,
                            // zisf__ZoomInfo_Phone__c = (lead.zisf__ZoomInfo_Phone__c != null) ? lead.zisf__ZoomInfo_Phone__c : null,
                            // zisf__zoom_id__c = (lead.zisf__zoom_id__c != null) ? lead.zisf__zoom_id__c : null,
                            //zisf__zoom_lastupdated__c = (lead.zisf__zoom_lastupdated__c != null) ? lead.zisf__zoom_lastupdated__c : null,
                            //  zisf__Person_Has_Moved__c = lead.zisf__Person_Has_Moved__c,
                            //  zisf__ZoomInfo_Complete_Status__c = (lead.zisf__ZoomInfo_Complete_Status__c != null) ? lead.zisf__ZoomInfo_Complete_Status__c : null,
                            // zisf__ZoomInfo_Last_Clean_Run__c = (lead.zisf__ZoomInfo_Last_Clean_Run__c != null) ? lead.zisf__ZoomInfo_Last_Clean_Run__c : null,
                            // zisf__Zoom_Clean_Status__c = (lead.zisf__Zoom_Clean_Status__c != null) ? lead.zisf__Zoom_Clean_Status__c : null,
                           
                            // Service_Considering__c = (lead.Service_Considering__c != null) ? lead.Service_Considering__c : null,
                            // Size_of_Organization__c = (lead.Size_of_Organization__c != null) ? lead.Size_of_Organization__c : null,
                            // Email_Verification__c = (lead.Email_Verification__c != null) ? lead.Email_Verification__c : null,
                            // et4ae5__HasOptedOutOfMobile__c = lead.et4ae5__HasOptedOutOfMobile__c,
                            //et4ae5__Mobile_Country_Code__c = (lead.et4ae5__Mobile_Country_Code__c != null) ? lead.et4ae5__Mobile_Country_Code__c : null,
                            //  iv__InsideView_Created__c = (lead.iv__InsideView_Created__c != null) ? lead.iv__InsideView_Created__c : null,
                            // iv__InsideView_Data_Integrity_Status__c = (lead.iv__InsideView_Data_Integrity_Status__c != null) ? lead.iv__InsideView_Data_Integrity_Status__c : null,
                            // iv__InsideView_Date_Last_Updated__c = (lead.iv__InsideView_Date_Last_Updated__c != null) ? lead.iv__InsideView_Date_Last_Updated__c : null,
                            // iv__InsideView_Employment_ID__c = (lead.iv__InsideView_Employment_ID__c != null) ? lead.iv__InsideView_Employment_ID__c : null,
                            //iv__InsideView_Executive_ID__c = (lead.iv__InsideView_Executive_ID__c != null) ? lead.iv__InsideView_Executive_ID__c : null,
                            // iv__InsideView_User_Last_Updated__c = (lead.iv__InsideView_User_Last_Updated__c != null) ? lead.iv__InsideView_User_Last_Updated__c : null,
                            //engagio__Department__c = (lead.engagio__Department__c != null) ? lead.engagio__Department__c : null,
                            // engagio__EngagementMinutesLast30Days__c = (lead.engagio__EngagementMinutesLast30Days__c != null) ? lead.engagio__EngagementMinutesLast30Days__c : null,
                            // engagio__EngagementMinutesLast3Months__c = (lead.engagio__EngagementMinutesLast3Months__c != null) ? lead.engagio__EngagementMinutesLast3Months__c : null,
                            //engagio__EngagementMinutesLast7Days__c = (lead.engagio__EngagementMinutesLast7Days__c != null) ? lead.engagio__EngagementMinutesLast7Days__c : null,
                            //engagio__FirstEngagementDate__c = (lead.engagio__FirstEngagementDate__c != null) ? lead.engagio__FirstEngagementDate__c : null,
                            // engagio__IntentMinutesLast30Days__c = (lead.engagio__IntentMinutesLast30Days__c != null) ? lead.engagio__IntentMinutesLast30Days__c : null,
                            // engagio__Role__c = (lead.engagio__Role__c != null) ? lead.engagio__Role__c : null,
                            // engagio__Sales_Touches_14_days__c = (lead.engagio__Sales_Touches_14_days__c != null) ? lead.engagio__Sales_Touches_14_days__c : null,
                            //engagio__Sales_Touches_7_days__c = (lead.engagio__Sales_Touches_7_days__c != null) ? lead.engagio__Sales_Touches_7_days__c : null
                        );
                        insert cont;
                        contactID = cont.Id;
                       
                    }
                    catch (CustomLeadConversionException e) {
                        // Capture the error message and pass it to the Flow screen
                        Database.rollback(sp);
                        throw new CustomLeadConversionException(e.getMessage());
                    }
                } else {
                    throw new CustomLeadConversionException('Please provide all required contact fields.');
                }
            }
            Lead leadRecord = [SELECT Id, Contact__c, Status FROM Lead WHERE Id = :leadID LIMIT 1];
            leadRecord.Contact__c = contactID;
            leadRecord.Status = 'Qualified';
            System.debug('leadRecord.Contact__c - ' + leadRecord.Contact__c);
            System.debug('leadRecord.Status - ' + leadRecord.Status);
             System.debug('contactID - ' + contactID);
            update leadRecord;
            
            
            // Perform the lead conversion
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(leadID);
            lc.setOwnerId(conOwnerId);
            lc.setOverwriteLeadSource(overWriteLeadSource);
            lc.setDoNotCreateOpportunity(!createOpportunity);
            lc.setConvertedStatus(convertedStatus);
            
            if (sendEmailToOwner != null) lc.setSendNotificationEmail(sendEmailToOwner);
            if (String.isNotBlank(accountID)) lc.setAccountId(accountID);
            if (String.isNotBlank(contactID)) lc.setContactId(contactID);
            if (createOpportunity) lc.setOpportunityName(opportunityName);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc, true);
            if (lcr.isSuccess()) {
                result.put('AccountID', lcr.getAccountId());
                result.put('ContactID', lcr.getContactId());
                if (createOpportunity) {
                    result.put('OpportunityID', lcr.getOpportunityId());
                }
            } else {
                throw new CustomLeadConversionException(lcr.getErrors()[0].getMessage());
            }
            
        } catch (Exception e) {
            // Return or handle exception gracefully
            Database.rollback(sp);
            throw new CustomLeadConversionException(e.getMessage());
        }
        
        return result;
    }
    
    public class LeadConversionRequest {
        @InvocableVariable(required = true)
        public String leadID;
        @InvocableVariable
        public String contactID;
        @InvocableVariable
        public Boolean createCon;
        @InvocableVariable
        public String FName;
        @InvocableVariable
        public String LName;
        @InvocableVariable
        public String conEmail;
        @InvocableVariable
        public String conOwnerId;
        @InvocableVariable
        public String accountID;
        @InvocableVariable
        public Boolean createAcc;
        @InvocableVariable
        public String accOwnerId;
        @InvocableVariable
        public String accName;
        @InvocableVariable
        public String accWebsite;
        @InvocableVariable
        public String accAlVertical;
        @InvocableVariable
        public String accAlIndustry;
        @InvocableVariable(required = true)
        public String convertedStatus;
        @InvocableVariable
        public Boolean overWriteLeadSource;
        @InvocableVariable
        public Boolean createOpportunity;
        @InvocableVariable
        public String opportunityName;
        @InvocableVariable
        public Boolean sendEmailToOwner;
    }
    
    public class LeadConversionResult {
        @InvocableVariable
        public String accountID;
        @InvocableVariable
        public String contactID;
        @InvocableVariable
        public String opportunityID;
        @InvocableVariable
        public String errorMessage;
    }
    
    // Custom Exception Class
    public class CustomLeadConversionException extends Exception {
        // No custom constructor needed; use default constructor
    }
    
}