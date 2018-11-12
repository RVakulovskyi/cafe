public class PrepaymentStepCreationTrgHandler {
    
    public static void onAfterInsert(List<Opportunity> inputList) {
        List<Opportunity> listToOperate = new List<Opportunity>();
        for(Opportunity itemOpp : inputList) {
            if(!String.isEmpty(itemOpp.Prepayment__c)) {
               listToOperate.add(itemOpp);
            }
        }
        if(listToOperate.size() > 0) {
           processCreation(inputList); 
        }
    }
    
    public static void onAfterUpdate(List<Opportunity> inputList, Map<Id, Opportunity> oldMap) {
        List<Opportunity> listToOperate = new List<Opportunity>();
        for(Opportunity itemOpp : inputList) {
            if(itemOpp.Prepayment__c != oldMap.get(itemOpp.Id).Prepayment__c) {
            	listToOperate.add(itemOpp);
            }
        }
        if(listToOperate.size() > 0) {
           processCreation(inputList); 
        }
    }
    
    private static void processCreation(List<Opportunity> inputList) {
		Set<Id> setOfIds = new Set<Id>();
        List<Prepayment_Step__c> listToInsert = new List<Prepayment_Step__c>();
        for(Opportunity oppItem : inputList) {
            setOfIds.add(oppItem.Id);
            if(oppItem.Prepayment__c != 'Yield Maintenance (special)'){
            	List<String> listOfPicklistValues = oppItem.Prepayment__c.split(',');
            	for(Integer i = 0; i < listOfPicklistValues.size(); i ++) {
                	String itemPrep = listOfPicklistValues[i];
                    Prepayment_Step__c prepItemFormed = new Prepayment_Step__c();
                    if(i == listOfPicklistValues.size() -1) {
                        Decimal yearEnd = (oppItem.Loan_Term__c != null) ? oppItem.Loan_Term__c : 20;
                        prepItemFormed = formPrepaymentStep(yearEnd, itemPrep.substring(0,itemPrep.lastIndexOf('%')), i + 1, oppItem.Id);
                    } else {
                        prepItemFormed = formPrepaymentStep(itemPrep.substring(itemPrep.indexOf('(') + 1,itemPrep.indexOf(')')), itemPrep.substring(0,itemPrep.lastIndexOf('%')), i + 1, oppItem.Id);     
                    }
                	listToInsert.add(prepItemFormed);
            	}
            } else {
                listToInsert.add(new Prepayment_Step__c(Opportunity__c = oppItem.Id, Prepayment_Penalty__c = 0, Prepayment_Step_Year_End__c = 0, Prepayment_Step__c  = '1', Yield_Maintenance__c = true));
            }
        } 
        processDelete(setOfIds);
        if(listToInsert.size() >0) {
            insert listToInsert;
        }
    }
    
    private static Prepayment_Step__c formPrepaymentStep(Object inputYearEnd, Object inputPenalty, Integer inputStep, Id inputOppId) {
        Prepayment_Step__c stepToInsert = new Prepayment_Step__c(
            													Prepayment_Penalty__c = Double.valueOf(inputPenalty),
            													Prepayment_Step__c = String.valueOf(inputStep),
            													Prepayment_Step_Year_End__c = Integer.valueOf(inputYearEnd),
            													Opportunity__c = inputOppId
        														);
    return stepToInsert;
    }
    
    private static void processDelete(Set<Id> inputSet) {
        List<Prepayment_Step__c> listToDelete = new List<Prepayment_Step__c>([SELECT Id FROM Prepayment_Step__c WHERE Opportunity__c IN : inputSet]);
        if(listToDelete.size() > 0) {
            delete listToDelete;
        }
    }

}