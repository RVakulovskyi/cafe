public class LeadConvertTriggerHandler {
    public static void onAfterUpdate(List<Lead> inputList) {
       // executeConvertion(inputList);
    }
    /*
	private static void executeConvertion(List<Lead> listOfLeads) {
        LeadConvertClass leadConvert = new LeadConvertClass();
        String queryString = 'SELECT ';
		SObjectType customObect = Schema.getGlobalDescribe().get('Lead');
		Map<String,Schema.SObjectField> mfields = customObect.getDescribe().fields.getMap();
		for(String itemString : mfields.keySet()) {
			queryString+= itemString + ',';
		}
        queryString = queryString.substring(0, queryString.length() - ','.length()) + ' FROM Lead';
        for(Lead itemLead : Database.query(queryString)){
            Savepoint sp;
            try{
                sp = Database.setSavepoint();
        		leadConvert.convertLeadFromTrigger(itemLead);
            } catch (Exception ex) {
                Database.rollback(sp);
                itemLead.addError(ex.getMessage());
            }
        }
    }*/
}