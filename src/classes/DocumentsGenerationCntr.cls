public class DocumentsGenerationCntr  {
    
    private static final String METASETTING = 'FieldSetsMap';
    public String generatedLink{get;set;}
    public String picklistValue{get;set;}
    public Map<String, sObject> mapOfMeta = ApexHelperUtility.queryAllMetaByType('Field_Mapping_Setting__mdt');
    public Opportunity inputOpp{get;set;}
    public String url290{get;set;}
    public Account inputAcc{get;set;}
    public Map<String, List<Schema.FieldSetMember>> mapOfFieldSets{get;set;}

    public DocumentsGenerationCntr() {
        String oppId = ApexPages.currentPage().getParameters().get('oppId');
        if(!String.isEmpty(oppId)){
            inputOpp = (Opportunity)ApexHelperUtility.queryAllFieldsObjectWithRelation('Opportunity', oppId, new List<String> {'Account.Entity_Type__c', 'Account.Entity_Sub_Type__c'});
            url290 = URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/29.0/' + UserInfo.getOrganizationId();
            if(inputOpp.AccountId != null){
				inputAcc = [SELECT Id, Entity_Type__c, Entity_Sub_Type__c FROM ACCOUNT WHERE Id = :inputOpp.AccountId];        
            }
    	}
    }

    public List<SelectOption> getDocumentTypes() {
        List<SelectOption> listOFSelecOptions = new List<SelectOption>();
        Map<String, String> mapofFieldMapping = new Map<String, String>();
        List<String> keyList = String.valueOf(mapOfMeta.get(METASETTING).get('FieldList__c')).replace('\r\n', '').split(',');
        for(Integer i = 0; i < keyList.size(); i ++) {
                listOFSelecOptions.add(new SelectOption(keyList[i], keyList[i]));
        }
        return listOFSelecOptions;
    }

    public PageReference returnFieldSetList() {
        if(mapOfFieldSets != null) {
            mapOfFieldSets = null;
            generatedLink = null;
        }
     	mapOfFieldSets = new Map<String, List<Schema.FieldSetMember>>();
        Map<String, sObject> mapOfFieldsetsToStage = ApexHelperUtility.queryAllMetaByTypeLabel('OppDocGenerator__mdt');
        Map<String, List<String>> mapOfStagingFields = new Map<String, List<String>>();
        String fielSetListActive='';
        String listOfFields = '';
        String listOfFieldSets = '';
        if(mapOfFieldsetsToStage.containsKey(picklistValue)) {
            OppDocGenerator__mdt stageCustomMapping = (OppDocGenerator__mdt)mapOfFieldsetsToStage.get(picklistValue);
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
                mapOfFieldSets.put(mapOfFieldSetLabels.get(itemFieldSetName.toLowerCase()), new List<Schema.FieldSetMember>());
                if(opportunityFieldSetsByNames.containsKey(itemFieldSetName.toLowerCase())) {
                    Set<String> setOfFieldsName = new Set<String>();
                    for(String itemString : mapOfStagingFields.get(itemFieldSetName)) {
                        setOfFieldsName.add(itemString);
                    }
                    for(Schema.FieldSetMember itemFieldSetMember :  opportunityFieldSetsByNames.get(itemFieldSetName).getFields()) {
                        if(setOfFieldsName.contains(itemFieldSetMember.getFieldPath())) {
                            mapOfFieldSets.get(mapOfFieldSetLabels.get(itemFieldSetName.toLowerCase())).add(itemFieldSetMember);
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
                        mapOfFieldSets.put(mapOfFieldSetLabels.get(uniqueFieldSet.toLowerCase()), opportunityFieldSetsByNames.get(uniqueFieldSet).getFields());
                    }
                }
            }
            System.debug(mapOfFieldSets);
        }
        return null;
    }

    public PageReference saveOpp() {
        try{
            inputOpp.Probability = getMappedProbability().get(inputOpp.StageName);
        	update inputOpp;
            if(inputOpp.AccountId != null && picklistValue == 'Generate DRL') {
                update inputAcc;
            }
        } catch(Exception ex) {
            
        }
    return null;
    }

    public PageReference back() {
        return new PageReference('/' + inputOpp.Id);
    }

    public void generateButton() {
        generatedLink = 'https://composer.congamerge.com?sessionId=' + UserInfo.getSessionId() + '&serverUrl=' + url290 + '&Id='+inputOpp.Id;
        Map<String, sObject> mapOfFieldsetsToStage = ApexHelperUtility.queryAllMetaByTypeLabel('OppDocGenerator__mdt');
        if(picklistValue == 'Initial App') {
            generatedLink+= generateInitApp(mapOfFieldsetsToStage);
        }
        if(picklistValue == 'Pace Calculator/Term Sheet') {
            generatedLink+= generatePaceCalc(mapOfFieldsetsToStage);
        }
        if(picklistValue == 'Appraisal Engagement') {
            generatedLink+= generateAppEng(mapOfFieldsetsToStage);
        }
        if(picklistValue == 'Screener') {
            generatedLink+= generateScreener(mapOfFieldsetsToStage);
        }
        if(picklistValue == '3rd Party Authorization Form') {
            generatedLink+= generate3Party(mapOfFieldsetsToStage);
        }
        if(picklistValue == 'Generate DRL') {
            generatedLink = '/apex/documentrequestlist?id='+inputOpp.Id;
            generateDocsObjects();
        }
        if(picklistValue == 'DRL Status') {
            generatedLink+= generateDRLStatus(mapOfFieldsetsToStage);
        }
        if(picklistValue == 'Lender Acknowledgement') {
            generatedLink+= generateLenderAcc(mapOfFieldsetsToStage);
        }
        if(picklistValue == 'Memo_Fieldset') {
            generatedLink+= generateMemo(mapOfFieldsetsToStage);
        }
        if(picklistValue == 'CF Payment Instructions') {
            generatedLink+= generateCFPaymentInstruct(mapOfFieldsetsToStage);
        }
        if(picklistValue == 'LOI') {
           generatedLink+= generateLOI(mapOfFieldsetsToStage);
        }
        if(picklistValue == 'Solar/Pace Calculator') {
           generatedLink+= generateSolarPace(mapOfFieldsetsToStage);
        }
        if(picklistValue == 'Bond Commitment Letter') {
 			generatedLink+= generateBondCom(mapOfFieldsetsToStage);
        } 
        if(picklistValue == 'Additional Asset Transfer Form') {
           generatedLink+= generateAddAsset(mapOfFieldsetsToStage);
        } 
        if(picklistValue == 'Approval Package Cover Letter') {
           generatedLink+= generateApprPack(mapOfFieldsetsToStage);
        } 
    }

    private String generateInitApp(Map<String, sObject> mapOfFieldsetsToStage) {
        OppDocGenerator__mdt stageCustomMapping = (OppDocGenerator__mdt)mapOfFieldsetsToStage.get(picklistValue);
        String genLink =  '&TemplateId='+stageCustomMapping.CongaId__c ;
        genLink+= '&DocuSignVisible=1';
        genLink+= '&DefaultPDF=1';
        genLink+= '&DocuSignR1ID='+inputOpp.Property_Owner_Main_Contact__c;
        genLink+= '&DocuSignR1Role=Signer+1';
        genLink+= '&DocuSignR1Type=Signer'; 
        genLink+= '&DocuSignR1RoutingOrder=1';
        genLink+= '&SC0=1'; 
        genLink+= '&SC1=Attachments'; 
        genLink+= '&DocuSignR2ID='+inputOpp.OwnerId;
        genLink+= '&DocuSignR2Role=Signer+2';
        genLink+= '&DocuSignR2Type=Signer'; 
        genLink+= '&DocuSignR2RoutingOrder=2';
    return genLink;
    }

    private String generatePaceCalc(Map<String, sObject> mapOfFieldsetsToStage) {
        OppDocGenerator__mdt stageCustomMapping = (OppDocGenerator__mdt)mapOfFieldsetsToStage.get(picklistValue);
        String genLink =  '&TemplateId='+stageCustomMapping.CongaId__c ;

    return genLink;
    }

    private String generateAppEng(Map<String, sObject> mapOfFieldsetsToStage) {
        OppDocGenerator__mdt stageCustomMapping = (OppDocGenerator__mdt)mapOfFieldsetsToStage.get(picklistValue);
        String genLink =  '&TemplateId='+stageCustomMapping.CongaId__c;
        genLink+='&QueryId=[Appraiser]a0Z0a00000GhO8V';
		genLink+='&DocuSignVisible=1';
		genLink+='&DefaultPDF=1';
		genLink+='&DocuSignR1ID='+inputOpp.Appraiser_Name__c;
		genLink+='&DocuSignR1Role=Signer+1';
		genLink+='&DocuSignR1Type=Signer';
		genLink+='&DocuSignR1RoutingOrder=1';
		genLink+='&DocuSignR2ID=005j000000BcK7M';
		genLink+='&DocuSignR2Role=Signer+2';
		genLink+='&DocuSignR2Type=Signer';
		genLink+='&DocuSignR2RoutingOrder=2';
		genLink+='&DocuSignR3ID=0030a00001v2h2K';
		genLink+='&DocuSignR3Role=Signer+3';
		genLink+='&DocuSignR3Type=Carbon+Copy';
		genLink+='&DocuSignR3RoutingOrder=3';
        genLink+='&DocuSignExpireIn=7';
		genLink+='&SC0=1';
		genLink+='&SC1=Attachments';
		genLink+='&DocuSignEmailSubject=CleanFund+Appraisal+Engagement+Letter';
		genLink+='&DocuSignEmailBody=Please see the attached appraisal engagement letter. If you have any questions or concerns, please contact me at (415) 256-8000 or Matt.Mustaro@CleanFund.com.';
        return genLink;
    }

    private String generateScreener(Map<String, sObject> mapOfFieldsetsToStage) {
        OppDocGenerator__mdt stageCustomMapping = (OppDocGenerator__mdt)mapOfFieldsetsToStage.get(picklistValue);
        String genLink =  '&TemplateId='+stageCustomMapping.CongaId__c ;
        genLink+= '&QueryId=[PARCEL]a0Z0a00000EFiAV,[LIEN]a0Z0a00000EFikn';
    return genLink;
    }

    private String generateLOI(Map<String, sObject> mapOfFieldsetsToStage) {
        OppDocGenerator__mdt stageCustomMapping = (OppDocGenerator__mdt)mapOfFieldsetsToStage.get(picklistValue);
        String genLink =  '&TemplateId='+stageCustomMapping.CongaId__c ;
        genLink+= '&QueryId=[LIEN]a0Z0a00000EFikn,[Signer]a0Z0a00000GhO3L'; 
        genLink+= '&DocuSignVisible=1'; 
        genLink+= '&DefaultPDF=1'; 
        genLink+= '&DocuSignR1ID='+inputOpp.LOI_Approver__c;
        genLink+= '&DocuSignR1Role=Signer+1'; 
        genLink+= '&DocuSignR1Type=Signer'; 
        genLink+= '&DocuSignR1RoutingOrder=1'; 
        genLink+= 'DocuSignR2ID='+inputOpp.LOI_Signer__c; 
        genLink+= '&DocuSignR2Role=Signer+2'; 
        genLink+= '&DocuSignR2Type=Signer'; 
        genLink+= '&DocuSignR2RoutingOrder=2'; 
        genLink+= '&DocuSignR3ID='+inputOpp.Property_Owner_Main_Contact__c;
        genLink+= '&DocuSignR3Role=Signer+3'; 
        genLink+= '&DocuSignR3Type=Signer'; 
        genLink+= '&DocuSignR3RoutingOrder=3';
        genLink+= '&SC0=1'; 
        genLink+= '&SC1=Attachments';
    return genLink;
    }

    private String generateDRL(Map<String, sObject> mapOfFieldsetsToStage) {
    return null;
    }

    private String generateDRLStatus(Map<String, sObject> mapOfFieldsetsToStage) {
        OppDocGenerator__mdt stageCustomMapping = (OppDocGenerator__mdt)mapOfFieldsetsToStage.get(picklistValue);
        String genLink =  '&TemplateId='+stageCustomMapping.CongaId__c ;
        genLink += '&QueryId=[STAGE1]a0Z0a00000GUYa2,[STAGE2]a0Z0a00000GUYaH, [STAGE3]a0Z0a00000GUYaM, [STAGE4]a0Z0a00000GUYaR, [STAGE5]a0Z0a00000GUYaW';  
    return genLink;
    }

    private String generate3Party(Map<String, sObject> mapOfFieldsetsToStage) {
        OppDocGenerator__mdt stageCustomMapping = (OppDocGenerator__mdt)mapOfFieldsetsToStage.get(picklistValue);
        String genLink =  '&TemplateId='+stageCustomMapping.CongaId__c ;
        genLink+= '&QueryId=[LIEN]a0Z0a00000EFikn,[Signer]a0Z0a00000GhO3L';
        genLink+= '&DocuSignVisible=1';
        genLink+= '&DefaultPDF=1';
        genLink+= '&DocuSignR1ID=' + inputOpp.Property_Owner_Main_Contact__c;
        genLink+= '&DocuSignR1Role=Signer+1';
        genLink+= '&DocuSignR1Type=Signer';
        genLink+= '&DocuSignR1RoutingOrder=1';
        genLink+= '&DocuSignR2ID=' + inputOpp.Co_Borrower_2__c;
        genLink+= '&DocuSignR2Role=Signer+2';
        genLink+= '&DocuSignR2Type=Signer';
        genLink+= '&DocuSignR2RoutingOrder=2';
        genLink+= '&SC0=1';
        genLink+= '&SC1=Attachments';
        genLink+= '&DocuSignEmailSubject=Third+Party+Authorization+Form';
        genLink+= '&DocuSignEmailBody=Enter+Body+here';
    return genLink;
    }

    private String generateLenderAcc(Map<String, sObject> mapOfFieldsetsToStage) {
		OppDocGenerator__mdt stageCustomMapping = (OppDocGenerator__mdt)mapOfFieldsetsToStage.get(picklistValue);
        String genLink =  '&TemplateId='+stageCustomMapping.CongaId__c ;
        genLink+= '&QueryId=[LIEN]a0Z0a00000EFikn'; 
        genLink+= '&DocuSignVisible=1';
        genLink+= '&DefaultPDF=1';
        genLink+= '&DocuSignR1ID='+inputOpp.First_Mortgage_Lender_Contact_Name__c;
        genLink+= '&DocuSignR1Role=Signer+1';
        genLink+= '&DocuSignR1Type=Signer'; 
        genLink+= '&DocuSignR1RoutingOrder=1'; 
        genLink+= '&SC0=1'; 
        genLink+= '&SC1=Attachments';
    return genLink;
    }

    private String generateMemo(Map<String, sObject> mapOfFieldsetsToStage) {
        OppDocGenerator__mdt stageCustomMapping = (OppDocGenerator__mdt)mapOfFieldsetsToStage.get(picklistValue);
        String genLink =  '&TemplateId='+stageCustomMapping.CongaId__c ;
    return genLink;
    }

    private String generateCFPaymentInstruct(Map<String, sObject> mapOfFieldsetsToStage) {
        OppDocGenerator__mdt stageCustomMapping = (OppDocGenerator__mdt)mapOfFieldsetsToStage.get(picklistValue);
        String genLink =  '&TemplateId='+stageCustomMapping.CongaId__c ;
    return null;
    }
    
    private String generateSolarPace(Map<String, sObject> mapOfFieldsetsToStage) {
        OppDocGenerator__mdt stageCustomMapping = (OppDocGenerator__mdt)mapOfFieldsetsToStage.get(picklistValue);
        String genLink =  '&TemplateId='+stageCustomMapping.CongaId__c;
    return genLink;
    }
    
    private void generateDocsObjects() {
        DocumentRequestListUtilities.generateDocumentRequestList(inputOpp.Id);
    }
    
    private String generateBondCom(Map<String, sObject> mapOfFieldsetsToStage) {
        OppDocGenerator__mdt stageCustomMapping = (OppDocGenerator__mdt)mapOfFieldsetsToStage.get(picklistValue);
        String genLink =  '&TemplateId='+stageCustomMapping.CongaId__c ;
        return genLink;
    }
    
    private String generateAddAsset(Map<String, sObject> mapOfFieldsetsToStage) {
        OppDocGenerator__mdt stageCustomMapping = (OppDocGenerator__mdt)mapOfFieldsetsToStage.get(picklistValue);
        String genLink =  '&TemplateId='+stageCustomMapping.CongaId__c ;
        return genLink;
    }
    
    private String generateApprPack(Map<String, sObject> mapOfFieldsetsToStage) {
        OppDocGenerator__mdt stageCustomMapping = (OppDocGenerator__mdt)mapOfFieldsetsToStage.get(picklistValue);
        String genLink =  '&TemplateId='+stageCustomMapping.CongaId__c ;
        return genLink;
    }
    
    private Map<String, Decimal> getMappedProbability() {
        Map<String, Decimal> probabilityStageNameMap = new Map<String, Decimal>();
        for (OpportunityStage oppStage : [SELECT MasterLabel, DefaultProbability FROM OpportunityStage]) {
      		probabilityStageNameMap.put(oppStage.MasterLabel, oppStage.DefaultProbability);
     	}	
        return probabilityStageNameMap;
    }  
}