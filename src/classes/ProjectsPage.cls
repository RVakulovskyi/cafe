public class ProjectsPage  {
    public Program__c programRecord{get;set;}
    public String redirectUrl{get;set;}
    public Boolean iframeRenderer{get;set;}

    public ProjectsPage(ApexPages.StandardController stdController) {
        User userCreds = [SELECT Id, Email  FROM User WHERE id = :UserInfo.getUserId()];
        Map<String, String> mapOfStatesAndAbbr = initMapOfStates();
        if(!Test.isRunningTest()){
            stdController.addFields(new List<String>{'Egnyte_Folder__c', 'Name', 'Id', 'State__c','ProgramAdminName__c'});
        }
        this.programRecord = (Program__c)stdController.getRecord();
        Map<String, Object> authCodeMap;
        if(Test.isRunningTest()){
            authCodeMap = new Map<String, Object>();
            authCodeMap = (Map<String, Object>)Json.deserializeUntyped('{"redirect":"test"}');
        } 
        if(!Test.isRunningTest()) {
            if(!String.isEmpty(programRecord.Egnyte_Folder__c)) {
                authCodeMap = (Map<String, Object>)Json.deserializeUntyped(EgnyteAPIHandler.navigateToFolder(programRecord.Egnyte_Folder__c, userCreds.Email,'PACE Programs/'));
            }
            if(mapOfStatesAndAbbr.containsKey(programRecord.State__c) && String.isEmpty(programRecord.Egnyte_Folder__c) && !String.isEmpty(programRecord.ProgramAdminName__c)) {
                authCodeMap = (Map<String, Object>)Json.deserializeUntyped(EgnyteAPIHandler.navigateToFolder(mapOfStatesAndAbbr.get(programRecord.State__c)+'/'+programRecord.ProgramAdminName__c, userCreds.Email,'PACE Programs/'));
            }
        }
        if(!authCodeMap.containsKey('redirect')) {
            iframeRenderer = false;
        } else {
            iframeRenderer = true;
            redirectUrl = String.valueOf(authCodeMap.get('redirect'));
         }
         System.debug(redirectUrl);

    }

    public static Map<String, String> initMapOfStates() {
        Map<String, String> mapOfStatesAndAbbr = new Map<String,String>();
        mapOfStatesAndAbbr.put('AK','Alaska');
        mapOfStatesAndAbbr.put('AZ','Arizona');
        mapOfStatesAndAbbr.put('AR','Arkansas');
        mapOfStatesAndAbbr.put('CA','California');
        mapOfStatesAndAbbr.put('CO','Colorado');
        mapOfStatesAndAbbr.put('CT','Connecticut');
        mapOfStatesAndAbbr.put('DE','Delaware');
        mapOfStatesAndAbbr.put('FL','Florida');
        mapOfStatesAndAbbr.put('GA','Georgia');
        mapOfStatesAndAbbr.put('HI','Hawaii');
        mapOfStatesAndAbbr.put('ID','Idaho');
        mapOfStatesAndAbbr.put('IL','Illinois');
        mapOfStatesAndAbbr.put('IN','Indiana');
        mapOfStatesAndAbbr.put('IA','Iowa');
        mapOfStatesAndAbbr.put('KS','Kansas');
        mapOfStatesAndAbbr.put('KY','Kentucky');
        mapOfStatesAndAbbr.put('LA','Louisiana');
        mapOfStatesAndAbbr.put('ME','Maine');
        mapOfStatesAndAbbr.put('MD','Maryland');
        mapOfStatesAndAbbr.put('MA','Massachusetts');
        mapOfStatesAndAbbr.put('MI','Michigan');
        mapOfStatesAndAbbr.put('MN','Minnesota');
        mapOfStatesAndAbbr.put('MS','Mississippi');
        mapOfStatesAndAbbr.put('MO','Missouri');
        mapOfStatesAndAbbr.put('MT','Montana');
        mapOfStatesAndAbbr.put('NE','Nebraska');
        mapOfStatesAndAbbr.put('NV','Nevada');
        mapOfStatesAndAbbr.put('NH','New Hampshire');
        mapOfStatesAndAbbr.put('NJ','New Jersey');
        mapOfStatesAndAbbr.put('NM','New Mexico');
        mapOfStatesAndAbbr.put('NY','New York');
        mapOfStatesAndAbbr.put('NC','North Carolina ');
        mapOfStatesAndAbbr.put('ND','North Dakota');
        mapOfStatesAndAbbr.put('OH','Ohio');
        mapOfStatesAndAbbr.put('OK','Oklahoma');
        mapOfStatesAndAbbr.put('OR','Oregon');
        mapOfStatesAndAbbr.put('PA','Pennsylvania');
        mapOfStatesAndAbbr.put('RI','Rhode Island');
        mapOfStatesAndAbbr.put('SC','South Carolina');
        mapOfStatesAndAbbr.put('SD','South Dakota');
        mapOfStatesAndAbbr.put('TN','Tennessee');
        mapOfStatesAndAbbr.put('TX','Texas');
        mapOfStatesAndAbbr.put('UT','Utah');
        mapOfStatesAndAbbr.put('VT','Vermont');
        mapOfStatesAndAbbr.put('VA','Virginia');
        mapOfStatesAndAbbr.put('WA','Washington');
        mapOfStatesAndAbbr.put('WV','West Virginia ');
        mapOfStatesAndAbbr.put('WI','Wisconsin');
        mapOfStatesAndAbbr.put('WY','Wyoming');
        return mapOfStatesAndAbbr;
    }

}