public class OpportunityEgnyteHandler {
    
    public static void onAfterUpdate(List<Opportunity> inputList, Map<Id, Opportunity> oldMap) {
        processEgnyteFoldersUpdate(inputList, oldMap);
    }
    
     public static void onAfterInsert(List<Opportunity> inputList) {
        processEgnyteFoldersInsert(inputList);
    }
        
    private static void processEgnyteFoldersUpdate(List<Opportunity> inputList, Map<Id, Opportunity> oldMap) {
        Map<String, String> mapOfAvailableStages = new Map<String, String>{'Dead'=>'Dead-Lost','Dormant'=>'Dormant','Closed'=>'Closed'};
        for(Opportunity itemOpp : inputList) {
            String fromFolder = '';
            String tofolder = '';
            if(!mapOfAvailableStages.containsKey(mapOfAvailableStages.get(oldMap.get(itemOpp.Id).StageName))) {
                fromFolder+='Active/';
            } else {
                fromFolder+=mapOfAvailableStages.get(oldMap.get(itemOpp.Id).StageName)+'/';
            }
            if( oldMap.get(itemOpp.Id).StageName != itemOpp.StageName && mapOfAvailableStages.containsKey(itemOpp.StageName)){
               fromFolder +=EncodingUtil.urlEncode(oldMap.get(itemOpp.Id).Name, 'UTF-8');
               tofolder += mapOfAvailableStages.get(itemOpp.StageName)+'/'+EncodingUtil.urlEncode(itemOpp.Name, 'UTF-8');
            } else {
               fromFolder += EncodingUtil.urlEncode(oldMap.get(itemOpp.Id).Name, 'UTF-8');
               tofolder += 'Active/'+EncodingUtil.urlEncode(itemOpp.Name, 'UTF-8');
            }
            if(oldMap.get(itemOpp.Id).StageName != itemOpp.StageName && (oldMap.get(itemOpp.Id).StageName == 'Dormant' || oldMap.get(itemOpp.Id).StageName == 'Dead')) {
               fromFolder = mapOfAvailableStages.get(oldMap.get(itemOpp.Id).StageName)+'/'+EncodingUtil.urlEncode(oldMap.get(itemOpp.Id).Name, 'UTF-8');
               tofolder = 'Active/'+EncodingUtil.urlEncode(itemOpp.Name, 'UTF-8');
            }
            System.debug(fromFolder);
            System.debug(tofolder);
            if(!Test.isRunningTest()){
                if(oldMap.get(itemOpp.Id).StageName != itemOpp.StageName){
                    EgnyteAPIHandler.moveFile(fromFolder.replace( '+', '%20'), tofolder.replace( '+', ' '));
                }
            }
        }
    }

    public static void processEgnyteFoldersInsert(List<Opportunity> inputList) {
        Set<String> setOfAvailableStages = new Set<String>{'Dead','Dormant','Closed'};
        for(Opportunity itemOpp : inputList) {
            String folderPath = '';
            if(setOfAvailableStages.contains(itemOpp.StageName)){
                folderPath = itemOpp.StageName+'/'+EncodingUtil.urlEncode(itemOpp.Name, 'UTF-8');
            } else {
                folderPath = 'Active/'+EncodingUtil.urlEncode(itemOpp.Name, 'UTF-8');
            }
            if(!Test.isRunningTest()){
                EgnyteAPIHandler.createFolder(folderPath.replace('+','%20'));
            }
        }
    }

    public static void moveWhenNameIsChanged(List<Opportunity> inputList, Map<Id, Opportunity> oldMap) {
        Map<String, String> mapOfAvailableStages = new Map<String, String>{'Dead'=>'Dead-Lost','Dormant'=>'Dormant','Closed'=>'Closed'};
        for(Opportunity itemOpp : inputList) {
            String fromFolder = '';
            String tofolder = '';
            if(!mapOfAvailableStages.containsKey(mapOfAvailableStages.get(oldMap.get(itemOpp.Id).StageName))) {
                fromFolder+='Active/';
            } else {
                fromFolder+=mapOfAvailableStages.get(oldMap.get(itemOpp.Id).StageName)+'/';
            }
            if( oldMap.get(itemOpp.Id).StageName != itemOpp.StageName && mapOfAvailableStages.containsKey(itemOpp.StageName)){
               fromFolder +=EncodingUtil.urlEncode(oldMap.get(itemOpp.Id).Name, 'UTF-8');
               tofolder += mapOfAvailableStages.get(itemOpp.StageName)+'/'+EncodingUtil.urlEncode(itemOpp.Name, 'UTF-8');
            } else {
               fromFolder += EncodingUtil.urlEncode(oldMap.get(itemOpp.Id).Name, 'UTF-8');
               tofolder += 'Active/'+EncodingUtil.urlEncode(itemOpp.Name, 'UTF-8');
            }
            if(oldMap.get(itemOpp.Id).StageName != itemOpp.StageName && (oldMap.get(itemOpp.Id).StageName == 'Dormant' || oldMap.get(itemOpp.Id).StageName == 'Dead')) {
               fromFolder = mapOfAvailableStages.get(oldMap.get(itemOpp.Id).StageName)+'/'+EncodingUtil.urlEncode(oldMap.get(itemOpp.Id).Name, 'UTF-8');
               tofolder = 'Active/'+EncodingUtil.urlEncode(itemOpp.Name, 'UTF-8');
            }
            System.debug(fromFolder);
            System.debug(tofolder);
            if(!Test.isRunningTest()){
                if(itemOpp.Name != oldMap.get(itemOpp.Id).Name){
                    EgnyteAPIHandler.changeFolderNameOpp(fromFolder.replace( '+', '%20'), tofolder.replace( '+', ' '));
                }
            }
        }
    }

}