@isTest
public class GenericLookUpControllerTest {
	
    public static testmethod void testGenericLookup(){
        Account insertAcc = new Account(Name = 'Test');
        insert insertAcc;
        Test.startTest();
        	List<sObject> listOfResuts = GenericLookUpController.fetchLookUpValues('Test', 'Account');
        	System.assert(listOfResuts.size() > 0, 'List should have sie more than 0');
        Test.stopTest();
    }
}