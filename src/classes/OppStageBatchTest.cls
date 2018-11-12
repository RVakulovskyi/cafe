@isTest
public class OppStageBatchTest {
    private static testmethod void testBatch() {
       	Account acc = TestHelperUtility.createAccount(null, null, 'TestAccounts', 'Pre-Contact', 'Channel Partner');     
       	List<Contact> contacts = new list<Contact>();
       	// Create two contacts
       	Contact ct1 = TestHelperUtility.createContact(acc.Id, 'Larrys', 'Page');
       	contacts.add(ct1);
       	insert contacts;
       	Opportunity opportunityToInsert = TestHelperUtility.createOpportunityForBonds(acc.Id, contacts[0].Id, null, 'Opportunity Contact Insertion Test', 7.5);
       	opportunityToInsert.StageName = 'Pre-Qualified Lead';
       	insert opportunityToInsert;
       	Test.startTest();
       		OppStageBatch batchToTest = new OppStageBatch();
       		Database.executeBatch(batchToTest);
    	Test.stopTest();
    }

}