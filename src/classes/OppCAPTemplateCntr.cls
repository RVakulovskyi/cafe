public class OppCAPTemplateCntr  {
    public Opportunity oppItem{get;set;}
    public Exception_Criteria__c exCriteria{get;set;}
    public Account accToGet{get;set;}

    public OppCAPTemplateCntr(ApexPages.StandardController stdController) {
        this.oppItem = (Opportunity)stdController.getRecord();
         oppItem = (Opportunity)ApexHelperUtility.queryAllFieldsObjectOPP('Opportunity', oppItem.Id);
         exCriteria = queryExCriteria(oppItem);
         accToGet = queryOppAcount();
    }

    public List<Schema.FieldSetMember> getFieldsSummary() {
       List<Schema.FieldSetMember> listToReturn = new List<Schema.FieldSetMember>();
       listToReturn = SObjectType.Opportunity.FieldSets.Summary.getFields();
       return listToReturn;
    }

    public List<Schema.FieldSetMember> getFieldsAnalysis() {
       List<Schema.FieldSetMember> listToReturn = new List<Schema.FieldSetMember>();
       listToReturn = SObjectType.Opportunity.FieldSets.Analysis.getFields();
       return listToReturn;
    }

    public List<Schema.FieldSetMember> getFieldsCollateral() {
       List<Schema.FieldSetMember> listToReturn = new List<Schema.FieldSetMember>();
       listToReturn = SObjectType.Opportunity.FieldSets.Collateral.getFields();
       return listToReturn;
    }

    public Exception_Criteria__c queryExCriteria(Opportunity inputOpp) {
        Exception_Criteria__c exCriteriaQueried;
        if(ApexHelperUtility.queryAllFieldsObjectWithRelation('Exception_Criteria__c', inputOpp.Id, new List<String>()) != null){
            exCriteriaQueried = (Exception_Criteria__c)ApexHelperUtility.queryAllFieldsObjectWithRelation('Exception_Criteria__c', inputOpp.Id, new List<String>());
        } else {
            exCriteriaQueried = new Exception_Criteria__c();
        }
        return exCriteriaQueried;
    }

    public PageReference save() {
        upsert oppItem;
        upsert exCriteria;
        return new PageReference('/'+oppItem.Id);
    }

    public PageReference cancel() {
        return new PageReference('/'+oppItem.Id);
    }

    public List<Tenant__c> getTenants() {
        return [SELECT Id, Name, Notes_and_Comments__c, Placeholder_Tenant__c, TenantBySqFtSortOder__c, Tenant_Income__c, Tenant_Lease_Type__c, Tenant_Square_Foot__c FROM Tenant__c WHERE Opportunity__c = :oppItem.Id];
    }

    public List<Lien__c> getLien() {
        return [SELECT Amortization_at_Origination_years__c,Annual_Debt_Service__c,ConnectionReceivedId,ConnectionSentId,CreatedById,CreatedDate,Cross_Collateralized_Defaulted__c,Current_Balance_as_of_Date__c,Current_Loan_Balance__c,Debt_Position__c,Id,Interest_Rate_Type__c,Interest_Rate__c,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Lender_Acknowledgement__c,Lender_Contact__c,Lender_Type__c,Lien_LTV_As_Complete__c,Lien_LTV_As_Is__c,Loan_Number__c,Maturity_Date__c,Months_Interest_only__c,Mortgage_Lender__c,Name,Notes__c,Opportunity__c,Origination_Date__c,Special_Servicer_File__c,Special_Servicer__c,SystemModstamp,Type_of_Lein__c,Type_of_Lender__c FROM Lien__c WHERE Opportunity__c = :oppItem.Id];
    }

    public Account queryOppAcount() {
        List<Account> listOfAccounts = new List<Account>([SELECT Id, Name, Entity_Type__c, Entity_Status__c, Entity_Date_Formed__c, Entity_State__c, Entity_Tax_ID__c, Financial_Crime__c, Public_Records_Search_Date__c, Foreclosure_Short_Sale_Deed_in_Lieu__c, Bankruptcy__c, Litigation__c, Sponsor_Name__c, Entity_Filling__c, Tenants_in_Common__c, Public_Record_Search_Notes__c FROM Account WHERE Id = :oppItem.AccountId]);
        if(listOfAccounts.size() > 0) {
            return listOfAccounts[0];
        } else {
            return null;
        }
    }

}