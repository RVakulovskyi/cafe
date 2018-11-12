@isTest
public class ContractorDupeCatherTest  {

    private static testmethod void testTriggerMethod() {
        RecordType rTypeAcc = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Contractor'];
        Account accFroTest = TestHelperUtility.createAccount(null, null, 'TestAccounts', 'Pre-Contact', 'Channel Partner');    
        accFroTest.RecordTypeId = rTypeAcc.Id;
        Account accFroTest2 = TestHelperUtility.createAccount(null, null, 'TestAccounts', 'Pre-Contact', 'Channel Partner');    
        accFroTest2.RecordTypeId = rTypeAcc.Id;
        insert accFroTest;
        Test.startTest();
            String errorMsg = '';
            try{
                insert accFroTest2;
            } catch(Exception ex) {
                errorMsg = ex.getMessage();
            }
            System.assertEquals(true, errorMsg.contains('Contractor with the same name already exist.'), 'The dupe catcher should throw the error');
        Test.stopTest();
            
    }
}