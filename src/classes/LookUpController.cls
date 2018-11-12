public class LookUpController {
    public static Map<Id, String> recordtypemap {get;set;}
    
	@AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey ='%' + searchKeyWord + '%';
        List < sObject > returnList = new List < sObject > ();
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }

   @AuraEnabled        
    public static List<String> fetchRecordTypeValues(){
        List<RecordType> recordtypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' ORDER BY Name DESC]; 
        recordtypemap = new Map<Id, String>();
        for(RecordType rt : recordtypes){
            recordtypemap.put(rt.Id, rt.Name);
        }        
        return recordtypemap.values();
    }
    
    @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){
        Id recid = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        return recid;
    }
    
	@AuraEnabled
	public static void saveContact(Contact con){
        System.debug(con);
        update con;
    }

	@AuraEnabled
	public static void saveAccountAndUpdateContact(Contact con, Account acc, String rType){
        System.debug(con);
        acc.RecordTypeId = getRecTypeId(rType);
        insert acc;
        con.AccountId = acc.Id;
        update con;
    }      
      
}