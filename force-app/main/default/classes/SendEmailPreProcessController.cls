/**
 *  Apttus Contract Management
 *  SendEmailPreProcessController
 *   
 *  @2016 Apttus Inc. All rights reserved.
 */
public with sharing class SendEmailPreProcessController {
    
    public static final String PARAM_ACTION = 'action';
    public static final String PARAM_ID = 'id';
        
    public ID agreementId { get; private set; }
    public String userAction { get; private set; }    
    
    /**
     * Class Constructor specifying initial values
     * @param stdController the standard controller
     */
    public SendEmailPreProcessController(ApexPages.StandardController stdController) {   
        Map<String, String> params = ApexPages.currentPage().getParameters();
        
        this.agreementId = (ID) String.escapeSingleQuotes(params.get(PARAM_ID));        
        this.userAction = String.escapeSingleQuotes(params.get(PARAM_ACTION));
    }        
}