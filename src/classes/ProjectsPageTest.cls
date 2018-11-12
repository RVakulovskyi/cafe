@isTest
public class ProjectsPageTest  {

    public static testmethod void testProject() {
        Program__c programToInsert = new Program__c();
            programToInsert.Name = 'Test';
            programToInsert.ProgramAdminName__c = 'Test';
            programToInsert.State__c = 'CA';
            programToInsert.UnderwritingStatus__c = 'Complete';
            programToInsert.Recommendation__c = 'Full Approval';
            programToInsert.Priority__c = 'Backfill';
        insert programToInsert;
        PageReference pageRef = Page.ProjectEgnytePage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(programToInsert.Id));
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
            ApexPages.StandardController sc = new ApexPages.StandardController(programToInsert);
            ProjectsPage egnyteIframe = new ProjectsPage(sc);
            System.assert(egnyteIframe.iframeRenderer);
        Test.stopTest();
    }
}