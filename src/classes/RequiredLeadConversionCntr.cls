public class RequiredLeadConversionCntr  {
    public Lead inputLead{get;set;}
    public String objectPicker{get;set;}
    public RequiredLeadConversionCntr(ApexPages.StandardController stdController) {
        this.inputLead = (Lead)stdController.getRecord();
         inputLead = (Lead)ApexHelperUtility.queryAllFieldsObject('Lead', inputLead.Id);
    }

    public PageReference converLead() {
        String objId = '';
        LeadConvertClass leadConvert = new LeadConvertClass();
        Savepoint savepoint = Database.setSavepoint();
        try{
            if(objectPicker == 'aCOToConvert'){
                objId = leadConvert.convertLead(inputLead);
            }
            if(objectPicker == 'aCToConvert'){
                objId = leadConvert.convertLeadAccountAndContact(inputLead);

            }
            if(objectPicker == 'aToConvert'){
                objId = leadConvert.convertLeadAccount(inputLead);
            }
            return new Pagereference('/'+objId);

        } catch(Exception ex) {
            Database.rollback(savepoint);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            System.debug(ex.getMessage());
            objId = inputLead.Id;
            return null;
        }
    }

    public List<SelectOption> getObjectPickerList() {
        List<SelectOption> listToReturn = new List<SelectOption>();
            listToReturn.add(new SelectOption('aToConvert','Contact'));
            listToReturn.add(new SelectOption('aCToConvert','Account and Contact'));
            listToReturn.add(new SelectOption('aCOToConvert','Account, Contact, Opportunity'));
        return listToReturn;
    }

    public List<Schema.FieldSetMember> getFieldsAccount() {
       List<Schema.FieldSetMember> listToReturn = new List<Schema.FieldSetMember>();
       if(objectPicker == 'aCOToConvert'){
            listToReturn = SObjectType.Lead.FieldSets.LeadAccount.getFields();
       }
       if(objectPicker == 'aCToConvert'){
            listToReturn = SObjectType.Lead.FieldSets.LeadContactAccount.getFields();
       }
       if(objectPicker == 'aToConvert'){
            listToReturn = null;
       }
       return listToReturn;
    }
    
    public List<Schema.FieldSetMember> getFieldsContact() {
       List<Schema.FieldSetMember> listToReturn = new List<Schema.FieldSetMember>();
       if(objectPicker == 'aCOToConvert'){
            listToReturn = SObjectType.Lead.FieldSets.LeadRequiredFieldsContact.getFields();
       }
       if(objectPicker == 'aCToConvert'){
            listToReturn = SObjectType.Lead.FieldSets.LeadAccountContact.getFields();
       }
       if(objectPicker == 'aToConvert'){
            listToReturn = SObjectType.Lead.FieldSets.LeadAccount.getFields();
       }
       return listToReturn;
    }
    
    public List<Schema.FieldSetMember> getFieldsOpp() {
       List<Schema.FieldSetMember> listToReturn = new List<Schema.FieldSetMember>();
       if(objectPicker == 'aCOToConvert'){
            listToReturn = SObjectType.Lead.FieldSets.LeadRequiredFieldsOpp.getFields();
       }
       if(objectPicker == 'aCToConvert'){
            listToReturn = null;
       }
       if(objectPicker == 'aToConvert'){
            listToReturn = null;
       }
       return listToReturn;
    }
}