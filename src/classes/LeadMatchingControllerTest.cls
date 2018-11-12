@IsTest
private class LeadMatchingControllerTest {

    @IsTest
    public static void constructorTest() {
        Lead testLead = createLead('testLead');
        Test.setCurrentPage(Page.LeadPossibleMatchedAccounts);
        ApexPages.currentPage().getParameters().put('Id', testLead.Id);
        
        Test.startTest();
        LeadMatchingAccountsController controller = new LeadMatchingAccountsController(new ApexPages.StandardController(testLead));
        controller.selectedResult = 'testAccount';
        controller.save();
        Test.stopTest();
    }

    private static Lead makeLead(String name) {
        Lead testLead = new Lead();
        testLead.LastName = name;
        testLead.Company = 'test';
        testLead.AccountTypeNew__c='Unknown';
        testLead.Status='Open';
        testLead.CF_Sub_Lead_Source__c='test';
        testLead.Possible_matched_Accounts__c = 'testAccount;test123;test2222;Test Inc.';
        testLead.Run_Duplicate_Rules__c=true;
        
        return testLead;
    }

    private static Lead createLead(String name) {
        createCustomSetting();
        Lead testLead = makeLead(name);
        insert testLead;
        return testLead;
    }

    private static void createCustomSetting() {
        Egnyte__c egnCs = Egnyte__c.getOrgDefaults();
        egnCs.Value__c = '1111111111111111111111';
        upsert egnCs Egnyte__c.Id;
        EgnyteGeneral__c egnCsGent = EgnyteGeneral__c.getOrgDefaults();
        egnCsGent.Value__c = '1111111111111111111111';
        upsert egnCsGent EgnyteGeneral__c.Id;
    }
  
}