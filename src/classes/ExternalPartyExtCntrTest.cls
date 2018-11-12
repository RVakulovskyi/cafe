@isTest
public class ExternalPartyExtCntrTest {
	
    private static testmethod void testContractorInsertion() {
        Account accountForTest = TestHelperUtility.createAccount('Partnership', 'Limited Partnership (LP)', 'Test Account', null, null);
        insert accountForTest;
        RecordType rTypeAcc = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Contractor'];
        Account contractorForTest = TestHelperUtility.createAccount(null, null, 'TestAccounts', 'Pre-Contact', 'Channel Partner');    
        contractorForTest.RecordTypeId = rTypeAcc.Id;
        insert contractorForTest;
        Opportunity testOpp = TestHelperUtility.createOpportunity(accountForTest.Id, 'Test Opportunity', 'PPA', 'Pre-Qualified Lead', 'TX', UserInfo.getUserId(), 'February', 'February', 'February', null, System.today(), null, null);
        insert testOpp;
        Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.ContractorEditPage'));
            System.currentPageReference().getParameters().put('oppId', testOpp.Id);
            ExternalPartyExtCntr testContractorCntr = new ExternalPartyExtCntr();
            testContractorCntr.inputExtParty.Account__c = accountForTest.Id;
            testContractorCntr.inputExtParty.ExternalParties__c = contractorForTest.Id;
            testContractorCntr.save();
            List<ExternalPartyRelation__c> listOFRelation = [SELECT Id, Account__c, Opportunity__c FROM ExternalPartyRelation__c];
            System.assertEquals(true, listOFRelation.size() > 0, 'Relation should be created');
            System.assertEquals(true, listOFRelation[0].Account__c == accountForTest.Id, 'Relation should be created.Acc should be equal');
            System.assertEquals(true, listOFRelation[0].Opportunity__c == testOpp.Id, 'Relation should be created.Opp should be equal');
        Test.stopTest();
    }
}