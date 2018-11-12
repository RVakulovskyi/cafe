/**
12.02.2018 Rodion Vakulovskyi createdTriggerHandler
**/
public class BondCostRollupHandler {
	
    public static void onAfterUpdate(List<Opportunity> inputNewList, Map<Id, Opportunity> inputOldMap) {
        List<Opportunity>  opportunities =  new  List<Opportunity>();
     	for(Opportunity opp : inputNewList){
                if((opp.Bond_Cost__c != inputOldMap.get(opp.id).Bond_Cost__c)||
                        (opp.Bond__c != inputOldMap.get(opp.id).Bond__c)) {
                    opportunities.add(opp);
                }
        }
        processAfter(opportunities);
    }
    
    public static void onAfterInsert(List<Opportunity> inputNewList) {
        processAfter(inputNewList);
    }
    
    public static void onAfterUndelete(List<Opportunity> inputNewList) {
        processAfter(inputNewList);
    }
    
    public static void onAfterDelete(List<Opportunity> inputOldList) {
        processAfter(inputOldList);
    }
    
    private static void processAfter(List<Opportunity> inputList) {
        List<RollUpSummaryUtility.fieldDefinition> fieldDefinitions1 = new list<RollUpSummaryUtility.fieldDefinition> {
                    													new RollUpSummaryUtility.fieldDefinition('SUM', 'Bond_Cost__c', 'Bond_Cost__c')
            													  };
   		RollUpSummaryUtility.ObjectDefination objDef = new RollUpSummaryUtility.ObjectDefination('Opportunity','Bond__c','Bond__c','',null);
    	new RollUpSummaryUtility().rollUp(fieldDefinitions1, objDef , inputList);  
    }
}