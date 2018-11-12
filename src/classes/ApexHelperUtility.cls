/**
* @author Rodion Vakulovskyi
* @author Rodion Vakulovskyi
* @version 1.00
* @description Utility class for apex methods
* 
*/

public class ApexHelperUtility  {

	public static sObject queryCustomMetaType(String objectName, String settingName) {
		String queryString = 'SELECT ';
		SObjectType customMetaType = Schema.getGlobalDescribe().get(objectName);
		Map<String,Schema.SObjectField> mfields = customMetaType.getDescribe().fields.getMap();
		for(String itemString : mfields.keySet()) {
			queryString+= itemString + ',';
		}
		queryString = queryString.substring(0, queryString.length() - ','.length()) + ' FROM '+objectName+' WHERE QualifiedApiName = :settingName';
        System.debug(queryString);
		return Database.query(queryString);
	}

	
	public static sObject queryAllFieldsObject(String objectName, String inputId) {
		String queryString = 'SELECT ';
		SObjectType customObect = Schema.getGlobalDescribe().get(objectName);
		Map<String,Schema.SObjectField> mfields = customObect.getDescribe().fields.getMap();
		for(String itemString : mfields.keySet()) {
			queryString+= itemString + ',';
		}
        if(String.isEmpty(inputId)) {
            queryString = queryString.substring(0, queryString.length() - ','.length()) + ' FROM '+objectName;
        } else {
            queryString = queryString.substring(0, queryString.length() - ','.length()) + ' FROM '+objectName+' WHERE Id = :inputId';
        }
        System.debug(queryString);
		return Database.query(queryString);
	}

    public static sObject queryAllFieldsObjectOPP(String objectName, String inputId) {

        String queryString = 'SELECT ';
        queryString +='Sub_Entity_1__r.Name, Sub_Entity_1__r.Entity_Status__c, Sub_Entity_1__r.Entity_Date_Formed__c, Sub_Entity_1__r.Entity_Filling__c, Sub_Entity_1__r.Entity_State__c, Sub_Entity_1__r.Entity_Tax_ID__c, Sub_Entity_1__r.Sponsor_Name__c, Sub_Entity_1__r.Litigation__c, Sub_Entity_1__r.Bankruptcy__c, Sub_Entity_1__r.Foreclosure_Short_Sale_Deed_in_Lieu__c, Sub_Entity_1__r.Financial_Crime__c, Sub_Entity_1__r.Public_Records_Search_Date__c, Sub_Entity_1__r.Public_Record_Search_Notes__c,';
        queryString +='Sub_Entity_2__r.Name, Sub_Entity_2__r.Entity_Status__c, Sub_Entity_2__r.Entity_Date_Formed__c, Sub_Entity_2__r.Entity_Filling__c, Sub_Entity_2__r.Entity_State__c, Sub_Entity_2__r.Entity_Tax_ID__c, Sub_Entity_2__r.Sponsor_Name__c, Sub_Entity_2__r.Litigation__c, Sub_Entity_2__r.Bankruptcy__c, Sub_Entity_2__r.Foreclosure_Short_Sale_Deed_in_Lieu__c, Sub_Entity_2__r.Financial_Crime__c, Sub_Entity_2__r.Public_Records_Search_Date__c, Sub_Entity_2__r.Public_Record_Search_Notes__c,';
        queryString +='Sub_Entity_3__r.Name, Sub_Entity_3__r.Entity_Status__c, Sub_Entity_3__r.Entity_Date_Formed__c, Sub_Entity_3__r.Entity_Filling__c, Sub_Entity_3__r.Entity_State__c, Sub_Entity_3__r.Entity_Tax_ID__c, Sub_Entity_3__r.Sponsor_Name__c, Sub_Entity_3__r.Litigation__c, Sub_Entity_3__r.Bankruptcy__c, Sub_Entity_3__r.Foreclosure_Short_Sale_Deed_in_Lieu__c, Sub_Entity_3__r.Financial_Crime__c, Sub_Entity_3__r.Public_Records_Search_Date__c, Sub_Entity_3__r.Public_Record_Search_Notes__c,';
        queryString +='Sub_Entity_4__r.Name, Sub_Entity_4__r.Entity_Status__c, Sub_Entity_4__r.Entity_Date_Formed__c, Sub_Entity_4__r.Entity_Filling__c, Sub_Entity_4__r.Entity_State__c, Sub_Entity_4__r.Entity_Tax_ID__c, Sub_Entity_4__r.Sponsor_Name__c, Sub_Entity_4__r.Litigation__c, Sub_Entity_4__r.Bankruptcy__c, Sub_Entity_4__r.Foreclosure_Short_Sale_Deed_in_Lieu__c, Sub_Entity_4__r.Financial_Crime__c, Sub_Entity_4__r.Public_Records_Search_Date__c, Sub_Entity_4__r.Public_Record_Search_Notes__c,';
        SObjectType customObect = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = customObect.getDescribe().fields.getMap();
        for(String itemString : mfields.keySet()) {
            queryString+= itemString + ',';
        }
        System.debug(queryString);
        if(String.isEmpty(inputId)) {
            queryString = queryString.substring(0, queryString.length() - ','.length()) + ' FROM '+objectName;
        } else {
            queryString = queryString.substring(0, queryString.length() - ','.length()) + ' FROM '+objectName+' WHERE Id = :inputId';
        }
        System.debug(queryString);
        return Database.query(queryString);
    }

    public static Map<String, sObject> queryAllMetaByType(String objectName) {
        String queryString = 'SELECT ';
        SObjectType customMetaType = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = customMetaType.getDescribe().fields.getMap();
        Map<String , sObject> mapToReturn = new Map<String , sObject>();
        for(String itemString : mfields.keySet()) {
            queryString+= itemString + ',';
        }
        queryString = queryString.substring(0, queryString.length() - ','.length()) + ' FROM '+objectName;
        for(sObject metaItem : Database.query(queryString)) {
            mapToReturn.put((String)metaItem.get('QualifiedApiName'), metaItem);
        }
        return mapToReturn;
    }
    
        public static Map<String, sObject> queryAllMetaByTypeLabel(String objectName) {
        String queryString = 'SELECT ';
        SObjectType customMetaType = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = customMetaType.getDescribe().fields.getMap();
        Map<String , sObject> mapToReturn = new Map<String , sObject>();
        for(String itemString : mfields.keySet()) {
            queryString+= itemString + ',';
        }
        queryString = queryString.substring(0, queryString.length() - ','.length()) + ' FROM '+objectName;
        for(sObject metaItem : Database.query(queryString)) {
            mapToReturn.put((String)metaItem.get('Label'), metaItem);
        }
        return mapToReturn;
    }
    
    public static sObject queryAllFieldsObjectWithRelation(String objectName, String inputId, List<String> inputList) {
		String queryString = 'SELECT ';
		SObjectType customObect = Schema.getGlobalDescribe().get(objectName);
		Map<String,Schema.SObjectField> mfields = customObect.getDescribe().fields.getMap();
		for(String itemString : mfields.keySet()) {
			queryString+= itemString + ',';
		}
        if(inputList.size() > 0) {
            for(String itemString : inputList) {
                queryString += itemString + ',';
            }
        }
        if(String.isEmpty(inputId)) {
            queryString = queryString.substring(0, queryString.length() - ','.length()) + ' FROM '+objectName;
        } else {
            queryString = queryString.substring(0, queryString.length() - ','.length()) + ' FROM '+objectName+' WHERE Id = :inputId';
        }
        System.debug(queryString);
        List<sObject> objectToReturn = Database.query(queryString);
        if(objectToReturn.size() > 0) {
         return objectToReturn[0];
        } else {
            return null;
        }
	}
}