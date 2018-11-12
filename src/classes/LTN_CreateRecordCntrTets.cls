@isTest
public class LTN_CreateRecordCntrTets {
	
    private static testmethod void testSaveAcc() {
        Account accToInsert = TestHelperUtility.createAccount(null, null, 'Bank 1', 'Pre-Contact', 'Channel Partner');
        Test.startTest();
        	LTN_CreateRecordCntr.saveAccountCntr(accToInsert);
        	System.assert([SELECT Id FROM Account].size() > 0, 'Account should be created');
        Test.stopTest();
    }
    
    private static testmethod void testSaveContact() {
        Account accToInsert = TestHelperUtility.createAccount(null, null, 'Bank 1', 'Pre-Contact', 'Channel Partner');
        insert accToInsert;
        Contact ct1 = TestHelperUtility.createContact(accToInsert.Id, 'Larrys', 'Page');
        Test.startTest();
        	LTN_CreateRecordCntr.saveContactCntr(ct1);
        	System.assert([SELECT Id FROM Contact].size() > 0, 'Contact should be created');
        Test.stopTest();
    }
    
    private static testmethod void testSaveLead() {
        Account accToInsert = TestHelperUtility.createAccount(null, null, 'Bank 1', 'Pre-Contact', 'Channel Partner');
        insert accToInsert;
        Contact ct1 = TestHelperUtility.createContact(accToInsert.Id, 'Larrys', 'Page');
        insert ct1;
        Lead leadToInsert = TestHelperUtility.createLead();
        leadToInsert.Account_Name__c =  accToInsert.Id;
        leadToInsert.Property_Owner_Main_Contact__c = ct1.Id;
        Test.startTest();
        	LTN_CreateRecordCntr.saveLeadCntr(leadToInsert);
        	System.assert([SELECT Id FROM Lead].size() > 0, 'Lead should be created');
        Test.stopTest();
    }
    
    private static testmethod void testOtherMethods() {
        Test.startTest();
        	List<String> listOfRecordTypes = LTN_CreateRecordCntr.fetchRecordTypeValues();
        	System.assert(listOfRecordTypes.size() > 0, 'ListShould be more than 0');
            Id recordTypeId = LTN_CreateRecordCntr.getRecTypeId(listOfRecordTypes[0]);
            System.assert(recordTypeId != null, 'We should receive recordType Id');
        Test.stopTest();
    }
}