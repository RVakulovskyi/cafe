@isTest
public class LeadUpdateStageCntrTest  {

    public static testmethod void testLeadUpdateStage() {
        Lead leadIns = TestHelperUtility.createLead();
        insert leadIns;
        PageReference pageRef = Page.LeadUpdateStage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(leadIns.Id));
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
            ApexPages.StandardController sc = new ApexPages.StandardController(leadIns);
            LeadUpdateStageCntr leadUpdateStage = new LeadUpdateStageCntr(sc);
            leadUpdateStage.getStageValues();
            leadUpdateStage.stageName = 'Pre-Qualified Lead';
            leadUpdateStage.renderFields();
            System.assert(leadUpdateStage.listOfFieldSetMember.size() > 0, 'List size should be more than 0');
            leadUpdateStage.stageName = 'Application_Information';
            leadUpdateStage.renderFields();
            System.assert(leadUpdateStage.listOfFieldSetMember.size() > 0, 'List size should be more than 0');
            leadUpdateStage.stageName = 'Dormant';
            leadUpdateStage.renderFields();
            System.assert(leadUpdateStage.listOfFieldSetMember.size() > 0, 'List size should be more than 0');
            leadUpdateStage.saveLead();
        Test.stopTest();
    }
}