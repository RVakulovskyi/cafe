public class ExternalPartyExtCntr {
	public ExternalPartyRelation__c inputExtParty{get;set;}
    public String redirectionId{get;set;}
    
    public ExternalPartyExtCntr() {
		String oppId = ApexPages.currentPage().getParameters().get('oppId');
        inputExtParty = new ExternalPartyRelation__c();
        if(!String.isEmpty(oppId)) {
            inputExtParty.Opportunity__c = oppId;
            redirectionId = oppId;
        }
    }
    
    public PageReference save() {
        try{
        	upsert inputExtParty;
        return new PageReference('/' + redirectionId);
        } catch(Exception ex) {
          	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        return null;  
        }
    }
    
    public PageReference close() {
    return new PageReference('/' + redirectionId);
    }
}