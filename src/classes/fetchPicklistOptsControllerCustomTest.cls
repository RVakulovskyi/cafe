@isTest
public class fetchPicklistOptsControllerCustomTest {
	
    private static testmethod void testFetching() {
        Test.startTest();
        	List<String> listOFValues = fetchPicklistOptsControllerCustom.getselectOptions('Opportunity', 'PACE_Program_New__c' , 'CA');
        	System.assert(listOFValues.size() > 0, 'List should have size more than 0');
        Test.stopTest();	
    }
}