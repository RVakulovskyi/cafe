/**
Test class for LeadConvertUtil
13.02.2018 Rodion Vakulovskyi created class
**/
@isTest
public class LeadConvertUtilTest {
    
    private static testmethod void testLeadConvertUtilString() {
        Lead leadToInsert = TestHelperUtility.createLead();
        leadToInsert.Entity_Type__c = 'Partnership';
        Account accToTest = (Account)LeadConvertUtil.processLeadConvertionWithObject(leadToInsert, 'Account');
    }
    
    private static testmethod void testLeadConvertUtilDate() {
        Lead leadToInsert = TestHelperUtility.createLead();
        leadToInsert.Acquisition_Date__c = Date.today();
        Test.startTest();
        	Opportunity oppToTest = (Opportunity)LeadConvertUtil.processLeadConvertionWithObject(leadToInsert, 'Opportunity');
        Test.stopTest();
    }

    private static testmethod void testLeadRequiredPage() {
        Test.startTest();
         Lead leadToInsert = TestHelperUtility.createLead();
         leadToInsert.LastName = 'Test';
         leadToInsert.Company = 'Test';
         leadToInsert.CF_Sub_Lead_Source__c = 'erwr';
         insert leadToInsert;
         ApexPages.StandardController sc = new ApexPages.StandardController(leadToInsert);
         RequiredLeadConversionCntr leadTest = new RequiredLeadConversionCntr(sc);
         List<Schema.FieldSetMember> listFieldSet = leadTest.getFieldsAccount();
         List<Schema.FieldSetMember> listFieldSet2 = leadTest.getFieldsContact();
         List<Schema.FieldSetMember> listFieldSet3 = leadTest.getFieldsOpp();
      //   System.assertEquals(true, listFieldSet.size() > 0, 'Size should me more then 0');
        // System.assertEquals(null,errorMsg, 'Return message should be empty');
       Test.stopTest();
    }
}