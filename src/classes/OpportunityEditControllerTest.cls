@IsTest
private class OpportunityEditControllerTest {

    @IsTest
    public static void constructorTest() {
        Opportunity testOpportunity = createOpportunity('testOpportunity');
        Test.setCurrentPage(Page.OpportunityEdit);

        Test.startTest();
        OpportunityEditController controller = new OpportunityEditController(new ApexPages.StandardController(testOpportunity));
        List<FieldSet> actualFieldSets = controller.fieldSets;
        Opportunity actualOpportunity = controller.editedOpportunity;
        Test.stopTest();

        System.assert(!actualFieldSets.isEmpty());
        System.assertEquals(testOpportunity.Id, actualOpportunity.Id);
    }

    @IsTest
    public static void saveAndNewTest() {
        Opportunity testOpportunity = createOpportunity('testOpportunity');
        Test.setCurrentPage(Page.OpportunityEdit);
        ApexPages.currentPage().getParameters().put('retURL', 'testRetURL');
        ApexPages.currentPage().getParameters().put('Id', testOpportunity.Id);

        Test.startTest();
        OpportunityEditController controller = new OpportunityEditController(new ApexPages.StandardController(testOpportunity));
        controller.editedOpportunity.Name = 'testOpportunityqwe';
        PageReference saveAndNewReference = controller.saveAndNew();
        Test.stopTest();

        PageReference expectedReference = new PageReference('/006/e?retURL=testRetURL');
        Opportunity actualOpportunity = getOpportunity(testOpportunity.Id);
        System.assertEquals('testOpportunityqwe', actualOpportunity.Name);
        System.assertEquals(expectedReference.getUrl(), expectedReference.getUrl());
    }

    private static Opportunity makeOpportunity(String name) {
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.Name = name;
        testOpportunity.StageName = 'Pre-Qualified Lead';
        testOpportunity.CloseDate = Date.today().addDays(5);
        testOpportunity.Initial_Entry_Date__c = Date.today();

        return testOpportunity;
    }

    private static Opportunity createOpportunity(String name) {
        Opportunity testOpportunity = makeOpportunity(name);
        insert testOpportunity;
        return testOpportunity;
    }

    private static Opportunity getOpportunity(Id opportunityId) {
        List<Opportunity> opportunities = [
                SELECT Id
                    , Name
                FROM Opportunity
                WHERE Id = :opportunityId
        ];

        return opportunities.isEmpty() ? null : opportunities.get(0);
    }
}