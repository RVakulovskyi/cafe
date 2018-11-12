/**
12.02.2018 Rodion Vakulovskyi createdTriggerHandler
**/
public class BondRollupHandler {
    public static Boolean Flag = true;
	public static void onAfterUpdate(List<Opportunity> inputNewList, Map<Id, Opportunity> inputOldMap) {
        List<Opportunity> opportunities = new List<Opportunity>();
		for(Opportunity opp : inputNewList){
        	if((opp.Bond_Total__c != inputOldMap.get(opp.id).Bond_Total__c)||
            	(opp.Bond__c != inputOldMap.get(opp.id).Bond__c)||
            	(opp.Bond_Cost__c != inputOldMap.get(opp.id).Bond_Cost__c)||
            	(opp.Parcel_Count__c != inputOldMap.get(opp.id).Parcel_Count__c)) {
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
        List<RollUpSummaryUtility.fieldDefinition> fieldDefinitions1 = new List<RollUpSummaryUtility.fieldDefinition> {
																		new RollUpSummaryUtility.fieldDefinition('SUM', 'Bond_Total__c', 'Bond_Amount__c')
            														   };
    	List<RollUpSummaryUtility.fieldDefinition> fieldDefinitions2 = new List<RollUpSummaryUtility.fieldDefinition> {
                    													new RollUpSummaryUtility.fieldDefinition('SUM', 'Contribution_to_Bond_Rate__c', 'Blended_Coupon__c')
            														   };


    	List<RollUpSummaryUtility.fieldDefinition> fieldDefinitions3 = new List<RollUpSummaryUtility.fieldDefinition> {
               															 new RollUpSummaryUtility.fieldDefinition('SUM', 'Bond_Cost__c', 'Bond_Cost__c')
                													   };

    	List<RollUpSummaryUtility.fieldDefinition> fieldDefinitions4 = new List<RollUpSummaryUtility.fieldDefinition> {
            															 new RollUpSummaryUtility.fieldDefinition('SUM', 'Parcel_Count__c', 'AC_Count__c')
        															   };

		RollUpSummaryUtility.ObjectDefination objDef = new RollUpSummaryUtility.ObjectDefination('Opportunity','Bond__c','Bond__c','',null);
    	new RollUpSummaryUtility().rollUp(fieldDefinitions1, objDef , inputList);
    	new RollUpSummaryUtility().rollUp(fieldDefinitions2, objDef , inputList);
    	new RollUpSummaryUtility().rollUp(fieldDefinitions3, objDef , inputList);
    	new RollUpSummaryUtility().rollUp(fieldDefinitions4, objDef , inputList);
    }
}