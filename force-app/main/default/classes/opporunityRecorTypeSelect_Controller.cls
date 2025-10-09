public class opporunityRecorTypeSelect_Controller{
    
    public List<SelectOption> opts {get;set;}
    public Id recTypeId {get;set;}
    Id accid;
    public opporunityRecorTypeSelect_Controller(ApexPages.StandardController controller) {
        accid = ApexPages.currentPage().getParameters().get('accid');
    }

    public List<SelectOption> getmyOptions(){
        opts = new List<SelectOption>();
        //for(RecordType rts : [Select Id, DeveloperName, Name From RecordType Where SObjectType = 'Opportunity' and DeveloperName in ('Pricing','Qualified_Lead')]) {
        for(RecordType rts : [Select Id, DeveloperName, Name From RecordType Where SObjectType = 'Opportunity' and DeveloperName in ('Lightning','Classic')]) {
            opts.add(new SelectOption(rts.id,rts.name));
        }
        return opts;
    }

    public PageReference cont(){
       if(accid != null){
           PageReference reRend = new PageReference('/006/e?retURL=%2F006%2Fo&RecordType='+ recTypeId +'&ent=Opportunity'+'&accid='+accid);
           reRend.getParameters().put('nooverride','1');
           return reRend;
       }else{
         PageReference reRend = new PageReference('/006/e?retURL=%2F006%2Fo&RecordType='+ recTypeId +'&ent=Opportunity');
         reRend.getParameters().put('nooverride','1');  
         return reRend;
       }
        
        
    }
}