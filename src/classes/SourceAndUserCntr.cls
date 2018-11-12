public class SourceAndUserCntr {
    public Opportunity inputOpp{get;set;}
    public static final String FIELDLIST = 'List Of Types';
    public static final String TYPELIST = 'Field List';
    Map<String, sObject> mapOfFieldsetsToStage{get;set;}
    public String programAdminFee1{get;set;}
    public String programAdminFee2{get;set;}
    public String legalCouncelFee1{get;set;}
    public String legalCouncelFee2{get;set;}
    public String legalCouncelBondFee1{get;set;}
    public String legalCouncelBondFee2{get;set;}
    public String AgentFee1{get;set;}
    public String AgentFee2{get;set;}
    public String AgentReserveFee1{get;set;}
    public String AgentReserveFee2{get;set;}
    public String sponsorFee1{get;set;}
    public String sponsorResFee1{get;set;}
    public String sponsorMandFee1{get;set;}
    public String sponsorMandFee2{get;set;}
    public String recordationFee1{get;set;}
    public String recordationFee2{get;set;}
    public String taxFee1{get;set;}
    public String taxFee2{get;set;}
    public String govFee{get;set;}
    public String appFee{get;set;}

    
    public SourceAndUserCntr(ApexPages.StandardController stdController) {
        mapOfFieldsetsToStage = ApexHelperUtility.queryAllMetaByTypeLabel('Sources_and_Use__mdt');
        System.debug(mapOfFieldsetsToStage);
        Sources_and_Use__mdt sourceAndUser = (Sources_and_Use__mdt)mapOfFieldsetsToStage.get(TYPELIST);
        List<String> listOfQueryFields = sourceAndUser.Value__c.split(',');
        System.debug(listOfQueryFields);
        if(!Test.isRunningTest()){
        	stdController.addFields(listOfQueryFields);
            this.inputOpp = (Opportunity)stdController.getRecord();
        } else {
            this.inputOpp = (Opportunity)stdController.getRecord();
            this.inputOpp = [SELECT Id, Est_Improvement_Cost__c, CleanFund_Fee_Orig_percent__c, Capitalized_interest__c, Financing_Amount__c, Channel_Partner_Fee_Percent__c, State_Prop__c FROM Opportunity WHERE Id = :inputOpp.Id];
        }
        
    }

    public PageReference createSourceAndUser() {
        PageReference pageRef;
        List<Sources_Uses__c> listToInsert = new List<Sources_Uses__c>();
        Sources_and_Use__mdt sourceAndUser = (Sources_and_Use__mdt)mapOfFieldsetsToStage.get(FIELDLIST);
        try{
            inputOpp.Est_Improvement_Cost__c = inputOpp.Est_Improvement_Cost__c != null ? inputOpp.Est_Improvement_Cost__c : 0;
        	for(String itemString : sourceAndUser.Value__c.split(',')) {
                if(itemString == 'CleanFund Financing Fee') {
                    Decimal amount = inputOpp.Est_Improvement_Cost__c * inputOpp.CleanFund_Fee_Orig_percent__c != null ? inputOpp.Est_Improvement_Cost__c * inputOpp.CleanFund_Fee_Orig_percent__c : 0;
                    if(amount != 0) {
                    	listToInsert.add(formSourceAndUseRecord(inputOpp.Id, 'Cost of Issuance', true, '', 'CleanFund Commercial PACE Capital', 'Use', itemString, amount));
                    }
                }
                if(itemString == 'Program Administration Fee') {
                    Decimal amount = Decimal.valueOf(programAdminFee1)/100 * inputOpp.Est_Improvement_Cost__c  + Decimal.valueOf(programAdminFee2);
                    if(amount != 0) {
                    	listToInsert.add(formSourceAndUseRecord(inputOpp.Id, 'Cost of Issuance', true, '', '', 'Use', itemString, amount));
                    }
                }
                if(itemString == 'Capitalized Interest') {
                    Decimal amount = inputOpp.Capitalized_interest__c != null ? inputOpp.Capitalized_interest__c : 0;//Capitalized_interest__c
                    if(amount != 0) {
                    	listToInsert.add(formSourceAndUseRecord(inputOpp.Id, 'Capitalized Interest Sub-Account', true, '', '', 'Use', itemString, amount));
                    }
                }
                if(itemString == 'Issuer Legal Counsel (at close)') {
                    Decimal amount = (Decimal.valueOf(legalCouncelFee1)/100 * inputOpp.Est_Improvement_Cost__c) + Decimal.valueOf(legalCouncelFee2);
                    if(amount != 0) {
                    	listToInsert.add(formSourceAndUseRecord(inputOpp.Id, 'Cost of Issuance', true, '', '', 'Use', itemString, amount));
                    }
                }
                if(itemString == 'Issuer Legal Counsel (Bond Reserve)') {
                    Decimal amount = (Decimal.valueOf(legalCouncelBondFee1)/100 * inputOpp.Est_Improvement_Cost__c) + Decimal.valueOf(legalCouncelBondFee2);
                    if(amount != 0) {
                    	listToInsert.add(formSourceAndUseRecord(inputOpp.Id, 'Bond Reserve', true, '', '', 'Use', itemString, amount));
                    }
                }
                if(itemString == 'Appraisal Reimbursement') {
                    Decimal amount = Decimal.valueOf(appFee);//Appraisal Fee
                    if(amount != 0) {
                    	listToInsert.add(formSourceAndUseRecord(inputOpp.Id, 'Cost of Issuance', true, 'Only if we are reimbursing the appraisal fee through financing (users responsibility)', 'Property Owner/CleanFund', 'Use', itemString, amount));
                    }
                }
                if(itemString == 'CDIAC Fee (Bond Reserve)') {
                    Decimal amount = inputOpp.Financing_Amount__c != null ? (0.0025 * inputOpp.Financing_Amount__c) : 0;
                    if(amount != 0) {
                    	listToInsert.add(formSourceAndUseRecord(inputOpp.Id, 'Bond Reserve', true, '', 'CDIAC', 'Use', itemString, amount));
                    }
                }
                if(itemString == 'Channel Partner Fee') {
                    Decimal amount = inputOpp.Channel_Partner_Fee_Percent__c * inputOpp.Est_Improvement_Cost__c;
                    if(amount != 0) {
                        listToInsert.add(formSourceAndUseRecord(inputOpp.Id, 'Cost of Issuance', true, '', 'Channel Partner', 'Use', itemString, amount));
                    }
                }
                if(itemString == 'Fiscal Agent (Bond Reserve)') {
                    Decimal amount = Decimal.valueOf(AgentFee1)/100 * inputOpp.Est_Improvement_Cost__c + Decimal.valueOf(AgentFee2);
                    if(amount != 0) {
                    	listToInsert.add(formSourceAndUseRecord(inputOpp.Id, 'Cost of Issuance', true, '', '', 'Use', itemString, amount));
                    }
                }
                if(itemString == 'Fiscal Agent (Reserve)') {
                    Decimal amount = Decimal.valueOf(AgentReserveFee1)/100 * inputOpp.Est_Improvement_Cost__c + Decimal.valueOf(AgentReserveFee2);
                    if(amount != 0) {
                    	listToInsert.add(formSourceAndUseRecord(inputOpp.Id, 'Bond Reserve', true, '', '', 'Use', itemString, amount));
                    }
                }
                 if(itemString == 'PACE Assessment (Total Assessment Amount)') {
                    Decimal amount = inputOpp.Financing_Amount__c!= null ? inputOpp.Financing_Amount__c : 0;
                     if(amount != 0) {
                    listToInsert.add(formSourceAndUseRecord(inputOpp.Id, 'Source', true, '', 'Property Owner', 'Source', itemString, amount));
                     }
                }
                if(itemString == 'Program Sponsor (At Close)') {
                    Decimal amount = Decimal.valueOf(sponsorFee1)/100 * inputOpp.Est_Improvement_Cost__c;
                    if(!String.isEmpty(sponsorMandFee1) && amount < Decimal.valueOf(sponsorMandFee1)) {
                        amount = Decimal.valueOf(sponsorMandFee1);
                    }
                    if(!String.isEmpty(sponsorMandFee2) && amount > Decimal.valueOf(sponsorMandFee2)) {
                        amount = Decimal.valueOf(sponsorMandFee2);
                    }
                    if(amount != 0 && !String.isEmpty(sponsorMandFee2)) {
                    listToInsert.add(formSourceAndUseRecord(inputOpp.Id, 'Cost of Issuance', true, 'Adjust up if below mandatory minimum, adjust down if below mandatory maximum (if min or max are 0, skip this step)', 'Program Sponsor', 'Use', itemString, amount));
                    }
                }
                if(itemString == 'Program Sponsor (Bond Reserve)') {
                    System.debug(sponsorResFee1);
                    Decimal amount = Decimal.valueOf(sponsorResFee1)/100 * inputOpp.Est_Improvement_Cost__c;
                    if(!String.isEmpty(sponsorMandFee1) && amount < Decimal.valueOf(sponsorMandFee1)) {
                        amount = Decimal.valueOf(sponsorMandFee1);
                    }
                    if(!String.isEmpty(sponsorMandFee2) && amount > Decimal.valueOf(sponsorMandFee2)) {
                        amount = Decimal.valueOf(sponsorMandFee2);
                    }
                    if(amount != 0 && !String.isEmpty(sponsorMandFee2)) {
                    	listToInsert.add(formSourceAndUseRecord(inputOpp.Id, 'Bond Reserve', true, 'Adjust up if below mandatory minimum, adjust down if below mandatory maximum (if min or max are 0, skip this step)', 'Program Sponsor', 'Use', itemString, amount));
                    }
                }
                if(itemString == 'Project Amount') {
                    Decimal amount = inputOpp.Est_Improvement_Cost__c != null ? inputOpp.Est_Improvement_Cost__c : 0;
                    if(amount != 0) {
                    	listToInsert.add(formSourceAndUseRecord(inputOpp.Id, 'C-PACE Project Account', true, 'Revisit later for breaking down into component pieces', 'Property Owner', 'Use', itemString, amount));
                    }
                }
                if(itemString == 'Recordation Fee') {
                    Decimal amount = (Decimal.valueOf(recordationFee1)/100 * inputOpp.Est_Improvement_Cost__c) + Decimal.valueOf(recordationFee2);
                    if(amount != 0) {
                    	listToInsert.add(formSourceAndUseRecord(inputOpp.Id, 'Cost of Issuance', true, '', 'Program Administrator', 'Use', itemString, amount));
                    }
                }
                if(itemString == 'Tax Administrator') {
                    Decimal amount = (Decimal.valueOf(taxFee1)/100 * inputOpp.Est_Improvement_Cost__c) + Decimal.valueOf(taxFee2);
                    if(amount != 0 && inputOpp.State_Prop__c  == 'CA') {
                    	listToInsert.add(formSourceAndUseRecord(inputOpp.Id, 'Cost of Issuance', true, 'Only create if Opportunity State = CA', 'Tax Administrator', 'Use', itemString, amount));
                    }
                }
        	}
            insert listToInsert;
            pageRef = new PageReference('/' + inputOpp.Id);
        } catch(Exception ex) {
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ex.getMessage()));
            	System.debug(ex.getMessage());
                pageRef = null;
        }
        return pageRef;
    }
    
    public Pagereference cancel() {
		return new Pagereference('/' + inputOpp.Id);        
    }
    
    private Sources_Uses__c formSourceAndUseRecord(String oppId, String accType, Boolean closingCost, String notes, String party, String sourceOrUse, String sourceUseType, Decimal amount) {
		Sources_Uses__c sourceRecord = new Sources_Uses__c(
            							Opportunity__c  = oppId,
            							Account_Type__c = accType,
            							Closing_Cost__c = closingCost,
            							Notes__c = notes,
            							Party__c = party,
            							Source_Use_Type__c  = sourceUseType,
            							Source_Or_Use__c = sourceOrUse,
            							Amount__c = amount
        								);
     	return sourceRecord;
    }

}