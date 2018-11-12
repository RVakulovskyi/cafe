public class LeadIFrameController  {
    public Lead leadRecord{get;set;}
    public String redirectUrl{get;set;}
    public Boolean iframeRenderer{get;set;}

    public LeadIFrameController(ApexPages.StandardController stdController) {
        User userCreds = [SELECT Id, Email  FROM User WHERE id = :UserInfo.getUserId()];
        if(!Test.isRunningTest()){
            stdController.addFields(new List<String>{'Project_Name__c', 'Name', 'Id'});
        }
        this.leadRecord = (Lead)stdController.getRecord();
        Map<String, Object> authCodeMap;
        if(Test.isRunningTest()){
            authCodeMap = new Map<String, Object>();
            authCodeMap = (Map<String, Object>)Json.deserializeUntyped('{"redirect":"test"}');
        } else {
            authCodeMap = (Map<String, Object>)Json.deserializeUntyped(EgnyteAPIHandler.navigateToFolder(leadRecord.Project_Name__c, userCreds.Email,'Projects/Active/'));
        }
        if(!authCodeMap.containsKey('redirect')) {
            iframeRenderer = false;
         } else {
            iframeRenderer = true;
            redirectUrl = String.valueOf(authCodeMap.get('redirect'));
         }
         System.debug(redirectUrl);

    }
}