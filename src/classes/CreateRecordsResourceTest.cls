@isTest
public class CreateRecordsResourceTest {
    
    private static testmethod void createAccountTest() {
   //As Per Best Practice it is important to instantiate the Rest Context 
   		RestRequest req = new RestRequest(); 
   		RestResponse res = new RestResponse();
   		req.requestURI = '/services/apexrest/createRecords/createRecord/';  //Request URL
   		req.httpMethod = 'POST';
        String JsonMsg = '{"OBJNAME" : "Account", "ACCNAME" : "Test"}';
   		req.requestBody = Blob.valueof(JsonMsg);
   		RestContext.request = req;
   		RestContext.response= res;
        Test.startTest();
   			CreateRecordsResponse resp = CreateRecordsResource.createRecord();
        	System.assert(resp.RESULTCODE.contains('200'), 'Operation should be successfull');
        Test.stopTest();
    }
    
    private static testmethod void createContactTest() {
        RestRequest req = new RestRequest(); 
   		RestResponse res = new RestResponse();
   		req.requestURI = '/services/apexrest/createRecords/createRecord/';  //Request URL
   		req.httpMethod = 'POST';
        String JsonMsg = '{"OBJNAME" : "Contact", "LASTNAME" : "Test"}';
   		req.requestBody = Blob.valueof(JsonMsg);
   		RestContext.request = req;
   		RestContext.response= res;
        Test.startTest();
   			CreateRecordsResponse resp = CreateRecordsResource.createRecord();
        	System.assert(resp.RESULTCODE.contains('200'), 'Operation should be successfull');
        Test.stopTest();
    }
    
    private static testmethod void updateContactTest() {
        Account a1 = TestHelperUtility.createAccount(null, null, 'Bank 1', 'Pre-Contact', 'Channel Partner');
        Contact ct1 = TestHelperUtility.createContact(a1.Id, 'Larrys', 'Page');
        RestRequest req = new RestRequest(); 
   		RestResponse res = new RestResponse();
   		req.requestURI = '/services/apexrest/createRecords/createRecord/';  //Request URL
   		req.httpMethod = 'POST';
        String JsonMsg = '{"OBJNAME" : "Contact", "LASTNAME" : "Page", "FIRSTNAME" : "Larrys","ACCNAME" : "Bank 1"}';
   		req.requestBody = Blob.valueof(JsonMsg);
   		RestContext.request = req;
   		RestContext.response= res;
        Test.startTest();
   			CreateRecordsResponse resp = CreateRecordsResource.createRecord();
            System.assert(resp.RESULTCODE.contains('200'), 'Operation should be successfull');
        Test.stopTest();
    }
    
    private static testmethod void updateAccountTest() {
        Account a1 = TestHelperUtility.createAccount(null, null, 'Bank 1', 'Pre-Contact', 'Channel Partner');
        RestRequest req = new RestRequest(); 
   		RestResponse res = new RestResponse();
   		req.requestURI = '/services/apexrest/createRecords/createRecord/';  //Request URL
   		req.httpMethod = 'POST';
        String JsonMsg = '{"OBJNAME" : "Account", "ACCNAME" : "Bank 1"}';
   		req.requestBody = Blob.valueof(JsonMsg);
   		RestContext.request = req;
   		RestContext.response= res;
        Test.startTest();
   			CreateRecordsResponse resp = CreateRecordsResource.createRecord();
            System.assert(resp.RESULTCODE.contains('200'), 'Operation should be successfull');
        Test.stopTest();
    }
    
      private static testmethod void errorTest() {
        Account a1 = TestHelperUtility.createAccount(null, null, 'Bank 1', 'Pre-Contact', 'Channel Partner');
        RestRequest req = new RestRequest(); 
   		RestResponse res = new RestResponse();
   		req.requestURI = '/services/apexrest/createRecords/createRecord/';  //Request URL
   		req.httpMethod = 'POST';
        String JsonMsg = '{"OBJNAME" : "Contact", "LASTNAME" : ""}';
   		req.requestBody = Blob.valueof(JsonMsg);
   		RestContext.request = req;
   		RestContext.response= res;
        Test.startTest();
   			CreateRecordsResponse resp = CreateRecordsResource.createRecord();
            System.assert(resp.RESULTCODE.contains('400'), 'Operation should be unsuccessfull');
        Test.stopTest();
    }
}