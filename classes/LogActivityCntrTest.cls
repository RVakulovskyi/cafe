@isTest
public class LogActivityCntrTest {
    
    public static testmethod void testLogActivityCntr() {
        Account acc = TestHelperUtility.createAccount(null, null, 'TestAccounts', 'Pre-Contact', 'Channel Partner');
        insert acc;
        Contact ct1 = TestHelperUtility.createContact(acc.Id, 'Larrys', 'Page');
        insert ct1;
        Opportunity opportunityToInsert = TestHelperUtility.createOpportunityForBonds(acc.Id, ct1.Id, null, 'Opportunity Contact Insertion Test', 7.5);
        opportunityToInsert.StageName = 'Pre-Qualified Lead';
        insert opportunityToInsert;
        Test.setCurrentPage(new PageReference('LogActivity'));
        System.currentPageReference().getParameters().put('objId', acc.Id);
        System.currentPageReference().getParameters().put('objName', 'Account');
        System.currentPageReference().getParameters().put('contId', ct1.Id);
        Test.startTest();
        	LogActivityCntr activTest = new LogActivityCntr();
        	List<SelectOption> listOfSelOpt = activTest.getActivityValues();
        	System.assert(listOfSelOpt.size() > 0,'Size should be more then 0');
        	activTest.activityValue = 'Call';
        	activTest.renderFieldSetMembers();
        	System.assert(activTest.listFieldSetMembers.size() > 0, 'Size should be more then 0');
        	activTest.saveTask();
        	activTest.back();
        Test.stopTest();
    }
}