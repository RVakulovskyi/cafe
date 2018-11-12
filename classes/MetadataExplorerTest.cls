@isTest
public class MetadataExplorerTest  {

    private static testmethod void testMetaPage() {
        MetadataExplorer testMetaSimple = new MetadataExplorer();
        testMetaSimple.getObjectPicklistValues();
        testMetaSimple.getSectionSelector();
        testMetaSimple.objName = 'Account';
        testMetaSimple.showDetails();
        System.assertEquals(true, testMetaSimple.listOfFieldsToReturn.size() > 0, 'Size of fields list should be > 0');
        Test.setCurrentPageReference(testMetaSimple.generatePDF());
        String objName = System.currentPageReference().getParameters().get('objName');
        System.assertEquals(testMetaSimple.objName, objName, 'Variables should be equal');
        testMetaSimple.nullifyingLists();
        System.assertEquals(null, testMetaSimple.listOfFieldsToReturn, 'List of fields should be null after nullyfying');
    }

    private static testmethod void testMetaPagePDF() {
        Test.setCurrentPageReference(new PageReference('Page.MetaExplorerPagePDF'));
        System.currentPageReference().getParameters().put('objName', 'Account');
        System.currentPageReference().getParameters().put('choiceName', 'Fields');
        MetadataExplorer testMetaPDF = new MetadataExplorer();
        testMetaPDF.getObjectPicklistValues();
        testMetaPDF.getSectionSelector();
        testMetaPDF.showDetails();
        System.assertEquals(true, testMetaPDF.listOfFieldsToReturn.size() > 0, 'Size of fields list should be > 0');
        testMetaPDF.nullifyingLists();
        System.assertEquals(null, testMetaPDF.listOfFieldsToReturn, 'List of fields should be null after nullyfying');
    }
}