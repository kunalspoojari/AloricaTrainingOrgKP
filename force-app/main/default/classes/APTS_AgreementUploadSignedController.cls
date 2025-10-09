public class APTS_AgreementUploadSignedController {
    public Attachment attachment {
    get {
        if (attachment == null)
        attachment = new Attachment();
        return attachment;
    }
        set;
    }
    
    public PageReference upload() {
    
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = ApexPages.currentPage().getParameters().get('id'); // the record the file is attached to
        attachment.IsPrivate = true;
        
        try {
            insert attachment;
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            if(!test.isRunningTest())
            return null;
        } finally {
            attachment = new Attachment(); 
        }
        
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
        if(ApexPages.currentPage().getParameters().get('signed') == 'fully')
        {
            Apttus__APTS_Agreement__c ag = [SELECT Id,  Apttus__Status__c, Apttus__Status_Category__c ,Name, Apttus__FF_Agreement_Number__c, OwnerId FROM Apttus__APTS_Agreement__c WHERE Id =: ApexPages.currentPage().getParameters().get('id')];
            if(ag != NULL)
            {
                ag.Apttus__Status_Category__c = 'In Signatures';
                ag.Apttus__Status__c = 'Fully Signed';
                update ag;
                
            }
        }
        if(ApexPages.currentPage().getParameters().get('signed') == 'partially')
        {
            Apttus__APTS_Agreement__c ag = [SELECT Id,  Apttus__Status__c, Apttus__Status_Category__c FROM Apttus__APTS_Agreement__c WHERE Id =: ApexPages.currentPage().getParameters().get('id')];
            if(ag != NULL)
            {
                ag.Apttus__Status_Category__c = 'In Signatures';
                ag.Apttus__Status__c = 'Partially Signed';
                update ag;
                
            }
        }
        
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));
    }
	

}