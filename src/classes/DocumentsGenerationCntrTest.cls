@isTest
public class DocumentsGenerationCntrTest {
    private static testmethod void testDocGeneratorInitialApp() {
	   Opportunity opportunityToInsert = createDataForTest();
       Test.setCurrentPageReference(new PageReference('Page.DocumentGenerator')); 
	   System.currentPageReference().getParameters().put('oppId', opportunityToInsert.Id);
       Test.startTest();
       	DocumentsGenerationCntr docGeneratorTest = new DocumentsGenerationCntr();
        List<SelectOption> selectOptionList = docGeneratorTest.getDocumentTypes();
        System.assertEquals(true, selectOptionList.size() > 0, 'List should not be empty');
        docGeneratorTest.picklistValue = 'Initial App';
        docGeneratorTest.returnFieldSetList();
        System.assertEquals(true, docGeneratorTest.mapOfFieldSets != null, 'Size should be more then 0');
        docGeneratorTest.saveOpp();
        docGeneratorTest.generateButton();
        docGeneratorTest.back();
       Test.stopTest();
    }
    
    private static testmethod void testDocGeneratorPaceCalculator() {
	   Opportunity opportunityToInsert = createDataForTest();
       Test.setCurrentPageReference(new PageReference('Page.DocumentGenerator')); 
	   System.currentPageReference().getParameters().put('oppId', opportunityToInsert.Id);
       Test.startTest();
       	DocumentsGenerationCntr docGeneratorTest = new DocumentsGenerationCntr();
        List<SelectOption> selectOptionList = docGeneratorTest.getDocumentTypes();
        System.assertEquals(true, selectOptionList.size() > 0, 'List should not be empty');
        docGeneratorTest.picklistValue = 'Pace Calculator/Term Sheet';
        docGeneratorTest.returnFieldSetList();
        System.assertEquals(true, docGeneratorTest.mapOfFieldSets != null, 'Size should be more then 0');
        docGeneratorTest.saveOpp();
        docGeneratorTest.generateButton();
        docGeneratorTest.back();
       Test.stopTest();
    }
    
    private static testmethod void testDocGeneratorAppraisalEngagement() {
	   Opportunity opportunityToInsert = createDataForTest();
       Test.setCurrentPageReference(new PageReference('Page.DocumentGenerator')); 
	   System.currentPageReference().getParameters().put('oppId', opportunityToInsert.Id);
       Test.startTest();
       	DocumentsGenerationCntr docGeneratorTest = new DocumentsGenerationCntr();
        List<SelectOption> selectOptionList = docGeneratorTest.getDocumentTypes();
        System.assertEquals(true, selectOptionList.size() > 0, 'List should not be empty');
        docGeneratorTest.picklistValue = 'Appraisal Engagement';
        docGeneratorTest.returnFieldSetList();
        System.assertEquals(true, docGeneratorTest.mapOfFieldSets != null, 'Size should be more then 0');
        docGeneratorTest.saveOpp();
        docGeneratorTest.generateButton();
        docGeneratorTest.back();
       Test.stopTest();
    }
    
    private static testmethod void testDocGeneratorScreener() {
	   Opportunity opportunityToInsert = createDataForTest();
       Test.setCurrentPageReference(new PageReference('Page.DocumentGenerator')); 
	   System.currentPageReference().getParameters().put('oppId', opportunityToInsert.Id);
       Test.startTest();
       	DocumentsGenerationCntr docGeneratorTest = new DocumentsGenerationCntr();
        List<SelectOption> selectOptionList = docGeneratorTest.getDocumentTypes();
        System.assertEquals(true, selectOptionList.size() > 0, 'List should not be empty');
        docGeneratorTest.picklistValue = 'Screener';
        docGeneratorTest.returnFieldSetList();
        System.assertEquals(true, docGeneratorTest.mapOfFieldSets != null, 'Size should be more then 0');
        docGeneratorTest.saveOpp();
        docGeneratorTest.generateButton();
        docGeneratorTest.back();
       Test.stopTest();
    }
    
    private static testmethod void testDocGeneratorLOI () {
	   Opportunity opportunityToInsert = createDataForTest();
       Test.setCurrentPageReference(new PageReference('Page.DocumentGenerator')); 
	   System.currentPageReference().getParameters().put('oppId', opportunityToInsert.Id);
       Test.startTest();
       	DocumentsGenerationCntr docGeneratorTest = new DocumentsGenerationCntr();
        List<SelectOption> selectOptionList = docGeneratorTest.getDocumentTypes();
        System.assertEquals(true, selectOptionList.size() > 0, 'List should not be empty');
        docGeneratorTest.picklistValue = 'LOI';
        docGeneratorTest.returnFieldSetList();
        System.assertEquals(true, docGeneratorTest.mapOfFieldSets != null, 'Size should be more then 0');
        docGeneratorTest.saveOpp();
        docGeneratorTest.generateButton();
        docGeneratorTest.back();
       Test.stopTest();
    }
    
    private static testmethod void testDocGenerator3rdPartyAuthorizationForm() {
	   Opportunity opportunityToInsert = createDataForTest();
       Test.setCurrentPageReference(new PageReference('Page.DocumentGenerator')); 
	   System.currentPageReference().getParameters().put('oppId', opportunityToInsert.Id);
       Test.startTest();
       	DocumentsGenerationCntr docGeneratorTest = new DocumentsGenerationCntr();
        List<SelectOption> selectOptionList = docGeneratorTest.getDocumentTypes();
        System.assertEquals(true, selectOptionList.size() > 0, 'List should not be empty');
        docGeneratorTest.picklistValue = '3rd Party Authorization Form';
        docGeneratorTest.returnFieldSetList();
        System.assertEquals(true, docGeneratorTest.mapOfFieldSets != null, 'Size should be more then 0');
        docGeneratorTest.saveOpp();
        docGeneratorTest.generateButton();
        docGeneratorTest.back();
       Test.stopTest();
    }
    
        private static testmethod void testDocGeneratorGenerateDRL() {
	   Opportunity opportunityToInsert = createDataForTest();
       Test.setCurrentPageReference(new PageReference('Page.DocumentGenerator')); 
	   System.currentPageReference().getParameters().put('oppId', opportunityToInsert.Id);
       Test.startTest();
       	DocumentsGenerationCntr docGeneratorTest = new DocumentsGenerationCntr();
        List<SelectOption> selectOptionList = docGeneratorTest.getDocumentTypes();
        System.assertEquals(true, selectOptionList.size() > 0, 'List should not be empty');
        docGeneratorTest.picklistValue = 'Generate DRL';
        docGeneratorTest.returnFieldSetList();
        System.assertEquals(true, docGeneratorTest.mapOfFieldSets != null, 'Size should be more then 0');
        docGeneratorTest.saveOpp();
        docGeneratorTest.generateButton();
        docGeneratorTest.back();
       Test.stopTest();
    }
    
    private static testmethod void testDocGeneratorDRLStatus() {
	   Opportunity opportunityToInsert = createDataForTest();
       Test.setCurrentPageReference(new PageReference('Page.DocumentGenerator')); 
	   System.currentPageReference().getParameters().put('oppId', opportunityToInsert.Id);
       Test.startTest();
       	DocumentsGenerationCntr docGeneratorTest = new DocumentsGenerationCntr();
        List<SelectOption> selectOptionList = docGeneratorTest.getDocumentTypes();
        System.assertEquals(true, selectOptionList.size() > 0, 'List should not be empty');
        docGeneratorTest.picklistValue = 'DRL Status';
        docGeneratorTest.returnFieldSetList();
        System.assertEquals(true, docGeneratorTest.mapOfFieldSets != null, 'Size should be more then 0');
        docGeneratorTest.saveOpp();
        docGeneratorTest.generateButton();
        docGeneratorTest.back();
       Test.stopTest();
    }
    
    private static testmethod void testDocGeneratorLenderAcknowledgement() {
	   Opportunity opportunityToInsert = createDataForTest();
       Test.setCurrentPageReference(new PageReference('Page.DocumentGenerator')); 
	   System.currentPageReference().getParameters().put('oppId', opportunityToInsert.Id);
       Test.startTest();
       	DocumentsGenerationCntr docGeneratorTest = new DocumentsGenerationCntr();
        List<SelectOption> selectOptionList = docGeneratorTest.getDocumentTypes();
        System.assertEquals(true, selectOptionList.size() > 0, 'List should not be empty');
        docGeneratorTest.picklistValue = 'Lender Acknowledgement';
        docGeneratorTest.returnFieldSetList();
        System.assertEquals(true, docGeneratorTest.mapOfFieldSets != null, 'Size should be more then 0');
        docGeneratorTest.saveOpp();
        docGeneratorTest.generateButton();
        docGeneratorTest.back();
       Test.stopTest();
    }
    
    private static testmethod void testDocGeneratorCFPaymentInstructions() {
	   Opportunity opportunityToInsert = createDataForTest();
       Test.setCurrentPageReference(new PageReference('Page.DocumentGenerator')); 
	   System.currentPageReference().getParameters().put('oppId', opportunityToInsert.Id);
       Test.startTest();
       	DocumentsGenerationCntr docGeneratorTest = new DocumentsGenerationCntr();
        List<SelectOption> selectOptionList = docGeneratorTest.getDocumentTypes();
        System.assertEquals(true, selectOptionList.size() > 0, 'List should not be empty');
        docGeneratorTest.picklistValue = 'CF Payment Instructions';
        docGeneratorTest.returnFieldSetList();
        docGeneratorTest.saveOpp();
        docGeneratorTest.generateButton();
        docGeneratorTest.back();
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