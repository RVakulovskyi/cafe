@isTest
public class LeadConvertClassTest {
    private static testmethod void testLeadConvertUtilString() {
        Lead leadToInsert = TestHelperUtility.createLead();
        insert leadToInsert;
        Attachment attToTest = TestHelperUtility.createAttachment('TestAtt', leadToInsert.Id);
        insert attToTest;
        Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
        Test.startTest();
        	LeadConvertClass leadConvertTest = new LeadConvertClass();
        	leadConvertTest.convertLead(leadToInsert);
        	List<Account> accountToCheck = [SELECT Id FROM Account];
        //	System.assertEquals(true, accountToCheck.size() > 0, 'There should be accs created from convertion');
       Test.stopTest();
    }
}