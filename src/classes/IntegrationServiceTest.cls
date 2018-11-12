@isTest
public class IntegrationServiceTest {
   
    private static testmethod void testRestGet() {   
        Lead leadToInsr = TestHelperUtility.createLead();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
        insert leadToInsr;
        Test.stopTest();
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/integrationHistory/'; 
            req.addParameter('leadId', leadToInsr.id);
            req.httpMethod = 'GET'; 
            RestContext.request = req;
            RestContext.response = res;
            Semaphore.isTest = false;
            List<IntegrationHistory__c> testStrList = IntegrationHistoryService.convertLead();
         //   System.assert(testStrList.size() > 0, 'history list should not be empty');
        	testStrList = IntegrationHistoryService.getIntegrationHistoryRecord(leadToInsr.Id);
        	//System.assert(testStrList.size() > 0, 'history list should not be empty'); 
    }

}