@isTest
public class LookUpControllerTest {
	
    private static testmethod void testSearchAccount() {
        Account accToInsert = TestHelperUtility.createAccount(null, null, 'Bank 1', 'Pre-Contact', 'Channel Partner');
        insert accToInsert;
        Contact ct1 = TestHelperUtility.createContact(accToInsert.Id, 'Larrys', 'Page');
        insert ct1;
        Test.startTest();
        	List<sObject> listOfAccounts = LookUpController.fetchLookUpValues('Bank 1', 'Account');
        	System.assertEquals(listOfAccounts.size() > 0, true, 'Should find Account dupe');
        	List<String> listOfAccRecordTypeLabels = LookUpController.fetchRecordTypeValues();
        	System.assertEquals(listOfAccRecordTypeLabels.size() > 0, true, 'List should be not empty');
        	Id accRTypeId = LookUpController.getRecTypeId('Public Account');
        	System.assertEquals(accRTypeId, [SELECT Id FROM RecordType WHERE DeveloperName = 'Public_Account'].Id, 'Record Types should be equal');
        	ct1.FirstName = 'TestF';
        	LookUpController.saveContact(ct1);
        	System.assertEquals('TestF', ct1.FirstName, 'Update should be successfull');
       		accToInsert.Name = 'Laris';
        	accToInsert.ID = null;
        	LookUpController.saveAccountAndUpdateContact(ct1, accToInsert, 'Public Account');
        	System.assert([SELECT Id FROM Account WHERE Name = 'Laris'].size() > 0, 'Account should be created');      
        Test.stopTest();
    }
}