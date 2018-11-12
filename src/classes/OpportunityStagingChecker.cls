public class OpportunityStagingChecker  {
    public Opportunity inputOpp{get;set;}
    public String stageName{get;set;}
    public Map<String, List<Schema.FieldSetMember>> listofStagedFields {get;set;}
	public Map<String, sObject> mapOfMeta = ApexHelperUtility.queryAllMetaByTypeLabel('OppRequiredFields__mdt');
    public List<String> requiredFieldsList{get;set;}
    
    public OpportunityStagingChecker(ApexPages.StandardController stdController) {
         this.inputOpp = (Opportunity)stdController.getRecord();
         inputOpp = (Opportunity)ApexHelperUtility.queryAllFieldsObject('Opportunity', inputOpp.Id);
         
    } 

    public PageReference renderFields() {
        System.debug(inputOpp.StageName);
        if(listofStagedFields != null) {
            listofStagedFields = null;
            requiredFieldsList = null;
        }
        if(stageName != 'Pre-LOI' || stageName != 'OpenPACE Sorting Hat'){
        	inputOpp.StageName = stageName;  
        }
        listofStagedFields = new Map<String, List<Schema.FieldSetMember>>();
        Map<String, sObject> mapOfFieldsetsToStage = ApexHelperUtility.queryAllMetaByTypeLabel('Opp_Stage_Mapping__mdt');
        Map<String, List<String>> mapOfStagingFields = new Map<String, List<String>>();
        String fielSetListActive='';
        String listOfFields = '';
        String listOfFieldSets = '';
        if(mapOfFieldsetsToStage.containsKey(stageName)) {
            Opp_Stage_Mapping__mdt stageCustomMapping = (Opp_Stage_Mapping__mdt)mapOfFieldsetsToStage.get(stageName);
            if(!String.isEmpty(stageCustomMapping.FieldList__c)) {
                listOfFields = stageCustomMapping.FieldList__c.replace(' ','').replace('\r\n', '');
                listOfFieldSets = stageCustomMapping.FieldSetName__c;
            }
             
            if(!String.isEmpty(stageCustomMapping.FieldListAdding__c )) {
                listOfFields+=stageCustomMapping.FieldListAdding__c .replace(' ','').replace('\r\n', '');
            }
            if(!String.isEmpty(stageCustomMapping.FieldSetsForOneStage__c)) {
                fielSetListActive = stageCustomMapping.FieldSetsForOneStage__c.replace(' ','').replace('\r\n', '');
            }
            List<String> listOFSplittedFieldSets = listOfFieldSets.split(',');
            List<String> listOfUniqueFieldSets = fielSetListActive.split(',');
            for(Integer i = 0; i < listOFSplittedFieldSets.size(); i++ ) {
               mapOfStagingFields.put(listOFSplittedFieldSets[i], new List<String>());
               List<String> listOfFirstParsedFields = listOfFields.split('////');
               for(String itemFieldListStage : listOfFirstParsedFields[i].split(',')) {
                    mapOfStagingFields.get(listOFSplittedFieldSets[i]).add(itemFieldListStage);
               }
            }
            Map<String, FieldSet> opportunityFieldSetsByNames = Opportunity.getSObjectType().getDescribe().fieldSets.getMap();
            
            Map<String, String> mapOfFieldSetLabels = new Map<String, String>();
            for(String itemString : opportunityFieldSetsByNames.keySet()) {
                mapOfFieldSetLabels.put(itemString, opportunityFieldSetsByNames.get(itemString).getLabel());
            }
            for(String itemFieldSetName  : mapOfStagingFields.keySet()) {
                listofStagedFields.put(mapOfFieldSetLabels.get(itemFieldSetName.toLowerCase()), new List<Schema.FieldSetMember>());
                if(opportunityFieldSetsByNames.containsKey(itemFieldSetName.toLowerCase())) {
                    Set<String> setOfFieldsName = new Set<String>();
                    for(String itemString : mapOfStagingFields.get(itemFieldSetName)) {
                        setOfFieldsName.add(itemString);
                    }
                    for(Schema.FieldSetMember itemFieldSetMember :  opportunityFieldSetsByNames.get(itemFieldSetName).getFields()) {
                        if(setOfFieldsName.contains(itemFieldSetMember.getFieldPath())) {
                            listofStagedFields.get(mapOfFieldSetLabels.get(itemFieldSetName.toLowerCase())).add(itemFieldSetMember);
                        }
                    }
                }
            }
            for(String itemKey : mapOfFieldSetLabels.keySet()) {
                for(String uniqueFieldSet : listOfUniqueFieldSets) {
                    System.debug(uniqueFieldSet.toLowerCase());
                    System.debug(itemKey);
                    if(itemKey == uniqueFieldSet) {
                        System.debug(itemKey);
                        listofStagedFields.put(mapOfFieldSetLabels.get(uniqueFieldSet.toLowerCase()), opportunityFieldSetsByNames.get(uniqueFieldSet).getFields());
                    }
                }
            }
            System.debug(listofStagedFields);
        }
        return null;
    }

    public PageReference saveOpp() {
        requiredFieldsList = getRequiredFields();
        try{
            inputOpp.Probability = getMappedProbability().get(inputOpp.StageName);
    		update inputOpp;
    		return new PageReference('/'+inputOpp.Id);
        } catch (Exception ex) {
            return null;
        }
    }

    public PageReference closePage() {
        return new PageReference('/' + inputOpp.Id);
    }
    
    public static List<SelectOption> getStageValues() {
        List<SelectOption> listToReturn = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			listToReturn.add(new SelectOption(pickListVal.getLabel(), pickListVal.getValue()));
		}
        listToReturn.add(new SelectOption('Pre-LOI', 'Pre-LOI'));
        listToReturn.add(new SelectOption('OpenPACE Sorting Hat', 'OpenPACE Sorting Hat'));
        listToReturn.sort();
    return listToReturn;
    }
    
        
    public List<String> getRequiredFields() {
        List<String> listOfRequiredFields = new List<String>();
        System.debug(mapOfMeta);
        if(inputOpp.LeadSource == 'Channel Partner' &&
           mapOfMeta.containsKey(inputOpp.LeadSource) &&
           (inputOpp.StageName != 'Dead' || inputOpp.StageName != 'Dormant' || inputOpp.StageName != 'Lost')) {
               for(String itemString : String.valueOf(mapOfMeta.get(inputOpp.LeadSource).get('Value__c')).split(',')) {
                   listOfRequiredFields.add(itemString);
               }
        }
        System.debug(listOfRequiredFields);
    return listOfRequiredFields;
    }
    
    private Map<String, Decimal> getMappedProbability() {
        Map<String, Decimal> probabilityStageNameMap = new Map<String, Decimal>();
        for (OpportunityStage oppStage : [SELECT MasterLabel, DefaultProbability FROM OpportunityStage]) {
      		probabilityStageNameMap.put(oppStage.MasterLabel, oppStage.DefaultProbability);
     	}	
        return probabilityStageNameMap;
    }

}