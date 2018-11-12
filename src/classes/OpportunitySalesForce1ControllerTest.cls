@isTest
public class OpportunitySalesForce1ControllerTest  {

    private static testmethod void testingOverrides() {
        Account accountForTest = TestHelperUtility.createAccount('Partnership', 'Limited Partnership (LP)', 'Test Account', null, null);
        insert accountForTest;
        Opportunity testOpp = TestHelperUtility.createOpportunity(accountForTest.Id, 'Test Opportunity', 'PPA', 'Pre-Qualified Lead', 'TX', UserInfo.getUserId(), 'February', 'February', 'February', null, System.today(), null, null);
        insert testOpp;
        Test.startTest();
        Map<String, List<String>> receivedMap = OpportunitySalesForce1Controller.returnFieldSets(testOpp.Id);
        System.assertEquals(true, receivedMap != null, 'Fieldsets were retrieved successfully');
        System.assertEquals(true, receivedMap.values().size() > 0, 'Received fieldsets have fields');
    }
}