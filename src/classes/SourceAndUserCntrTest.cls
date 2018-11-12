@isTest
public class SourceAndUserCntrTest {
	
    private static testmethod void testSequenceOfMethods() {
    	Account testAccount = TestHelperUtility.createAccount('Partnership', 'Limited Partnership (LP)', 'Test Account', null, null);
    	insert testAccount;
    	Opportunity testOpportunity = TestHelperUtility.createOpportunity(testAccount.Id, 'Test Opportunity', 'PPA', 'Pre-Qualified Lead', 'TX', UserInfo.getUserId(), 'February', 'February', 'February', null, System.today(), null, null);
    	testOpportunity.Est_Improvement_Cost__c = 100;
        testOpportunity.State_Prop__c  = 'CA';
        testOpportunity.Capitalized_interest__c = 10;
        insert testOpportunity;
        Test.startTest();
        	ApexPages.StandardController sc = new ApexPages.StandardController(testOpportunity);
        	SourceAndUserCntr testSourceAndUser = new SourceAndUserCntr(sc);
        	PageReference pageRef = Page.SourceAndUser;
        	pageRef.getParameters().put('id', String.valueOf(testOpportunity.Id));
        	Test.setCurrentPage(pageRef);
        	testSourceAndUser.programAdminFee1 = '10';
            testSourceAndUser.programAdminFee2 = '10';
        	testSourceAndUser.sponsorMandFee1 = '10';
        	testSourceAndUser.sponsorMandFee2 = '100';
         	testSourceAndUser.legalCouncelFee1 = '10';
    		testSourceAndUser.legalCouncelFee2 = '10';
        	testSourceAndUser.legalCouncelBondFee2 = '10';
        	testSourceAndUser.legalCouncelBondFee1 = '10';
    		testSourceAndUser.AgentFee1 = '10';
    		testSourceAndUser.AgentFee2 = '10';
    		testSourceAndUser.AgentReserveFee1 = '10';
    		testSourceAndUser.AgentReserveFee2 = '10';
    		testSourceAndUser.sponsorFee1 = '10';
    		testSourceAndUser.sponsorResFee1 = '10';
        	testSourceAndUser.recordationFee1 = '10';
    		testSourceAndUser.recordationFee2 = '10';
    		testSourceAndUser.taxFee1 = '10';
    		testSourceAndUser.taxFee2 = '10';
    		testSourceAndUser.govFee = '10';
    		testSourceAndUser.appFee = '10';
        	testSourceAndUser.createSourceAndUser();
        	List<Sources_Uses__c> listOfSources = new List<Sources_Uses__c>([SELECT Id FROM Sources_Uses__c]);
        	//System.assert(listOfSources.size() > 0, 'List size should be more than 0');
        	testSourceAndUser.cancel();
        Test.stopTest();
    }
}