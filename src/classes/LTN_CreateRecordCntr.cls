public class LTN_CreateRecordCntr {
    public static Map<Id, String> recordtypemap {get;set;}
    
	@AuraEnabled
    public static Id saveContactCntr(Contact inputContact) {
        inputContact.AccountId = String.valueOf(inputContact.AccountId);
        System.debug(inputContact);
        insert inputContact;
        return inputContact.Id;
    }
    
    @AuraEnabled
    public static Id saveLeadCntr(Lead inputLead) {
        System.debug(inputLead);
        Account accToQuery = [SELECT Id, Name FROM Account WHERE Id = :inputLead.Account_Name__c];
        Contact contactToQuery = [SELECT id, FirstName, LastName FROM Contact WHERE Id = :inputLead.Property_Owner_Main_Contact__c];
        inputLead.Company = accToQuery.Name;
        inputLead.FirstName = contactToQuery.FirstName;
        inputLead.LastName = contactToQuery.LastName;
        insert inputLead;
        Task taskToInsert = new Task();
            taskToInsert.Subject = inputLead.Next_Step__c;
            taskToInsert.ActivityDate = inputLead.Next_Step_Tickler__c;
            taskToInsert.WhoId = inputLead.Id;
            taskToInsert.OwnerId = UserInfo.getUserId();
        insert taskToInsert;
        return inputLead.Id;
    }
    
    @AuraEnabled
    public static Id saveAccountCntr(Account inputAccount) {
        insert inputAccount;
        return inputAccount.Id;
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
    
    private static Contact getContact(){
        Contact contactToReturn = null;
        List<Contact> listOfContacts = new List<Contact>([SELECT Id, FirstName, LastName FROM Contact WHERE Name = 'Unknown Owner']);
        if(listOfContacts.size() >0) {
            contactToReturn = listOfContacts[0];
        }
        return contactToReturn;
    }
    
    @AuraEnabled
    public static Account getAccount(){
        Account accountToReturn = null;
        List<Account> listOfAccounts = new List<Account>([SELECT Id, Name FROM Account WHERE Name = 'Uncategorized']);
        if(listOfAccounts.size() >0) {
            accountToReturn = listOfAccounts[0];
        }
        return accountToReturn;
    }
    
    @AuraEnabled
    public static Id saveLeadCntrDefault(Lead inputLead) {
        System.debug(inputLead);
        Account accToQuery = getAccount();
        Contact conToQuery = getContact();
        if(conToQuery != null && accToQuery!= null){
        	inputLead.Account_Name__c = accToQuery.Id;
        	inputLead.Property_Owner_Main_Contact__c = conToQuery.Id;
        	inputLead.Company = accToQuery.Name;
        	inputLead.FirstName = conToQuery.FirstName;
        	inputLead.LastName = conToQuery.LastName;
            inputLead.AccountTypeNew__c = 'Owner';
            inputLead.Stage__c = 'Pre-Qualified Lead';
        }
        insert inputLead;
        Task taskToInsert = new Task();
            taskToInsert.Subject = inputLead.Next_Step__c;
            taskToInsert.ActivityDate = inputLead.Next_Step_Tickler__c;
            taskToInsert.WhoId = inputLead.Id;
            taskToInsert.OwnerId = UserInfo.getUserId();
        insert taskToInsert;
        System.debug(inputLead);
        return inputLead.Id;
    }


}