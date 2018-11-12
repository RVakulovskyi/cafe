public class LeadTriggerHandler {
    Map<ID,Account> existingAccounts;
    Map<Id,Lead> existingLeads;
    Map<ID,ID> leadToAcc;
    private Set<String> accNamekeyPhrasesToSkip;
    
  /*  public LeadTriggerHandler(){
        this.accNamekeyPhrasesToSkip = new Set<String>();
        for(PossibleMatchAccountNameFilter__c csFilter: PossibleMatchAccountNameFilter__c.getall().values()) {
            this.accNamekeyPhrasesToSkip.add(csFilter.Key_Phrase__c);
        }
    }
    
 //  Tasks for Duplicated Leads
   /*
    public void updateTasksMergeWizardLink(List<Lead> deletedLeads){     
        Set<Id> deletedLeadsMasterRecordId = getMasterRecordId(deletedLeads);
        List<Task> warningDuplicateTasks = new List<Task>([SELECT Id, Description, Whoid from Task where WhoID in:deletedLeadsMasterRecordId]);
        List<Task> tasksToDelete = new List<Task>();
        List<Task> tasksToUpdate = new List<Task>();
        for(Task t :warningDuplicateTasks){
            for(Lead l:deletedLeads){
                If((t.Description.containsIgnoreCase(l.Id)&& !t.Description.containsignoreCase(t.WhoId))||(!t.Description.ContainsIgnoreCase(l.Id)&&t.Description.containsIgnoreCase(t.WhoId))){              
                    t.Description = t.description.replace(l.id,l.MasterRecordId);
                    tasksToUpdate.add(t);
                } else if(t.Description.containsIgnoreCase(l.Id)&& t.Description.containsignoreCase(t.WhoId)){
                    tasksToDelete.add(t);
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

    public void AutoConvert(List<Lead> newLeads){
        List<Account> Accounts = new List<Account>();
        leadToAcc = new Map<Id,Id>();
        Set<String> companyNames = getCompanyNamesSet(newLeads);
        ExistingAccounts = new Map<ID,Account>([SELECT Id, Name from Account where Name in :companyNames]);
        Accounts.addAll(ExistingAccounts.values());
        Map<String,Account> accountMap = makeAccountsByName(Accounts);
        for(Lead newLead : newLeads){
            System.debug('acc - '+ accountMap);
                System.debug('Lead - '+newLead);
            if (accountMap.containsKey(newLead.Company) && newLead.Run_Duplicate_Rules__c && !newLead.IsConverted) {
                leadToAcc.put(newLead.Id, accountMap.get(newLead.Company).Id);
            }        
        }
        If(!leadToAcc.isEmpty()){
            LeadAssign(leadToAcc);       
        } 
    }
    
    public void PossibleMatchCompany(List<Lead> newLeads){
        List<Account> Accounts = new List<Account>();
        Set<String> companyNames = getCompanyNamesSet(newLeads);
        Set<String> nameFilters = new Set<String>();
        for(string name :companyNames){
            for (string namePart : name.split(' ')) {
                if (!this.matchesSkipCondition(namePart)){
                    nameFilters.add('%'+ namePart + '%');    
                }                
            }
        }
        ExistingAccounts = new Map<Id,Account>(
            [select Id, Name
             from Account
             where name LIKE :nameFilters 
            ]);
        
        Accounts.addAll(ExistingAccounts.values());
        for(Lead newLead : newLeads){
            for(Account acc : Accounts){
                System.debug('acc - '+ acc);
                System.debug('Lead - '+newLead);
                If(acc.Name.containsIgnoreCase(newLead.Company) && newLead.Run_Duplicate_Rules__c &&!newLead.IsConverted){
                    IF(newLead.Possible_matched_Accounts__c == null){
                        newLead.Possible_matched_Accounts__c = acc.Name+'; \n';
                    }else{newLead.Possible_matched_Accounts__c += acc.Name+'; \n';}
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
    
    public void PossibleMatchCompanyOnUpdate(List<Lead> newLeads){
        List<Account> Accounts = new List<Account>();
        //List<Lead> FuzzyLeads = new List<Lead>();
        Set<String> companyNames = getCompanyNamesSet(newLeads);
        Set<String> nameFilters = new Set<String>();
        for(string name :companyNames){
            for (string namePart : name.split(' ')){
                if (!this.matchesSkipCondition(namePart)){
                    nameFilters.add('%'+ namePart + '%');
                }
            }
        }
        ExistingAccounts = new Map<Id,Account>(
            [select Id, Name
             from Account
             where name LIKE :nameFilters 
            ]);
        
        Accounts.addAll(ExistingAccounts.values());
        for(Lead newLead : newLeads){
            newLead.Possible_matched_Accounts__c = null;
            for(Account acc : Accounts){
                {
                    IF(newLead.Possible_matched_Accounts__c == null){
                        newLead.Possible_matched_Accounts__c = acc.Name+'; \n';
                    }else{newLead.Possible_matched_Accounts__c += acc.Name+'; \n';}
                }  
            }
        }       
    }

    private Set<String> getCompanyNamesSet (List<Lead> newLeads){
        Set<String> resultSet = new Set<String>();
        for (Lead newLead : newLeads){
            resultSet.add(newLead.Company);
        }
        return resultSet;
    }*/
    /*
    private Set<String> getFullNamesSet (List<Lead> newLeads){
        Set<String> resultSet = new Set<String>();
        for (Lead newLead : newLeads){
            resultSet.add(newLead.LastName+' '+newLead.FirstName);
        }
        return resultSet;
    }
   
    private Set<Id> getMasterRecordId (List<Lead> deletedLeads){
        Set<Id> resultSet = new Set<Id>();
        for(lead l :deletedLeads){
            resultSet.add(l.MasterRecordId);
        }
        return resultSet;
    }
   
    private Set<String> getEmailsSet (List<Lead> newLeads){
        Set<String> resultSet = new Set<String>();
        for (Lead newLead : newLeads){
            if(String.isNotEmpty(newLead.email)){
                resultSet.add(newLead.Email);
            }
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
   /*
    private Map<String, Lead> makeLeadsByName(List<Lead> leads) {
        Map<String, Lead> resultMap = new Map<String, Lead>();
        for (Lead currentLead : leads) {
            resultMap.put(currentLead.FirstName+' '+currentLead.LastName, currentLead);
        }
        return resultMap;
    }
   
    public void PossibleMatchLeads(List<Lead> newLeads){
        List<Lead> existingLeadsList = new List<Lead>();
        List<Task> tasksForMatching = new List<Task>();
        Map<Id,Lead> newLeadsById = new Map<Id,Lead>(newLeads);
        
        Set<String> fullNames = getFullNamesSet(newLeads);
        Set<String> emails = getEmailsSet(newLeads);
        existingLeads = new Map<ID,Lead>([SELECT Id, FirstName, LastName, Email, IsConverted from Lead where (Name In :fullNames OR Email in :emails) AND Id NOT in :newLeadsById.keySet()]);
        existingLeadsList.addAll(existingLeads.values());
        
        if(!existingLeads.isEmpty()){
        for(Lead newLead : newLeads){
            for(Lead l :existingLeadsList){
                if(newLead.FirstName.equals(l.FirstName)&& newLead.LastName.equals(l.LastName)&& newLead.Run_Duplicate_Rules__c && !newLead.IsConverted && !l.IsConverted) {
                    tasksForMatching.add(createTaskForMatching(newLead.FirstName+' '+newLead.LastName,newLead.Id, l.Id));
                }else if(String.isNotEmpty(l.Email) && String.isNotEmpty(newLead.Email) && newLead.Email.equals(l.Email)&& newLead.Run_Duplicate_Rules__c && !newLead.IsConverted && !l.IsConverted){
                    tasksForMatching.add(createTaskForMatching(newLead.FirstName+' '+newLead.LastName,newLead.Id, l.Id));
                }
                
            }
        }
        }else{System.debug('existingList is empty!!!');}
        if(!tasksForMatching.isEmpty()){
            insert tasksForMatching;
        }
    }
    
    public Task createTaskForMatching(String firstLeadName,Id firstLeadId, id secondLeadId){
        Task result = new Task();
        result.Subject = 'Please take a look on '+firstLeadName+' . Possible duplicate !';
        result.WhoId = firstLeadId;
        String baseUrl = System.Url.getSalesforceBaseUrl().toExternalForm()+'/lead/leadmergewizard.jsp?goNext=Merge+Leads&cid='+firstLeadId+'&cid='+secondLeadId ;
        result.Description = 'Link to wizard - '+ baseUrl;
        return result;
    }


    public static void LeadAssign(Map<Id,Id> LeadIds){

        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
        List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
        List<Id> KeysLeads = new List<id>(LeadIds.keySet());
        for(id currentlead: KeysLeads){
            Database.LeadConvert Leadconvert = new Database.LeadConvert();
            Leadconvert.setLeadId(currentlead);                
            Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel);
            Leadconvert.setDoNotCreateOpportunity(TRUE);
            Leadconvert.setAccountId(LeadIds.get(currentLead));  
            MassLeadconvert.add(Leadconvert);
        }
        
        if (!MassLeadconvert.isEmpty()) {
            List<Database.LeadConvertResult> lcr = Database.convertLead(MassLeadconvert);
        }
    }*/
    
    public void assignLeadDate(List<Lead> inputList){
        for(Lead itemLead : inputList) {
            if(itemLead.Qual_Date__c  != null && itemLead.PreQual_Date__c  == null) {
                itemLead.PreQual_Date__c = Date.today();
            }
            if(itemLead.Quoted_Date__c != null && itemLead.PreQual_Date__c  == null) {
                itemLead.PreQual_Date__c = Date.today();
            }
            if(itemLead.Quoted_Date__c != null && itemLead.Qual_Date__c  == null) {
               // itemLead.Qual_Date__c = Date.today();
            }
        }
    }

    public static void updateEmailAndContact(List<Lead> inputList, Map<Id, Lead> oldMap) {
        Map<Id, Contact> mapOfContacts = new Map<Id, Contact>();
        Set<Id> setOfIds = new Set<Id>();
        for(Lead itemLead : inputList){
            if(itemLead.Property_Owner_Main_Contact__c != null && itemLead.Property_Owner_Main_Contact__c != oldMap.get(itemLead.Id).Property_Owner_Main_Contact__c) {
                setOfIds.add(itemLead.Property_Owner_Main_Contact__c);
            }
        }
        for(Contact itemContact : [SELECT Id, Email, Phone FROM Contact WHERE ID IN : setOfIds]) {
            mapOfContacts.put(itemContact.Id, itemContact);
        }
        for(Lead itemLead : inputList) {
            if(mapOfContacts.containsKey(itemLead.Property_Owner_Main_Contact__c)) {
                itemLead.Email = mapOfContacts.get(itemLead.Property_Owner_Main_Contact__c).Email;
                itemLead.Phone = mapOfContacts.get(itemLead.Property_Owner_Main_Contact__c).Phone;
            }
        }
    }

}