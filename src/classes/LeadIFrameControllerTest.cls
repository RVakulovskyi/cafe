@isTest
public class LeadIFrameControllerTest  {

    public static testmethod void testLeadController() {
        Lead leadIns = TestHelperUtility.createLead();
        insert leadIns;
        PageReference pageRef = Page.LeadEgnyteIFrame;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(leadIns.Id));
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
            ApexPages.StandardController sc = new ApexPages.StandardController(leadIns);
            LeadIFrameController egnyteIframe = new LeadIFrameController(sc);
            System.assert(egnyteIframe.iframeRenderer);
        Test.stopTest();
    }
}