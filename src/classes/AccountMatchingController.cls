//test comment for CI
public without sharing class AccountMatchingController {
    private final Account acc;
    public List<SelectOption> result {get; set;}
    public String selectedResult {get;set;}
    public String redirectUrl {public get; private set;}
    public Boolean shouldRedirect {public get; private set;}
    private ApexPages.StandardController sc;
    
    public AccountMatchingController(ApexPages.StandardController stdController){
        result = new List<SelectOption>();
        this.sc = stdController;
        acc = [SELECT Id, Name, Possible_matched_Accounts__c FROM Account 
                WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        getAccNames(acc.Possible_matched_Accounts__c);
    }
    
    public PageReference save(){
        Try{
        Account oldAcc = new Account();
        oldAcc = (Account)sc.getRecord();
        oldAcc.Name = selectedResult;
        update oldAcc;
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