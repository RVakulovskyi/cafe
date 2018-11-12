public class LeadUpdateStageCntr  {
    public Lead inputLead{get;set;}
    public String stageName{get;set;}
    public List<Schema.FieldSetMember> listOfFieldSetMember{get;set;}
    
    public LeadUpdateStageCntr(ApexPages.StandardController stdController) {
         this.inputLead = (Lead)stdController.getRecord();
         inputLead = (lead)ApexHelperUtility.queryAllFieldsObject('Lead', inputLead.Id);       
    } 

    public void renderFields() {
        Set<String> setOfNoStage = new Set<String>{'Solar_Information', 'Application_Information'};
        if(!setOfNoStage.contains(stageName)) {
            inputLead.Stage__c = stageName;
        }
        Map<String, FieldSet> leadFieldSetsByNames = Lead.getSObjectType().getDescribe().fieldSets.getMap();
        Map<String, String> mapOfStageNamesAndFieldSets = new Map<String, String>{'Pre-Qualified Lead'=>'Pre_Qualified_Lead', 'Qualified Lead'=>'Qualified_Lead', 'Dead/Lost' =>'Dead_Lost'};
        if(leadFieldSetsByNames.containsKey(stageName)) {
            listOfFieldSetMember = leadFieldSetsByNames.get(stageName).getFields();
        }
        if(mapOfStageNamesAndFieldSets.containsKey(stageName)) {
            listOfFieldSetMember = leadFieldSetsByNames.get(mapOfStageNamesAndFieldSets.get(stageName)).getFields();
        }
    }

    public  List<SelectOption> getStageValues() {
        List<SelectOption> listToReturn = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Lead.Stage__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            listToReturn.add(new SelectOption(pickListVal.getLabel(), pickListVal.getValue()));
        }
        listToReturn.add(new SelectOption('Solar_Information','Solar Information'));
        listToReturn.add(new SelectOption('Application_Information','Application Information'));
        listToReturn.sort();
    return listToReturn;
    }

    public PageReference saveLead() {
        try{
            inputLead.Stage__c = stageName;
            update inputLead;
            return new PageReference('/'+inputLead.Id);
        } catch (Exception ex) {
            return null;
        }
    }

    public PageReference closePage() {
        return new PageReference('/' + inputLead.Id);
    }
}