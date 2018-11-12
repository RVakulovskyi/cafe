global class OppStageBatch implements Database.Batchable<sObject>{
    global Map<String, Decimal> mapOfProbability;
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id,StageName,Probability FROM Opportunity';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        mapOfProbability = getMappedProbability();
        List<Opportunity> listToUpdate = new List<Opportunity>();
        for (Opportunity oppItem : scope) {
            if(!String.isEmpty(oppItem.StageName) && mapOfProbability.containsKey(oppItem.StageName) && oppItem.Probability!= null && mapOfProbability.get(oppItem.StageName) != oppItem.Probability ) {
                oppItem.Probability = mapOfProbability.get(oppItem.StageName);
                listToUpdate.add(oppItem);
            }
        }
        if(listToUpdate.size() > 0) {
            update listToUpdate;
        }
    }  
    
    global void finish(Database.BatchableContext BC)
    {
    }
    
    private Map<String, Decimal> getMappedProbability() {
        Map<String, Decimal> probabilityStageNameMap = new Map<String, Decimal>();
        for (OpportunityStage oppStage : [SELECT MasterLabel, DefaultProbability FROM OpportunityStage]) {
      		probabilityStageNameMap.put(oppStage.MasterLabel, oppStage.DefaultProbability);
     	}	
        return probabilityStageNameMap;
    }

}