@isTest
public class OpportunityStagingCheckerTest  {

    private static testmethod void testController() {
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
        ApexPages.StandardController sc = new ApexPages.StandardController(opportunityToInsert);
        OpportunityStagingChecker testOppStageChecker = new OpportunityStagingChecker(sc);
        testOppStageChecker.stageName = 'Initial App';
        testOppStageChecker.renderFields();
        testOppStageChecker.stageName = 'Pre-Qualified Lead';
        testOppStageChecker.renderFields();
        System.assertEquals(true, testOppStageChecker.listofStagedFields != null, 'FieldsetMember list shouldnt be null');
        testOppStageChecker.inputOpp.Description = 'Test';
        testOppStageChecker.saveOpp();
        Opportunity opportunityForChecking = [SELECT Id, Description FROM Opportunity WHERE Id = :testOppStageChecker.inputOpp.Id];
        System.assertEquals('Test', OpportunityForChecking.Description, 'Values should be equal after update');
        testOppStageChecker.closePage();
       Test.stopTest();
    }
}