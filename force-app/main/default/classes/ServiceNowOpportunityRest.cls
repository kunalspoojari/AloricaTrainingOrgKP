/*
*   @Author: Ariel Tribunal
*   @Date: 8/12/2019
*   @Apex Name: ServiceNowOpportunityRest
*   @Description: This class is use for Opportunity Rest webservice
*
*/
@RestResource(urlMapping='/Opportunity/*')
global with sharing class ServiceNowOpportunityRest {

	@HttpPatch
	global static void updateOpportunityFields() {
		RestRequest request = RestContext.request;
		Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        
        Opportunity thisOpp = new Opportunity();
        thisOpp.put('Id', params.get('u_opportunity_id'));
		thisOpp.put('ServiceNow_Project_ID__c', params.get('u_project_id'));
		
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type','application/json');
        String message, errorCode;
        try {
        	update thisOpp;
            message = 'Opportunity Project ID updated successfully';
        } catch (Exception e) {
            res.statusCode = 500;
            message = e.getMessage();
            errorCode = 'INVALID_OPPORTUNITY_ID';
        }
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        gen.writeStartObject();
        	gen.writeStringField('message',message);
            if(errorCode != null){
                gen.writeStringField('errorCode',errorCode);
            }
        gen.writeEndObject();
        gen.writeEndArray();
        res.responseBody = blob.valueOf(gen.getAsString());
	}

}