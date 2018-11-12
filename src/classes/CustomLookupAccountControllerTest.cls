@IsTest
private class CustomLookupAccountControllerTest {

    @IsTest
    public static void constructorTest() {
        Test.setCurrentPage(Page.CustomLookupAccount);
        ApexPages.currentPage().getParameters().put('lksrch', 'testString1');
        ApexPages.currentPage().getParameters().put('frm', 'testString2');
        ApexPages.currentPage().getParameters().put('lknm', 'testString3');

        Test.startTest();
        CustomLookupAccountController controller = new CustomLookupAccountController();
        Test.stopTest();

        String actualLksrch = controller.searchString;
        String actualFrm = controller.getFormTag();
        String actualLknm = controller.getTextBox();

        System.assertEquals(actualLksrch, 'testString1');
        System.assertEquals(actualFrm, 'testString2');
        System.assertEquals(actualLknm, 'testString3');

    }

    @IsTest
    public static void searchTest() {
        Account testAccount = createAccount('testName');

        Test.setCurrentPage(Page.CustomLookupAccount);
//        ApexPages.currentPage().getParameters().put('lksrch', 'stN');

        Test.startTest();
        CustomLookupAccountController controller = new CustomLookupAccountController();
        controller.searchString = 'stN';
        controller.search();
        Test.stopTest();

        System.assertEquals(1, controller.results.size());
        System.assertEquals(testAccount.Name, controller.results.get(0).Name);
    }

    @IsTest
    public static void saveTest() {
        Account testAccount = makeAccount('testName');

        Test.setCurrentPage(Page.CustomLookupAccount);
        ApexPages.currentPage().getParameters().put('lksrch', 'stN');

        Test.startTest();
        CustomLookupAccountController controller = new CustomLookupAccountController();
        controller.account = testAccount;
        controller.saveAccount();
        Test.stopTest();

        System.assert(testAccount.Id != null);
    }

    private static Account makeAccount(String name) {
        Account result = new Account();
        result.Name = name;
        result.Client_Status__c = 'Pre-Contact';
        result.CF_Lead_Source__c = 'Other';
        result.Sub_Lead_Source__c ='test';
        result.AccTypeNew__c = 'Unknown';

        return result;
    }

    private static Account createAccount(String name) {
        Account result = makeAccount(name);
        insert result;

        return result;
    }

}