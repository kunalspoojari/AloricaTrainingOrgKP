@isTest
public class SFDC_DQM_Queue_Test {
	    public static String expiry;   
    
    @isTest static string GenerateSASToken(){
        Datetime utcNow = Datetime.now();
        DateTime currTime = DateTime.newInstance(1970, 1, 1);
        Integer week = 60 * 60 * 24 * 7;        
        Long second = (utcNow.getTime()-currTime.getTime())/1000;
        expiry = String.valueOf(second + week);
        
        String stringToSign = EncodingUtil.urlEncode(Label.Azure_Service_Bus_URI,'UTF-8') + '\n' +expiry; 
        String algorithmName = 'HMACSHA256';
        Blob targetBlob = Blob.valueOf(stringToSign);
        String signature= EncodingUtil.base64Encode(Crypto.generateMac(algorithmName, targetBlob,Blob.valueOf(Label.Azure_Service_Bus_Key)));
        
        List<Object> parameters = new List<Object> {EncodingUtil.urlEncode(Label.Azure_Service_Bus_URI,'UTF-8'), EncodingUtil.urlEncode(signature,'UTF-8'),expiry,Label.Azure_Service_Bus_KeyName };
		String sastoken = String.Format('SharedAccessSignature sr={0}&sig={1}&se={2}&skn={3}',parameters);
        return sastoken;
    }
   private static testMethod void testNew() {
       
       Account acc = new Account();
       acc.Inside_Sales_Owner__c = 'Test';
       acc.Name = 'test account';
       acc.Industry = 'Communications';
       
       insert acc;
       
       Opportunity opp = new Opportunity();
       opp.AccountId = acc.Id;
       opp.Name = 'Test Opportunity';
       opp.CloseDate  = Date.today().addDays(10);
       opp.StageName = 'Qualified Opportunity';
       
       insert opp;
       
       DQMSnapshot__c dqm = new DQMSnapshot__c();
       dqm.opportunity__c = opp.Id;
       
       insert dqm;
       test.startTest();
       
       String DQM_NUMBER = dqm.Name;
         String endPointURL =  Label.Azure_Service_Bus_URI+'/messages';
         String sasToken=GenerateSASToken();
       
       	Test.setMock(HttpCalloutMock.class, new SFDC_DQM_Queue_HttpMock());
       
        Httprequest request = new HttpRequest();
            Http http = new Http();    
            request.setMethod('POST');
            request.setEndpoint(endPointURL);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', sasToken);
            //Check the client certificate
            //request.setClientCertificateName('Sample-Rest-Self-Signed');
            request.setTimeout(120000); 
            request.setBody('{\"dqmNumber\":\"'+DQM_NUMBER+'\"}');          
      
            //Making call to external REST API
            HttpResponse response = http.send(request);  
            String responseVal='DQM Number is saved to Queue Successfully!';
            
            System.debug(responseVal);
            //return responseVal;
            //
         test.stopTest();
    }

}