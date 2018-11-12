@isTest
public class EgnyteIFrameControllerTest  {

    public static testmethod void testOppController() {
        Opportunity oppToInsert = createDataForTest();
        PageReference pageRef = Page.OpportunityEgnytePage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(oppToInsert.Id));
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
            ApexPages.StandardController sc = new ApexPages.StandardController(oppToInsert);
            EgnyteIframeController egnyteIframe = new EgnyteIframeController(sc);
            System.assert(egnyteIframe.iframeRenderer);
        Test.stopTest();

    }

    private static Opportunity createDataForTest() {
       Account acc = TestHelperUtility.createAccount(null, null, 'TestAccounts', 'Pre-Contact', 'Channel Partner'); 
       insert acc;
       List<Contact> contacts = new list<Contact>();
       // Create two contacts
       Contact ct1 = TestHelperUtility.createContact(acc.Id, 'Larrys', 'Page');
       contacts.add(ct1);
       insert contacts;
       Opportunity opportunityToInsert = TestHelperUtility.createOpportunityForBonds(acc.Id, contacts[0].Id, null, 'Opportunity Contact Insertion Test', 7.5);
       insert opportunityToInsert;
    return opportunityToInsert;
    }
}