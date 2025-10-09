/*
*   @Author: Ariel Tribunal
*   @Date: 8/6/2019
*   @Apex Name: ServiceNowCallout
*   @Description: This class is use for Service Now callout
*
*/
public class ServiceNowCallout {
	
    // Invocable Service Now API
    @InvocableMethod(label='invoServiceNowCall' description='Opportunity ids, information send to Service Now API.')
    public static void invoServiceNowCall (list<Id> lOppId){
        if(lOppId.isEmpty()){
            system.debug('ERROR invoServiceNowCall(): Empty list<Id> lOppId parameter');
            return;
        }
        passOppData(lOppId);
    }
    
    // send opportunity data to Service Now
    @future(Callout=true)
    public static void passOppData(list<Id> loppIdco) {
        String resstatus = 'passOppData() ' + string.valueOf(system.now()) + ' ';
        list<opportunity> loppco = [select ServiceNow_Response__c,Account_Name__c,CapexApprovedAmount__c,
                                    Capex_Number__c,Circuit_Order_Required__c,CS_Assignee__r.Email,Deal_Type__c,
                                    Description,Existing_Client_New_Site__c,IT_Assignee__r.Email, id,  Name,
                                    CloseDate,VerbalWinDate__c,
                                    Vertical__c
                                    from opportunity 
                                    where id IN: loppIdco 
                                    AND (Deal_Type__c = 'New Logo'
                                         OR Deal_Type__c = 'Incremental New LOB'
                                         OR Deal_Type__c = 'Incremental Same LOB'
                                         OR Deal_Type__c = 'Geo Optimization'
                                         OR Deal_Type__c = 'Alorica Digital'
                                         OR Deal_Type__c = 'New Channel'
                                         OR Deal_Type__c = 'New Geography')
                                    limit 100]; // set limit to 100 Callout per transaction.
        if(loppco.isEmpty()){
            system.debug(resstatus + ':No record found or Deal Type for Renewal. OppIds= ' + loppIdco);
            return;
        }
        
        string password= Label.SN_Password_Api;
        string username = Label.SN_Username_Api;
        Blob headerValue = Blob.valueOf(username + ':' +password);
        string sAuth = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        HttpRequest req = new HttpRequest();
        req.setEndPoint(Label.SN_PassOpp_Endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization', sAuth);
        req.setTimeout(120000);
        
        for(opportunity co: loppco) {
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
                gen.writeStringField('u_account_name',co.Account_Name__c);
                gen.writeStringField('u_capex_approved_amount',(co.CapexApprovedAmount__c == null? '' : string.valueOf(co.CapexApprovedAmount__c)));
                gen.writeStringField('u_capex_number',(co.Capex_Number__c == null? '' : co.Capex_Number__c));
                gen.writeStringField('u_circuit_order_required',(co.Circuit_Order_Required__c? 'true' : 'false'));
                gen.writeStringField('u_cs_assignee',(co.CS_Assignee__c == null? '' : co.CS_Assignee__r.Email));
                gen.writeStringField('u_deal_type',(co.Deal_Type__c == null? '' : co.Deal_Type__c));
                gen.writeStringField('u_description',(co.Description == null? '' : co.Description));
                gen.writeStringField('u_existing_client_new_site',(co.Existing_Client_New_Site__c? 'true' : 'false'));
                gen.writeStringField('u_it_assignee',(co.IT_Assignee__c == null? '' : co.IT_Assignee__r.Email));
                gen.writeStringField('u_opportunity_id',co.Id);
                gen.writeStringField('u_opportunity_name',co.Name);
                gen.writeStringField('u_target_production_go_live_date',
                                     (co.VerbalWinDate__c == null? '' : 
                                      string.valueOf(co.VerbalWinDate__c)));
                gen.writeStringField('u_target_training_launch_date',
                                     (co.CloseDate == null? '' : 
                                      string.valueOf(co.CloseDate)));
                gen.writeStringField('u_vertical',(co.Vertical__c == null? '' : co.Vertical__c));
            gen.writeEndObject();
            
            //system.debug(gen.getAsString());
            
            req.setBody(gen.getAsString());
            
            httpResponse res = new http().send(req);
            
            integer vStatusCode = res.getStatusCode();
            resstatus = resstatus + vStatusCode + ' ' + res.getStatus();
            co.ServiceNow_Response__c = resstatus;

            //system.debug(resstatus);
            //co.ServiceNow_Response__c = co.Deal_Type__c;
             
        
        }
        update loppco;
    }
}