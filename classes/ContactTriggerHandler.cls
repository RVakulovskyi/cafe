public class ContactTriggerHandler {
    Map<ID,Contact> otherContacts;
    Map<Id,Contact> existingContacts;
    /*
    public void updateTasksMergeWizardLink(List<Contact> deletedContacts){
        
        Set<Id> deletedContactsMasterRecordId = getMasterRecordId(deletedContacts);
        List<Task> warningDuplicateTasks = new List<Task>([SELECT Id, Description, WhoId from Task where WhoId in:deletedContactsMasterRecordId]);
        List<Task> tasksToDelete = new List<Task>();
        List<Task> tasksToUpdate = new List<Task>();
        for(Task t :warningDuplicateTasks){
            for(Contact l:deletedContacts){
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
    */
    
    public void PossibleMatchName(List<Contact> newContacts){
        List<Contact> Contacts = new List<Contact>();
        Set<String> NameNames = getNameNamesSet(newContacts);
        Set<String> nameFilters = new Set<String>();
        List<String> partialMatches = new List<String>();
        if(!NameNames.isEmpty()){
            for(string name :NameNames){
                If(name.contains(' ')){
                    for (string namePart : name.split(' ')){
                        nameFilters.add('%'+ namePart + '%');
                    }
                }else{
                    nameFilters.add('%'+ name+'%');
                }
            }
            otherContacts = new Map<Id,Contact>(
                [select Id, Name
                 from Contact
                 where name LIKE :nameFilters 
                ]);
            
            Contacts.addAll(otherContacts.values());
            for(Contact newContact : newContacts){
                for(Contact cont : Contacts){
                    If(cont.Name.containsIgnoreCase(newContact.LastName+' '+newContact.FirstName)){ // && newContact.Run_Duplicate_Rules__c){
                        IF(newContact.Possible_matched_Contacts__c == null){
                            newContact.Possible_matched_Contacts__c = cont.Name+'; \n';
                        }else{newContact.Possible_matched_Contacts__c += cont.Name+'; \n';}
                    }  
                }
            }       
        }else{
            System.debug('Contact should have a name!');
        }
    }
    
    public void PossibleMatchNameOnUpdate(List<Contact> newContacts){
        List<Contact> conts = new List<Contact>();
        Set<String> NameNames = getNameNamesSet(newContacts);
        Set<String> nameFilters = new Set<String>();
        if(!NameNames.isEmpty()){
        for(string name :NameNames){
            for (string namePart : name.split(' ')){
                nameFilters.add('%'+ namePart + '%');
            }
            
        }
        otherContacts = new Map<Id,Contact>(
            [select Id, Name
             from Contact
             where name LIKE :nameFilters 
            ]);
        
        conts.addAll(otherContacts.values());
        for(Contact newContact : newContacts){
            newContact.Possible_matched_Contacts__c = null;
            for(Contact cont : conts){
                {
                    IF(newContact.Possible_matched_Contacts__c == null){
                        newContact.Possible_matched_Contacts__c = cont.Name+'; \n';
                    }else{newContact.Possible_matched_Contacts__c += cont.Name+'; \n';}
                }  
            }
        }
        }else{
            System.debug('Contact should have a name!');
        }        
    }
        
        
    private Set<String> getNameNamesSet (List<Contact> newContacts){
        Set<String> resultSet = new Set<String>();
        for (Contact newContact : newContacts){
            resultSet.add(newContact.LastName+' '+newContact.FirstName);
        }
        return resultSet;
    }
    
    /*
    private Set<Id> getMasterRecordId (List<Contact> deletedContacts){
        Set<Id> resultSet = new Set<Id>();
        for(Contact l :deletedContacts){
            resultSet.add(l.MasterRecordId);
        }
        return resultSet;
    }
    private Set<String> getEmailsSet (List<Contact> newContacts){
        Set<String> resultSet = new Set<String>();
        for (Contact newContact : newContacts){
            if(String.isNotEmpty(newContact.email)){
                resultSet.add(newContact.Email);
            }
        }
        return resultSet;
    }

    /**
    public void PossibleMatchContacts(List<Contact> newContacts){
        List<Contact> existingContactsList = new List<Contact>();
        List<Task> tasksForMatching = new List<Task>();
        Map<Id,Contact> newContactsById = new Map<Id,Contact>(newContacts);
        Set<String> emails = getEmailsSet(newContacts);
        Set<String> fullNames = getNameNamesSet(newContacts);
        existingContacts = new Map<ID,Contact>([SELECT Id, FirstName, LastName,Email from Contact where (Name In :fullNames or Email in :emails) AND Id NOT in :newContactsById.keySet()]);
        If(existingContacts.isEmpty()){ 
            System.debug('Empty List of cont !!');
        } else{
            existingContactsList.addAll(existingContacts.values());
           
            
            for(Contact newContact : newContacts){
                for(Contact l :existingContactsList){
                    if(newContact.FirstName.equals(l.FirstName) && newContact.LastName.equals(l.LastName)){//&& newContact.Run_Duplicate_Rules__c) {
                        tasksForMatching.add(createTaskForMatching(newContact.LastName+' '+newContact.FirstName ,newContact.Id, l.Id));
                        
                    }else{
                        if(newContact.Email.equals(l.Email)){
                            tasksForMatching.add(createTaskForMatching(newContact.LastName+' '+newContact.FirstName ,newContact.Id, l.Id));
                        }
                    }
                    
                }
            }
            if(!tasksForMatching.isEmpty()){
                insert tasksForMatching;
                System.debug('Trying to insert Tasks...');
            }
        }
    }
    
    public Task createTaskForMatching(String firstContactName,Id firstContactId, id secondContactId){
        Task result = new Task();
        result.Subject = 'Please take a look on '+firstContactName+' . Possible duplicate !';
        result.WhoId = firstContactId;
        String baseUrl = System.Url.getSalesforceBaseUrl().toExternalForm()+'/merge/conmergewizard.jsp?goNext=Merge+Contacts&cid='+firstContactId+'&cid='+secondContactId ;
        result.Description = 'Link to wizard - '+ baseUrl;
        return result;
    }
    **/
    
}