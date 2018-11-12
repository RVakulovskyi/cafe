public class AccountsLeadSource {
    
    public void copyLeadSource (){
        List<Account> existingAccounts = new List<Account>([Select id, Name,Description,CF_Lead_Source__c, Sub_Lead_Source__c FROM Account]);
        List<Contact> exisitngContacts = new List<Contact>([SELECT id, name,AccountID, CF_Lead_Source__c, Sub_Lead_Source__c FROM Contact where AccountID in :existingAccounts Order BY CreatedDate]);
        // System.debug(existingAccounts);
        List<Account> result = new List<Account>();
        for(Account acc :existingAccounts){
            for(Contact cont :exisitngContacts){
                if(cont.AccountID == acc.Id && acc.CF_Lead_Source__c == null && acc.Sub_Lead_Source__c == null && acc.Description == null){
                    acc.CF_Lead_Source__c = cont.CF_Lead_Source__c;
                    acc.Sub_Lead_Source__c = cont.Sub_Lead_Source__c;
                    If(acc.Description == null){
                        acc.Description = ' ';
                    }else (acc.Description += ' ');
                    result.add(acc);
                }
            }
            
        }
       // updateAccBatch UAB = new updateAccBatch();
       // System.executeBatch(UAB);
    }
}