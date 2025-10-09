public without sharing class APTS_AttachmentTriggerHandler 
{
    private boolean m_isExecuting = false;

    public APTS_AttachmentTriggerHandler(boolean isExecuting){
        m_isExecuting = isExecuting;
    }

    public void OnBeforeInsert(Object[] newObjects){
        // EXECUTE BEFORE INSERT LOGIC
    }

    public void OnAfterInsert(Object[] newObjects){
        // EXECUTE AFTER INSERT LOGIC
        AutoActivateAgreements((List<Attachment>)newObjects);
    }

    public void OnBeforeUpdate(Object[] oldObjects, Object[] updatedObjects, Map<Id, Object> MapObjectMap){
        // BEFORE UPDATE LOGIC
    }

    public void OnAfterUpdate(Object[] oldObjects, Object[] updatedObjects, Map<Id, Object> MapObjectMap){
        // AFTER UPDATE LOGIC
    }

    public void OnBeforeDelete(Object[] ObjectsToDelete, Map<Id, Object> MapObjectMap){
        // BEFORE DELETE LOGIC
    }

    public void OnAfterDelete(Object[] deletedObjects, Map<Id, Object> MapObjectMap){
        // AFTER DELETE LOGIC
    }

    public void OnUndelete(Object[] restoredObjects){
        // AFTER UNDELETE LOGIC
    }

    public boolean IsTriggerContext{
        get{ return m_isExecuting;}
    }

    private void AutoActivateAgreements(List<Attachment> attachments){
    	Id attachmentId = null;
    	Id agreementId = null;
    	String agrsObjId = Apttus__APTS_Agreement__c.SObjectType.getDescribe().getKeyPrefix();
        System.debug('attachments size '+attachments.size());
    	for (Attachment attch : attachments) {
            System.debug('String.valueOf(attch.parentId) '+String.valueOf(attch.parentId));
    		if (String.valueOf(attch.parentId).startsWith(agrsObjId)
    			&& attch.Name.containsIgnoreCase('_activated')) {
    			
                attachmentId = attch.Id;
    			agreementId = attch.parentId;
                    System.debug('attch Id '+attachmentId+'agmt Id '+agreementId);
    			//break;
                }
        
		if (attachmentId != null
        		&& agreementId != null) {
        		
                List<Id> selectedDocs = new List<Id>{attachmentId};
        		List<Id> removableDocs = new List<Id>{};
        		
                //Activation API
    			Boolean activationResponse = Apttus.AgreementWebService.activateAgreement (agreementId, selectedDocs, removableDocs);

    				// Publishing to content repository.
    				if(!Test.isRunningTest())
                	{
    					Boolean responsefromContentRepo = Apttus_Content.AgreementWebService.publishToContentRepository(agreementId, attachmentId);
                	}
                }
        }
        
    }
}