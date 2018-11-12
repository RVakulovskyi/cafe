public class AccountTriggerHandler {
    Map<ID,Account> otherAccounts;
    Map<Id,Account> existingAccounts;
    private Set<String> accNamekeyPhrasesToSkip;
    
    public AccountTriggerHandler(){
        this.accNamekeyPhrasesToSkip = new Set<String>();
        try{
        for(PossibleMatchAccountNameFilter__c csFilter: PossibleMatchAccountNameFilter__c.getall().values()) {
            this.accNamekeyPhrasesToSkip.add(csFilter.Key_Phrase__c);
        }
        }catch(Exception e){
            e.setMessage('Missing Key Phrases!');
            e.getMessage();
        }
    }
    

    
    public void updateTasksMergeWizardLink(List<Account> deletedAccounts){
        List<Task> tasksToDelete = new List<Task>();
        List<Task> tasksToUpdate = new List<Task>();
        Set<Id> deletedAccountsMasterRecordId = getMasterRecordId(deletedAccounts);
        List<Task> warningDuplicateTasksList = new List<Task>([SELECT Id, Description, WhatId from Task where WhatId in:deletedAccountsMasterRecordId AND WhatId != NULL]);
        if(!warningDuplicateTasksList.isEmpty()){
            	for(Task t :warningDuplicateTasksList){
                    if(t.WhatId != null){
                		for(Account l:deletedAccounts){
                    		If(!String.isEmpty(t.Description) && (t.Description.containsIgnoreCase(l.Id)&& !t.Description.containsignoreCase(t.WhatId))||(!t.Description.ContainsIgnoreCase(l.Id)&&t.Description.containsIgnoreCase(t.WhatId))){              
                        		t.Description = t.description.replace(l.id,l.MasterRecordId);
                        		tasksToUpdate.add(t);
                    		} else if(!String.isEmpty(t.Description) && t.Description.containsIgnoreCase(l.Id)&& t.Description.containsignoreCase(t.WhatId)){
                        		tasksToDelete.add(t);
                    		}
                		}
            		}
        		}
        }
        if(!tasksToDelete.isEmpty()){
        	delete tasksToDelete;
        }
        if(!tasksToUpdate.isEmpty()){
        	update tasksToUpdate;
        }
    }
    
    
    public void PossibleMatchName(List<Account> newAccounts){
        List<Account> Accounts = new List<Account>();
        Set<String> NameNames = getNameNamesSet(newAccounts);
        Set<String> nameFilters = new Set<String>();
        Map<String, Account> accMap = makeAccountsByName(newAccounts);
        List<String> partialMatches = new List<String>();
        for(string name :NameNames){
            for (string namePart : name.split(' ')){
                if (!this.matchesSkipCondition(namePart)){
                    nameFilters.add('%'+ namePart + '%');  
                } 
            }
        }
        otherAccounts = new Map<Id,Account>(
            [select Id, Name
             from Account
             where name LIKE :nameFilters
             limit 50
            ]);
        
        Accounts.addAll(otherAccounts.values());
        for(Account newAccount : newAccounts){
            for(Account acc : Accounts){
                If(acc.Name.containsIgnoreCase(newAccount.Name)){ // && newAccount.Run_Duplicate_Rules__c){
                    IF(newAccount.Possible_matched_Accounts__c == null){
                        newAccount.Possible_matched_Accounts__c = acc.Name+'; \n';
                    }else{newAccount.Possible_matched_Accounts__c += acc.Name+'; \n';}
                }  
            }
        }       
    }
    
    public Boolean matchesSkipCondition(String accName){
        if(String.isBlank(accName)) return true;
        for(String filterItem : this.accNamekeyPhrasesToSkip){
            // system.debug('accName.indexOf(filterItem) => ' + accName.indexOf(filterItem));
            if(accName.toLowerCase().indexOf(filterItem.toLowerCase()) != -1) return true;
        }
        return false;
    }
    
    public void PossibleMatchNameOnUpdate(List<Account> newAccounts){
        List<Account> Accs = new List<Account>();
        Set<String> NameNames = getNameNamesSet(newAccounts);
        
        Set<String> nameFilters = new Set<String>();
        for(string name :NameNames){
            for (string namePart : name.split(' ')){
                if (!this.matchesSkipCondition(namePart)){
                    nameFilters.add('%'+ namePart + '%');
                }
            }
            
        }
        otherAccounts = new Map<Id,Account>(
            [select Id, Name
             from Account
             where name LIKE :nameFilters
             limit 100
            ]);
        
        Accs.addAll(otherAccounts.values());
        for(Account newAccount : newAccounts){
            newAccount.Possible_matched_Accounts__c = null;
            for(Account acc : Accs){
                {
                    IF(newAccount.Possible_matched_Accounts__c == null){
                        newAccount.Possible_matched_Accounts__c = acc.Name+'; \n';
                    }else{newAccount.Possible_matched_Accounts__c += acc.Name+'; \n';}
                }  
            }
        }       
    }
    
    private Set<Task> setToList(List<Task> taskList){
        Set<Task> resultSet = new Set<Task>();
        for(Task t:taskList){
            resultSet.add(t);
        }
        return resultSet;
    }
    
    private Set<String> getNameNamesSet (List<Account> newAccounts){
        Set<String> resultSet = new Set<String>();
        for (Account newAccount : newAccounts){
            resultSet.add(newAccount.Name);
        }
        return resultSet;
    }
    
    
    private Set<Id> getMasterRecordId (List<Account> deletedAccounts){
        Set<Id> resultSet = new Set<Id>();
        for(Account l :deletedAccounts){
            resultSet.add(l.MasterRecordId);
        }
        return resultSet;
    }
    
    
    private Map<String, Account> makeAccountsByName(List<Account> accounts) {
        Map<String, Account> resultMap = new Map<String, Account>();
        for (Account currentAccount : accounts) {
            resultMap.put(currentAccount.Name, currentAccount);
        }
        return resultMap;
    }
    
    
    public void PossibleMatchAccounts(List<Account> newAccounts){
        List<Account> existingAccountsList = new List<Account>();
        List<Task> tasksForMatching = new List<Task>();
        Map<Id,Account> newAccountsById = new Map<Id,Account>(newAccounts);
        
        Set<String> fullNames = getNameNamesSet(newAccounts);
        existingAccounts = new Map<ID,Account>([SELECT Id, Name from Account where Name In :fullNames  AND Id NOT in :newAccountsById.keySet()]);
        If(existingAccounts.isEmpty()){ 
            System.debug('Empty List of Acc !!');
        } else{
            existingAccountsList.addAll(existingAccounts.values());
            
            
            for(Account newAccount : newAccounts){
                for(Account l :existingAccountsList){
                    System.debug('Trying to create a task...');
                    System.debug('Name - 1- '+newAccount.Name);
                    System.debug('Name -2- '+l.Name);
                    if(newAccount.Name.equals(l.Name)){//&& newAccount.Run_Duplicate_Rules__c) {
                        tasksForMatching.add(createTaskForMatching(newAccount.Name,newAccount.Id, l.Id));
                        system.debug('Task was added to List - '+TasksForMatching.size());
                    }
                    
                }
            }
            if(!tasksForMatching.isEmpty()){
                insert tasksForMatching;
                System.debug('Trying to insert Tasks...');
            }
        }
    }
    
    public Task createTaskForMatching(String firstAccountName,Id firstAccountId, id secondAccountId){
        Task result = new Task();
        result.Subject = 'Please take a look on '+firstAccountName+' . Possible duplicate !';
        result.WhatId = firstAccountId;
        String baseUrl = System.Url.getSalesforceBaseUrl().toExternalForm()+'/merge/accmergewizard.jsp?goNext=Merge+Accounts&cid='+firstAccountId+'&cid='+secondAccountId ;
        result.Description = 'Link to wizard - '+ baseUrl;
        return result;
    }
    
    
}