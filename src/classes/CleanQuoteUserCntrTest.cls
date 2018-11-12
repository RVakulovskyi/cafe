@isTest
public class CleanQuoteUserCntrTest  {
    public static testmethod void testController(){
        CleanQuoteUser__c testRecord = new CleanQuoteUser__c(Name = 'Test', Last_Name__c = 'Test', Email__c = 'rod@gmail.com');
        insert testRecord;
        PageReference pageRef = Page.CleanQuoteUserConvertion;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(testRecord.Id));
        Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(testRecord);
            CleanQuoteUserCntr testContr = new CleanQuoteUserCntr(sc);
            testContr.getObjectPickerList();
            testContr.getFieldsContact();
            testContr.getFieldsAccount();
            testContr.objectPicker = 'accToConvert';
            testContr.convertCQUser();
            testContr.objectPicker = 'contactToConvert';
            testContr.convertCQUser();
        Test.stopTest();
    }
}