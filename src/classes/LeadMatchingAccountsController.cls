public with sharing class LeadMatchingAccountsController {
    private final Lead lead;
    public List<SelectOption> result {get; set;}
    public String selectedResult {get;set;}
    public String redirectUrl {public get; private set;}
    public Boolean shouldRedirect {public get; private set;}
    private ApexPages.StandardController sc;
    
    public LeadMatchingAccountsController(ApexPages.StandardController stdController){
        result = new List<SelectOption>();
        this.sc = stdController;
        lead = [SELECT Id, FirstName, LastName, Possible_matched_Accounts__c FROM Lead 
                WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
        getAccNames(lead.Possible_matched_Accounts__c);
    }
    
    public PageReference save(){
        Try{
        Lead oldLead = new Lead();
        oldLead = (Lead)sc.getRecord();
        oldLead.Company = selectedResult;
        update oldLead;
        shouldRedirect = true;
        redirectUrl = sc.view().getUrl();
        }catch (Exception e){
            e.getMessage();
            system.debug(e.getMessage());
        }
      
        return null;
        
    } 
    public void getAccNames(String accNames){
        
        if(String.isEmpty(accNames)){
        result.add(new SelectOption('','---None---'));
        }else{
        List<String> accNamesList = accNames.split(';');
            result.add(new SelectOption('','---None---'));
        for (String picklistEntry : accNamesList){
            result.add(new SelectOption(picklistEntry,picklistEntry));
        }    
        }
        
    }
    
}