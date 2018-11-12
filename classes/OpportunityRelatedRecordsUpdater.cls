public class OpportunityRelatedRecordsUpdater {
    public static Boolean FlagForUpdate = true;
    public static void updateChildDate(Set<Id> setOfIds) {
        if(FlagForUpdate){
        	List<Opportunity> listOfUpdatedOpp = new List<Opportunity>();
        	for(Opportunity itemOpportunity : [SELECT Id, LastModifiedDate, LastUpdateChildRecord_Date__c FROM Opportunity WHERE Id IN : setOfIds]) {
            	itemOpportunity.LastUpdateChildRecord_Date__c = DateTime.now();
            	listOfUpdatedOpp.add(itemOpportunity);
        	}
        	update listOfUpdatedOpp;
    	}
    }
    
    public static void updateOppField(List<Opportunity> inputList) {
        for(Opportunity item : inputList) {
            item.LastUpdateChildRecord_Date__c = item.LastModifiedDate;
        }
    }
}