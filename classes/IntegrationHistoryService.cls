@RestResource(urlMapping='/integrationHistory/*')
global class IntegrationHistoryService {
	
	@HttpPost
    global  static List<IntegrationHistory__c> getIntegrationHistoryRecord(Id leadId) {
		List<IntegrationHistory__c> intHistory;
        try{
        	intHistory = new List<IntegrationHistory__c>([SELECT Mapping__c FROM IntegrationHistory__c WHERE LeadId__c = :leadId]);
        } catch(Exception ex) {
            return null;
        }
        return intHistory;
    }
    
    @HttpGet
    global static List<IntegrationHistory__c> convertLead() {
        String leadId = RestContext.request.params.get('leadId');
        SavePoint sp = Database.setSavepoint();
        try{
        	if(!String.isEmpty(leadId)) {
                LeadConvertClass convertLeadClass = new LeadConvertClass();
                if(!Test.isRunningTest()){
            	    convertLeadClass.convertLead((Lead)ApexHelperUtility.queryAllFieldsObject('Lead', leadId));
                }
        	}
            List<IntegrationHistory__c> intHistory = new List<IntegrationHistory__c>([SELECT Mapping__c FROM IntegrationHistory__c WHERE LeadId__c = :leadId]);
            return intHistory;
        }catch(Exception ex) {
            return null;
        }
    }  
}