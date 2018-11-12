public class CleanQuoteUserCntr  {
    public CleanQuoteUser__c cqUser{get;set;}
    public String objectPicker{get;set;}
    public CleanQuoteUserCntr(ApexPages.StandardController stdController) {
        this.cqUser = (CleanQuoteUser__c)stdController.getRecord();
         cqUser = (CleanQuoteUser__c)ApexHelperUtility.queryAllFieldsObject('CleanQuoteUser__c', cqUser.Id);
    }

    public List<SelectOption> getObjectPickerList() {
        List<SelectOption> listToReturn = new List<SelectOption>();
            listToReturn.add(new SelectOption('none','--None--'));
            listToReturn.add(new SelectOption('accToConvert','Account'));
            listToReturn.add(new SelectOption('contactToConvert','Contact'));
        return listToReturn;
    }

    public String convertContact() {
        Contact contToConvert = checkContactDupe(cqUser);
        if(contToConvert == null) {
            contToConvert = new Contact(
                                                Is_Property_Owner__c = true,
                                                FirstName = cqUser.First_Name__c,
                                                LastName = cqUser.Last_Name__c,
                                                Phone = cqUser.Phone__c,
                                                Email = cqUser.Email__c,
                                                Title = cqUser.Title__c
                                    );
            insert  contToConvert;
        }
        return contToConvert.Id;
    }

    public String convertAccount() {
        Account accToConvert = checkAccountDupe(cqUser);
        if(accToConvert == null) {
            accToConvert = new Account(
                                        AccTypeNew__c = 'Owner',
                                        Name = cqUser.Company_Name__c
                                       );
            insert accToConvert;
        }
        return accToConvert.Id;
    }

    public Contact checkContactDupe(CleanQuoteUser__c inputCQUser) {
        List<Contact> contactToCheck = new List<Contact>([SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE Email = :inputCQUser.Email__c AND FirstName = :inputCQUser.First_Name__c AND LastName = :inputCQUser.Last_Name__c]);
        if(contactToCheck.size() > 0) {
            return contactToCheck[0];
        } else {
            return null;
        }

    }

    public Account checkAccountDupe(CleanQuoteUser__c inputCQUser) {
        String accName = inputCQUser.Company_Name__c;
        String queryAcc = 'SELECT Id, City__c, State__c, Street_Address__c, Zip_Code__c, Entity_Type__c, Type, Name FROM Account WHERE Name = :accName';
        List<Account> accToReturn = new List<Account>();
        queryAcc += ' LIMIT 1';
        accToReturn = Database.query(queryAcc);
        if(accToReturn.size() > 0) {
            return accToReturn[0];
        } else {
            return null;
        }
    }

    public List<Schema.FieldSetMember> getFieldsContact() {
       List<Schema.FieldSetMember> listToReturn = new List<Schema.FieldSetMember>();
       listToReturn = SObjectType.CleanQuoteUser__c.FieldSets.CQContact.getFields();
       return listToReturn;
    }
    
    public List<Schema.FieldSetMember> getFieldsAccount() {
       List<Schema.FieldSetMember> listToReturn = new List<Schema.FieldSetMember>();
       listToReturn = SObjectType.CleanQuoteUser__c.FieldSets.CQAccount.getFields();
       return listToReturn;
    }

    public PageReference convertCQUser() {
        PageReference pageRefToRet = null;
        Savepoint savepoint = Database.setSavepoint();
        try{
            update cqUser;
            if(objectPicker == 'accToConvert') {
                pageRefToRet = new PageReference('/'+convertAccount());
            }
            if(objectPicker == 'contactToConvert') {
                pageRefToRet = new PageReference('/'+convertContact());
            }
        } catch(Exception ex) {
            Database.rollback(savepoint);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }   
        return pageRefToRet;
    }

    public PageReference cancel() {
        return new PageReference('/'+cqUser.Id);
    }
}