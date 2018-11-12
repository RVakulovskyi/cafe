public with sharing class OpportunityEditController {

    private ApexPages.StandardController standardController;

    public List<FieldSet> fieldSets {
        get {
            return this.getEditPageFieldSets(this.getOpportunityEditPageFieldSets());
        }
        
    }
    public Opportunity editedOpportunity {
        get; set;
    }

    public OpportunityEditController(ApexPages.StandardController standardController) {
        this.standardController = standardController;
        List<String> fields = this.getSelectedFieldNames(this.fieldSets);

        if (!Test.isRunningTest()) standardController.addFields(fields);
        this.editedOpportunity = (Opportunity) standardController.getRecord();
    }

    public PageReference saveAndNew() {
//        this.standardController.save();
        upsert this.editedOpportunity;
        String retUrl = '?' + ApexPages.currentPage().getParameters().get('retURL');
        PageReference newRecordReference = new PageReference('/006/e' + (String.isEmpty(retUrl) ? '' : retUrl));
        newRecordReference.setRedirect(true);
        return newRecordReference;
    }

    private List<Opportunity_Edit_Page_Fieldset__mdt> getOpportunityEditPageFieldSets() {
        List<Opportunity_Edit_Page_Fieldset__mdt> settings = [
                SELECT Id
                    , Field_Set_Api_Name__c
                    , Index__c
                    , Label
                FROM Opportunity_Edit_Page_Fieldset__mdt
                ORDER BY Index__c ASC
        ];

        return settings;
    }

    private List<FieldSet> getEditPageFieldSets(List<Opportunity_Edit_Page_Fieldset__mdt> settings) {
        List<FieldSet> resultList = new List<FieldSet>();
        Map<String, FieldSet> opportunityFieldSetsByNames = Opportunity.getSObjectType()
                                                                        .getDescribe()
                                                                        .fieldSets
                                                                        .getMap();

        for (Opportunity_Edit_Page_Fieldset__mdt setting : settings) {
            FieldSet relatedFieldSet = opportunityFieldSetsByNames.get(setting.Field_Set_Api_Name__c);
            resultList.add(relatedFieldSet);
        }
        
        return resultList;
    }

    private List<String> getSelectedFieldNames(List<FieldSet> fieldSets) {
        Set<String> fieldNames = new Set<String>();
        if(!fieldSets.isEmpty()){
        for (FieldSet currentFieldSet : fieldSets) {
            List<FieldSetMember> fieldSetMembers = currentFieldSet.getFields();
            fieldNames.addAll(this.getFieldNamesFromFieldSetMembers(fieldSetMembers));
        }
        }
        return new List<String>(fieldNames);
    }

    private List<String> getFieldNamesFromFieldSetMembers(List<FieldSetMember> fieldSetMembers) {
        List<String> resultList = new List<String>();
        if(!fieldSetMembers.isEmpty()){
        for (FieldSetMember member : fieldSetMembers) {
            resultList.add(member.getFieldPath());
        }
        }
        return resultList;
    }

    public class OpportunityEditException extends Exception {}
}