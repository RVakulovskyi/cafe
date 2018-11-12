/**
 * 12.08.2018 Rodion Vakulovskyi custom lead conver util
 */
public class LeadConvertUtil {
    public static sObject processLeadConvertionWithObject(Lead leadConvertItem, String objectName) {
        sObject sObjectToCreate = Schema.getGlobalDescribe().get(objectName).newSObject() ;
        String qualName = objectName.replace('__c', '');
        Field_Mapping_Setting__mdt fieldList = (Field_Mapping_Setting__mdt)ApexHelperUtility.queryCustomMetaType('Field_Mapping_Setting__mdt', qualName);
        Map<String, String> mapOfFields = mapFieldsFromSettings(fieldList);
        Map<String, Object> mapOfFieldValues = new Map<String, Object>();
        List<Object> listOfFields = new List<Object>();
        for(String itemName : mapOfFields.keySet()) {
            System.debug(itemName);
            System.debug(mapOfFields.get(itemName));
            System.debug(leadConvertItem.get(itemName));
        	mapOfFieldValues.put(mapOfFields.get(itemName),leadConvertItem.get(itemName));
        }
        if(mapOfFieldValues.size() > 0){
        	sObjectToCreate = formObjectRecord(mapOfFieldValues, objectName);
        }
		System.debug(sObjectToCreate);
        return sObjectToCreate;
    }
    
    private static sObject formObjectRecord(Map<String, Object> mapOfMappedFields, String objectName) {
        sObject objToReturn = Schema.getGlobalDescribe().get(objectName).newSObject() ;
        Map<String, Schema.SObjectField> mapOfFields;
        if (objectName == 'Opportunity'){
          mapOfFields = Schema.SObjectType.Opportunity.fields.getMap();
        }
        for(String itemFieldName : mapOfMappedFields.keySet()) {
            System.debug(itemFieldName + 'Map FieldName');
            if(mapOfMappedFields.containsKey(itemFieldName)){
            	Object objToAssign = mapOfMappedFields.get(itemFieldName);
            	if(objToAssign instanceof Integer) {
                	objToReturn.put(itemFieldName, Integer.valueOf(objToAssign));
            	}
            	if(objToAssign instanceof String) {
                	objToReturn.put(itemFieldName, String.valueOf(objToAssign));
            	}
            	if(objToAssign instanceof Date || (objToAssign instanceof DateTime)) {
                	objToReturn.put(itemFieldName, (Date)objToAssign);
                } 
            	if(objToAssign instanceof Boolean) {
                	objToReturn.put(itemFieldName, Boolean.valueOf(objToAssign));
            	}
                if(objToAssign instanceof Decimal) {
                	objToReturn.put(itemFieldName, Decimal.valueOf(String.valueOf(objToAssign)));
            	}
                if(objToAssign instanceof Double) {
                    objToReturn.put(itemFieldName, Double.valueOf(objToAssign));
                }
            }
        }
        return objToReturn;
    }
    
    public static Map<String, String> mapFieldsFromSettings(Field_Mapping_Setting__mdt setting) {
        Map<String, String> mapofFieldMapping = new Map<String, String>();
        List<String> keyList = setting.FieldList__c.replace('\r\n', '').split(',');
        List<String> valueList = setting.FieldMapList__c.replace('\r\n', '').split(',');
        for(Integer i = 0; i < keyList.size(); i ++) {
                mapofFieldMapping.put(keyList[i], valueList[i]);
        }
        return mapofFieldMapping;
    }
}