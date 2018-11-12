public class EgnyteLeadHAndler  {

    public static void createFolderForLead(List<Lead> inputList){
        for(Lead itemLead : inputList) {
            if(!Test.isRunningTest()){
                EgnyteAPIHandler.createFolderLead(EncodingUtil.urlEncode(itemLead.Project_Name__c, 'UTF-8').replace('+','%20'));
            }
        }
    }

    public static void changeFolderAndName(List<Lead> inputList, Map<Id, Lead> oldMap) {
        for(Lead itemLead : inputList){
            if(oldMap.get(itemLead.Id).Project_Name__c != null && itemLead.Project_Name__c != null && itemLead.Project_Name__c != oldMap.get(itemLead.Id).Project_Name__c){
                if(!Test.isRunningTest()){
                    EgnyteAPIHandler.changeFolderNameLead(EncodingUtil.urlEncode(oldMap.get(itemLead.Id).Project_Name__c, 'UTF-8').replace( '+', '%20'), itemLead.Project_Name__c);
                }
            }
        }
    }
}