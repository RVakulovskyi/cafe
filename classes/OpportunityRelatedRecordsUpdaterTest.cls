@isTest
public class OpportunityRelatedRecordsUpdaterTest {
    private static testmethod void testProcessUpdate() {
        Opportunity oppForTest = createDataForTest();
        Test.startTest();
        	oppForTest = [SELECT Id, CreatedDate, LastUpdateChildRecord_Date__c  FROM opportunity];
        	System.assertEquals(oppForTest.LastUpdateChildRecord_Date__c , oppForTest.CreatedDate, 'Last Updated field and Created/Last modified date should be equal');
        Test.stopTest();
    }
    
    private static testmethod void testProcessUpdateAdditional() {
        Opportunity oppForTest = createDataForTest();
        Test.startTest();
        	oppForTest = [SELECT Id, CreatedDate, LastUpdateChildRecord_Date__c  FROM opportunity];
        	Parcel__c testParcel = TestHelperUtility.createParcel(oppForTest.Id,'TestParcel');
        	insert testParcel;
        	testParcel = [SELECT id, LastModifiedDate FROM Parcel__c];
        	System.assertEquals(Date.valueOf(oppForTest.LastUpdateChildRecord_Date__c), Date.valueOf(testParcel.LastModifiedDate), 'Last Updated field and Created/Last modified date should be equal');
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
       insert opportunityToInsert;
    return opportunityToInsert;
    }
}