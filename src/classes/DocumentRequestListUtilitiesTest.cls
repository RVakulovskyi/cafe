/*
* @author Conga
* @author Joseph Markey
* @version 1.00
* @description describes the DocumentRequestListUtilitiesTest class
*/
@isTest
public with sharing class DocumentRequestListUtilitiesTest {
    
    public static testMethod void testDocumentRequestListUtilities() {
        // stage test data
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        Account a = TestHelperUtility.createAccount('Partnership', 'Limited Partnership (LP)', 'Test Account', null, null);
        insert a;
        Account a2 = TestHelperUtility.createAccount('Limited Liability Company', null, 'Test Account', null, null);
        insert a2;
        Account a3 = TestHelperUtility.createAccount('Trust', null, 'Test Account', null, null);
        insert a3;
        Account a4 = TestHelperUtility.createAccount('Partnership', 'General Partnership (GP)', 'Test Account', null, null);
        insert a4;
        User u = TestHelperUtility.createUser('standt', 'salesforce@getconga.com', 'TestFirst', 'TestLastName', 'testUser', p.Id, 'testUser'+UserInfo.getOrganizationId()+'@testorg.com');
       	insert u;
       	List<DRL_Template_Item__c> itemList = new List<DRL_Template_Item__c>();
        for(Integer i=0; i<53; i++) {
        	String drlNumber = String.valueOf(i);
        	if(i<10) {
        		drlNumber = '0'+drlNumber;
        	}
            DRL_Template_Item__c templateItem = TestHelperUtility.createDRLTemp('5.1', 'Borrowing Resolution', 'DRL-00', drlNumber, 'Provided by CleanFund. Executed by Property Owner', 'CleanFund', 'Stage 1 (Term Sheet)');
        	itemList.add(templateItem);
        }
        insert itemList;
        Test.startTest();
        	Opportunity o = TestHelperUtility.createOpportunity(a.Id, 'Test Opportunity', 'PPA', 'Pre-Qualified Lead', 'TX', u.Id, 'February', 'February', 'February', null, System.today(), null, null);
        	insert o;
        	Opportunity o2 = TestHelperUtility.createOpportunity(a2.Id, 'Test Opportunity', 'PPA', 'Pre-Qualified Lead', 'TX', u.Id, 'February', 'February', 'February', null, System.today(), null, null);
        	insert o2;
        	Opportunity o3 = TestHelperUtility.createOpportunity(a3.Id, 'Test Opportunity', 'PPA', 'Pre-Qualified Lead', 'TX', u.Id, 'February', 'February', 'February', null, System.today(), null, null);
        	insert o3;
        	Opportunity o4 = TestHelperUtility.createOpportunity(a4.Id, 'Test Opportunity', 'PPA', 'Pre-Qualified Lead', 'TX', u.Id, 'February', 'February', 'February', null, System.today(), null, null);
        // execute the test
        
        // test the PrintUtilities methods
        	ApexPages.StandardController stdController = new ApexPages.StandardController(o);
        	DocumentRequestListUtilities drlu = new DocumentRequestListUtilities(stdController);
        	DocumentRequestListUtilities.generateDocumentRequestList(o.Id); // no assert as method returns null
        	DocumentRequestListUtilities.generateDocumentRequestList(o2.Id); // no assert as method returns null
        	DocumentRequestListUtilities.generateDocumentRequestList(o3.Id); // no assert as method returns null
        Test.stopTest();
    }
    
}