public class EgnyteIframeController  {
    public  Opportunity oppToView{get;set;}
    public String authCode{get;set;}
    public String redirectUrl{get;set;}
    public Boolean iframeRenderer{get;set;}
    public EgnyteIframeController(ApexPages.StandardController stdController) {
        User userCreds = [SELECT Id, Email  FROM User WHERE id = :UserInfo.getUserId()];
        if(!test.isRunningTest()){
            stdController.addFields(new List<String>{'StageName', 'Name', 'Id'});
        }
        this.oppToView = (Opportunity)stdController.getRecord();
        String folderPath = formFolderString(oppToView);
        Map<String, Object> authCodeMap = new Map<String, Object>();
        if(!Test.isRunningTest()){
            authCodeMap = (Map<String, Object>)Json.deserializeUntyped(EgnyteAPIHandler.navigateToFolder(folderPath, userCreds.Email, 'Projects/'));
        } else {
            authCodeMap.put('redirect', 'test');
        }
        if(!authCodeMap.containsKey('redirect')) {
            iframeRenderer = false;
         } else {
            iframeRenderer = true;
            redirectUrl = String.valueOf(authCodeMap.get('redirect'));
         }
    }

    private String formFolderString(Opportunity inputOpp) {
        String pathToReturn = '';
        Map<String, String> mapOfAvailableStages = new Map<String, String>{'Dead'=>'Dead-Lost','Dormant'=>'Dormant','Closed'=>'Closed'};
        if(mapOfAvailableStages.containsKey(inputOpp.StageName)) {
            pathToReturn+=mapOfAvailableStages.get(inputOpp.StageName)+'/'+inputOpp.Name;
        } else {
            pathToReturn+='Active/'+inputOpp.Name;
        }
        return pathToReturn;
    }
}