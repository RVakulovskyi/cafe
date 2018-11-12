public class MetadataExplorer {
    public String objName {get;set;}
    public List<FieldInfo> listOfFieldsToReturn {get;set;}
    public List<RecordTypeInfo> listOfRecordTypeToReturn {get;set;}
    public List<FieldSet> listOfFieldSetsToReturn {get;set;}
    public String selectChoiceValue{get;set;}
    
    public MetadataExplorer() {
        String retParam = ApexPages.currentPage().getParameters().get('objName');
        String selectorString = ApexPages.currentPage().getParameters().get('choiceName');
        if(!String.isEmpty(retParam)) {
            System.debug(selectorString);
            if(!String.isEmpty(selectorString)) {
                selectChoiceValue = selectorString;
            }
            objName = retParam;
            showDetails();
        }
         
    }

    public List<SelectOption> getSectionSelector() {
        List<String> listOfSections = new List<String>{'Fields', 'FieldSets', 'RecordTypes'};
        List<SelectOption> listOfSelectOptions = new List<SelectOption>();
        for(String itemOption : listOfSections) {
            listOfSelectOptions.add(new SelectOption(itemOption, itemOption));
        }
        return listOfSelectOptions;
    }

    public List<SelectOption> getObjectPicklistValues() {
        List<SelectOption> listObjToReturn = new List<SelectOption>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().values()){
            listObjToReturn.add(new SelectOption(objTyp.getDescribe().getName(),(String)objTyp.getDescribe().getLabel()));
        }
        listObjToReturn.sort();
        return listObjToReturn;
    }
    
    public class FieldSet{
        public String apiName{get;set;}
        public String labelName{get;set;}
        
        public FieldSet(String apiName, String labelName) {
            this.apiName = apiName;
            this.labelName = labelName;
        }
    }
    
    public class RecordTypeInfo{
        public String recordTypeName{get;set;}
        public String recordTypeId{get;set;}
        
        public RecordTypeInfo(String recordTypeName, String recordTypeId) {
            this.recordTypeName = recordTypeName;
            this.recordTypeId = recordTypeId;
        }
    }
    
    public class FieldInfo{
        public String apiName{get;set;}
        public String labelName{get;set;}
        public String typeName{get;set;}
        public String helperText{get;set;}
        
        public FieldInfo(String apiName, String labelName, String typeName, String helperText) {
            this.apiName = apiName;
            this.labelName = labelName;
            this.typeName = typeName;
            this.helperText = helperText;
        }
    }
    
    private void initFieldsForPage() {
		Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
        listOfFieldsToReturn = new List<FieldInfo>();
        List<String> sortedValues = new List<String>();
        Set<String> setSortedValues = new Set<String>();
        Map<String, DescribeFieldResult> mapOfFieldsChars = new Map<String, DescribeFieldResult>();
		for(Schema.SObjectField fieldItem : fieldMap.values())	{
			Schema.DescribeFieldResult fieldInfoItem = fieldItem.getDescribe();
            setSortedValues.add(fieldInfoItem.getLabel());
            mapOfFieldsChars.put(fieldInfoItem.getLabel(), fieldInfoItem);
		}
        sortedValues.addAll(setSortedValues);
        sortedValues.sort();
        for(String itemSorted : sortedValues) {  
            listOfFieldsToReturn.add(new FieldInfo(mapOfFieldsChars.get(itemSorted).getName(), mapOfFieldsChars.get(itemSorted).getLabel(), String.valueOf(mapOfFieldsChars.get(itemSorted).getType()), mapOfFieldsChars.get(itemSorted).getInlineHelpText()));
        }
	}
    
    private void initFieldSetsForPage(){
        Map <String, Schema.FieldSet> fieldSetMap = Schema.getGlobalDescribe().get(objName).getDescribe().fieldSets.getMap();
        listOfFieldSetsToReturn = new List<FieldSet>();
        List<String> sortedValues = new List<String>();
        Set<String> setSortedValues = new Set<String>();
        for(Schema.FieldSet fieldSetItem : fieldSetMap.values())	{
            setSortedValues.add(fieldSetItem.getLabel());
		}
        sortedValues.addAll(setSortedValues);
        sortedValues.sort();
        for(Schema.FieldSet fieldSetItem : fieldSetMap.values())	{
        	for(String itemSorted : sortedValues) {
                if(fieldSetItem.getLabel() == itemSorted) {
					listOfFieldSetsToReturn.add(new FieldSet(fieldSetItem.getName(), fieldSetItem.getLabel()));
                }
			}
        }
    }
    
    private void initRecordTypeForPage() {
        Map<String, Schema.RecordTypeInfo> recordTypeMap = Schema.getGlobalDescribe().get(objName).getDescribe().getRecordTypeInfosByName();
        listOfRecordTypeToReturn = new List<RecordTypeInfo>();
        List<String> sortedValues = new List<String>();
        Set<String> setSortedValues = new Set<String>();
		for(Schema.RecordTypeInfo recordTypeItem : recordTypeMap.values())	{
            setSortedValues.add(recordTypeItem.getName());
		}
        sortedValues.addAll(setSortedValues);
        sortedValues.sort();
        for(Schema.RecordTypeInfo recordTypeItem : recordTypeMap.values())	{
           	for(String itemSorted : sortedValues) {
                if(itemSorted == recordTypeItem.getName()){
					listOfRecordTypeToReturn.add(new RecordTypeInfo(recordTypeItem.getName(), recordTypeItem.getRecordTypeId()));
            	}
            }
		}
    }
    
    public void showDetails() {
        if(objName != '--None--'){
        	initFieldsForPage();
        	initFieldSetsForPage();
        	initRecordTypeForPage();
            if(String.isEmpty(selectChoiceValue)) {
                selectChoiceValue = 'All';
            }
        } else {
            nullifyingLists();
        }
    }
    
    public void nullifyingLists() {
        listOfFieldsToReturn = null;
        listOfRecordTypeToReturn = null;
        listOfFieldSetsToReturn = null;
        objName = '--None--';
        selectChoiceValue = 'All';
    }
    
    public PageReference generatePDF() {
        return new PageReference('/apex/MetaExplorerPagePDF?objName='+objName);
    }
}