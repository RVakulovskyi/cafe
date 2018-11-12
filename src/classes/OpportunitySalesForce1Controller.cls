public class OpportunitySalesForce1Controller {
    public static Map<String, String> mapOfLabels{get;set;}
    public static Map<String, String> mapOfValues{get;set;}
    public static Map<String, String> mapOfHelperText{get;set;}
    
    @AuraEnabled
    public static Map<String, List<String>> returnFieldSets(String oppId) {
    return getPageFieldSets(getOpportunityFieldSets(), oppId);
    }
    
   	@AuraEnabled
    public static Map<String, String> returnMapOfValues() {
    return mapOfValues;
    }
    
    @AuraEnabled
    public static Map<String, String> returnMapOfLabels() {
    return mapOfLabels;
    }
    
    @AuraEnabled
    public static Map<String, String> returnMapOfHelperText() {
    return mapOfHelperText;
    }
    
    private static List<String> getOpportunityFieldSets() {
        String uiTheme = UserInfo.getUiThemeDisplayed();
        List<String> settings = new List<String>();
        HardcodedValueSetting__mdt fieldSetValue = (HardcodedValueSetting__mdt)ApexHelperUtility.queryCustomMetaType('HardcodedValueSetting__mdt', 'Opportunity'); 
        List<String> fieldSetList = fieldSetValue.List_Of_Opps_FieldSets__c.replace('\r\n', '').split(',');
        for(String settingItem : fieldSetList){
        	settings.add(settingItem);
        }
    return settings;
    }

    private static Map<String, List<String>> getPageFieldSets(List<String> settings, String oppId) {
        List<FieldSet> resultList = new List<FieldSet>();
        Map<String, FieldSet> opportunityFieldSetsByNames = Opportunity.getSObjectType()
                                                                        .getDescribe()
                                                                        .fieldSets
                                                                        .getMap();
        for (String settingName : settings) {
            FieldSet relatedFieldSet = opportunityFieldSetsByNames.get(settingName);
            resultList.add(relatedFieldSet);
        }
        Map<String, List<String>> mapForLists = new Map<String, List<String>>();
        mapOfLabels = new Map<String, String>();
        mapOfValues = new Map<String, String>();
        mapOfHelperText = new Map<String, String>();
        Map<String, String> mapOfReference = new Map<String, String>();
        String queryForOpp = 'SELECT Id, ';
        for(FieldSet itemFieldSet : resultList) {
            mapForLists.put(itemFieldSet.getLabel(), new List<String>());
            for(Schema.FieldSetMember itemMember : itemFieldSet.getFields()) {
                if(String.valueOf(itemMember.getType()) == 'Reference'){
                    String fixedField = itemMember.getFieldPath().replace('__c', '__r.Name').replace('Id', '.Name');
                    mapOfReference.put(itemMember.getFieldPath(), fixedField);
                    queryForOpp+= fixedField + ',';
                } 
                queryForOpp+= itemMember.getFieldPath() + ',';
                mapOfLabels.put(itemMember.getFieldPath(), itemMember.getLabel());
                mapForLists.get(itemFieldSet.getLabel()).add(itemMember.getFieldPath());
            }
        }
        queryForOpp = queryForOpp.substring(0, queryForOpp.length() -1) + ' FROM Opportunity WHERE Id = :oppId';
        for(Opportunity itemOpp : Database.query(queryForOpp)) {
            for(String itemField : mapOfLabels.keySet()) {
                if(mapOfReference.containsKey(itemField) && itemOpp.get(itemField) != null){
                      String changedFieldName = mapOfReference.get(itemField);
                      String objectName = changedFieldName.substring(0, changedFieldName.lastIndexOf('.'));
                      String fieldName = changedFieldName.substring(changedFieldName.lastIndexOf('.') + 1, changedFieldName.length());
                      mapOfValues.put(itemField, String.valueOf(itemOpp.getSObject(objectName).get(fieldName)));
                } else {
                    if(itemOpp.get(itemField) != null && itemOpp.get(itemField) instanceOf DateTime || itemOpp.get(itemField) instanceOf Date){
                        String theDate = Date.valueOF(itemOpp.get(itemField)).month() + '/' + Date.valueOF(itemOpp.get(itemField)).day() + '/' + Date.valueOF(itemOpp.get(itemField)).year();
                        mapOfValues.put(itemField, theDate); 
                    } else {
                    	mapOfValues.put(itemField, String.valueOf(itemOpp.get(itemField))); 
                    }
                }   	
            }
        }
        SObjectType customObect = Schema.getGlobalDescribe().get('Opportunity');
		Map<String,Schema.SObjectField> mfields = customObect.getDescribe().fields.getMap();
        Set<String> setOfNames = new Set<String>();
        for(String itemName : mapOfValues.keySet()) {
            setOfNames.add(itemName.toLowerCase());
        }
        for(String itemString : mfields.keySet()){
            if(setOfNames.contains(itemString)){
            	mapOfHelperText.put(itemString, mfields.get(itemString).getDescribe().getInlineHelpText());
            }
        }
    return mapForLists;
    }
    
    @AuraEnabled
    public static void saveOpp(Opportunity inputOpp) {
        update inputOpp;
    }
}