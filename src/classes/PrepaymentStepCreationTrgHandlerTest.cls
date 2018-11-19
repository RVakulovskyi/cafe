@isTest
public class PrepaymentStepCreationTrgHandlerTest {
    private static testmethod void testPaymentStepInsert() {
        Test.startTest();
        	Opportunity opportunityToInsert = createDataForTest();
        	List<Prepayment_Step__c> listOfPrepayments = new List<Prepayment_Step__c>([SELECT Id FROM Prepayment_Step__c]);
        	System.assertEquals(5, listOfPrepayments.size(), 'List of records should have size 5 and it is : ' +listOfPrepayments.size());
        Test.stopTest();
    }
    
     private static testmethod void testPaymentStepUpdate() {
        Test.startTest();
        	Opportunity opportunityToInsert = createDataForTest();
         	opportunityToInsert.Prepayment__c = '3% (8), 2% (9), 1% (10)';
         	update opportunityToInsert;
        	List<Prepayment_Step__c> listOfPrepayments = new List<Prepayment_Step__c>([SELECT Id FROM Prepayment_Step__c]);
        	System.assertEquals(3, listOfPrepayments.size(), 'List of records should have size 3 and it is : ' +listOfPrepayments.size());
        Test.stopTest();
    }
	private static Opportunity createDataForTest() {
       Account acc = TestHelperUtility.createAccount(null, null, 'TestAccounts', 'Pre-Contact', 'Channel Partner'); 
       insert acc;
       List<Contact> contacts = new list<Contact>();
       // Create two contacts
       Contact ct1 = TestHelperUtility.createContact(acc.Id, 'Larrys', 'Page');
       contacts.add(ct1);
       insert contacts;
       Opportunity opportunityToInsert = TestHelperUtility.createOpportunityForBonds(acc.Id, contacts[0].Id, null, 'Opportunity Contact Insertion Test', 7.5);
       opportunityToInsert.Prepayment__c = '5% (5), 4% (6), 3% (7), 2% (8), 1% (9)';
       insert opportunityToInsert;
    return opportunityToInsert;
    }
}