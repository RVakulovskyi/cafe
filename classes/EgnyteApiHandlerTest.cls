@isTest
public class EgnyteApiHandlerTest  {

    public static testmethod void testformEgnyteRequest() {
        createCustomSetting();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
            EgnyteAPIHandler.formEgnyteRequest();
        Test.stoptest();

    }

    public static testmethod void testcreateFolder() {
        createCustomSetting();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
            EgnyteAPIHandler.createFolder('');
        Test.stoptest();

    }

    public static testmethod void tescreateFolderLead() {
        createCustomSetting();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
            EgnyteAPIHandler.createFolderLead('');
        Test.stoptest();
    }

    public static testmethod void testcreateFolderChild() {
        createCustomSetting();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
            EgnyteAPIHandler.createFolderChild('');
        Test.stoptest();
    }

    public static testmethod void testmoveFile() {
        createCustomSetting();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
            EgnyteAPIHandler.moveFile('', '');
        Test.stoptest();
    }

    public static testmethod void testdeleteFileOrFolder() {
        createCustomSetting();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
            EgnyteAPIHandler.deleteFileOrFolder('');
        Test.stoptest();
    }

    public static testmethod void testchangeFolderNameLead() {
        createCustomSetting();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
            EgnyteAPIHandler.changeFolderNameLead('', '');
        Test.stoptest();
    }

    public static testmethod void changeFolderNameOpp() {
        createCustomSetting();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
            EgnyteAPIHandler.changeFolderNameOpp('','');
        Test.stoptest();
    }

    public static testmethod void testcopyFolderTemplate() {
        createCustomSetting();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
            EgnyteAPIHandler.copyFolderTemplate('');
        Test.stoptest();
    }

    public static testmethod void testuploadFile() {
        createCustomSetting();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
            EgnyteAPIHandler.uploadFile('', Blob.valueOf(''), '');
    }

    public static testmethod void testnavigateToFolder() {
        createCustomSetting();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
            EgnyteAPIHandler.navigateToFolder('', '', '');
        Test.stoptest();
    }

    private static void createCustomSetting() {
        Egnyte__c egnCs = Egnyte__c.getOrgDefaults();
        egnCs.Value__c = '1111111111111111111111';
        insert egnCs;
        EgnyteGeneral__c egnCsGent = EgnyteGeneral__c.getOrgDefaults();
        egnCsGent.Value__c = '1111111111111111111111';
        insert egnCsGent;
    }

}