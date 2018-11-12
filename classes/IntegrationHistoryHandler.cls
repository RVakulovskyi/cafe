public class IntegrationHistoryHandler {

    public static IntegrationHistory__c formAndUpdateRecord(Id leadId, String mappingStr) {
        IntegrationHistory__c historyToUps = new IntegrationHistory__c(); 
            historyToUps.LeadId__c = leadId;
			historyToUps.Mapping__c = mappingStr;
        return historyToUps;
    }
    
    public static String formObjectStr(String objectName, sObject inputObjectFrom, sObject inputObjectTo) {
        Field_Mapping_Setting__mdt fieldList = (Field_Mapping_Setting__mdt)ApexHelperUtility.queryCustomMetaType('Field_Mapping_Setting__mdt', objectName.replace('__c', ''));
        Map<String, String> mapOfFieldsLead = LeadConvertUtil.mapFieldsFromSettings(fieldList);
        String jSonBody = '{"' + objectName + '" : ' + '{';
        for(String itemStringLead : mapOfFieldsLead.keySet()) {
            jSonBody+='"' + itemStringLead+'" : {';
            jSonBody+='"current_Field":"' + mapOfFieldsLead.get(itemStringLead) + '",';
            jSonBody+='"lead_Value":"' + inputObjectFrom.get(itemStringLead) + '",';
            jSonBody+='"current_Value":"' + inputObjectTo.get(mapOfFieldsLead.get(itemStringLead)) + '",';
            if(inputObjectFrom.get(itemStringLead) == inputObjectTo.get(mapOfFieldsLead.get(itemStringLead))) {
				jSonBody +='"equals":"1"';                
            } else {
            	jSonBody +='"equals":"0"'; 
            }
            jSonBody +='},';
        }
        jSonBody = jSonBody.substring(0, jSonBody.length() -1);
        jSonBody += '}}';
        return jSonBody;     
    } 
}