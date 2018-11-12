/**
*OpportunityLienTriggerHandlerTest
*15.02.2018 Rodion Vakulovskyi updated class
**/
@isTest
public class OpportunityLienTriggerHandlerTest {

    public static testMethod void testInsertRecords() {
        List<Opportunity> opportunities = new List<Opportunity>();
        List<Account> accounts = new List<Account>();
        List<Lien__c> liens = new List<Lien__c>();
        Opportunity o1 = TestHelperUtility.createOpportunity(null, 'Opportunity 1', null, 'Pre-Qualified Lead', null, null, null, null, null, 'TBD',Date.today()+2, 50.00, 24);
        Opportunity o2 = TestHelperUtility.createOpportunity(null, 'Opportunity 2', null, 'Pre-Qualified Lead', null, null, null, null, null, 'TBD',Date.today()+2, 50.00, 24);
        opportunities.add(o1);
        opportunities.add(o2);
        insert opportunities;
        TestHelperUtility.createAccount(null, null, 'Bank 1', 'Pre-Contact', 'Channel Partner');
        Account a1 = TestHelperUtility.createAccount(null, null, 'Bank 1', 'Pre-Contact', 'Channel Partner');
        Account a2 = TestHelperUtility.createAccount(null, null, 'Bank 2', 'Pre-Contact', 'Channel Partner');
        Account a3 = TestHelperUtility.createAccount(null, null, 'Bank 3', 'Pre-Contact', 'Channel Partner');
        accounts.add(a1);
        accounts.add(a2);
        accounts.add(a3);
        insert accounts;       
        Test.startTest();
        	liens.add(TestHelperUtility.createLien(o1.Id, a1.Id, system.today()));
        	liens.add(TestHelperUtility.createLien(o1.Id, a2.Id, null));
        	liens.add(TestHelperUtility.createLien(o2.Id, a1.Id, system.today()));
        	liens.add(TestHelperUtility.createLien(o2.Id, a3.Id, system.today()));
        	insert liens;
        Test.stopTest();
        Long startTime = DateTime.now().getTime();
        Long finishTime = DateTime.now().getTime();

        while ((finishTime - startTime) < 2000) {
            //sleep for 1s
            finishTime = DateTime.now().getTime();
        }
        // since async, check for the opportunities AFTER tests stop
        List<Opportunity> updatedOpportunities = [SELECT Id, Name, Mortgage_Lenders__c, Lender_Ack_Status__c  FROM Opportunity WHERE Id IN :opportunities];
        System.assertEquals('Bank 1;Bank 2',updatedOpportunities.get(0).Mortgage_Lenders__c);
        System.assertEquals('Bank 1;Bank 3',updatedOpportunities.get(1).Mortgage_Lenders__c);
        System.assertEquals('Some Received',updatedOpportunities.get(0).Lender_Ack_Status__c);
    }

    public static testMethod void testDeleteRecords() {
        List<Opportunity> opportunities = new List<Opportunity>();
        List<Account> accounts = new List<Account>();
        List<Lien__c> liens = new List<Lien__c>();
        // insert an opportunities
        Opportunity o1 = TestHelperUtility.createOpportunity(null, 'Opportunity 1', null, 'Pre-Qualified Lead', null, null, null, null, null, 'TBD',Date.today()+2, 50.00, 24);
        opportunities.add(o1);
        insert opportunities;
        Account a1 = TestHelperUtility.createAccount(null, null, 'Bank 1', 'Pre-Contact', 'Channel Partner');
        Account a2 = TestHelperUtility.createAccount(null, null, 'Bank 2', 'Pre-Contact', 'Channel Partner');
        Account a3 = TestHelperUtility.createAccount(null, null, 'Bank 3', 'Pre-Contact', 'Channel Partner');
        accounts.add(a1);
        accounts.add(a2);
        insert accounts;   
        Test.startTest();
        	liens.add(TestHelperUtility.createLien(o1.Id, a1.Id, null));
        	liens.add(TestHelperUtility.createLien(o1.Id, a3.Id, system.today()));
        	insert liens;
       		 // now delete a record
        Test.stopTest();
        Long startTime = DateTime.now().getTime();
        Long finishTime = DateTime.now().getTime();
        while ((finishTime - startTime) < 1000) {
            //sleep for 1s
            finishTime = DateTime.now().getTime();
        }
        delete liens.get(1);
        List<Opportunity> updatedOpportunities = [SELECT Id, Name, Mortgage_Lenders__c, Lender_Ack_Status__c FROM opportunity WHERE Id IN :opportunities];
        System.assertEquals('Some Received',updatedOpportunities.get(0).Lender_Ack_Status__c);
        System.assertEquals('Bank 1',updatedOpportunities.get(0).Mortgage_Lenders__c);
    }

}