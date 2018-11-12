public class LogActivityCntr {
    
    public static final String METASETTINGTASK = 'Task';
    public String activityValue{get;set;}
    public String objId{get;set;}
    public String objName{get;set;}
    public String contId{get;set;}
    public Map<String, sObject> mapOfMetaTask = ApexHelperUtility.queryAllMetaByTypeLabel('HardcodedValueSetting__mdt');
    public Map<String, sObject> mapOfMetaTaskFieldSet = ApexHelperUtility.queryAllMetaByTypeLabel('ActivitySetting__mdt');
    public List<Schema.FieldSetMember> listFieldSetMembers{get;set;}
    public Task taskToInsert{get;set;}
    
    public LogActivityCntr() {
        objId = ApexPages.currentPage().getParameters().get('objId');
        objName = ApexPages.currentPage().getParameters().get('objName');
        contId = ApexPages.currentPage().getParameters().get('contId');
    }
    
    public  PageReference saveTask() {
        try{
        	insert taskToInsert;
            return new PageReference('/' + objId);
        } catch(Exception ex) {
        	System.debug('Error message' + ex.getMessage());
            return null;
        }
    }
    
    public List<SelectOption> getActivityValues() {
        List<SelectOption> listOfSelectOptions = new List<SelectOption>();
        Map<String, String> mapofFieldMapping = new Map<String, String>();
        List<String> selectOptionList = String.valueOf(mapOfMetaTask.get(METASETTINGTASK).get('List_Of_Opps_FieldSets__c')).replace('\r\n', '').split(',');
        for(String itemList : selectOptionList) {
                listOfSelectOptions.add(new SelectOption(itemList, itemList));
        }
    return listOfSelectOptions;   
    }
    
    public void renderFieldSetMembers() {
        taskToInsert = formTask();
        if(listFieldSetMembers != null) {
            listFieldSetMembers = null;
        }
        listFieldSetMembers = new List<Schema.FieldSetMember>();
        Map<String, FieldSet> taskFieldSetsByNames = Task.getSObjectType().getDescribe().fieldSets.getMap();
        List<String> fieldSetList = String.valueOf(mapOfMetaTaskFieldSet.get(activityValue).get('FieldSets__c')).replace('\r\n', '').split(',');
        for(String itemFieldSetName : fieldSetList) {
            if(taskFieldSetsByNames.containsKey(itemFieldSetName)) {
                listFieldSetMembers.addAll(taskFieldSetsByNames.get(itemFieldSetName).getFields());
            }
        }
    }
    
    private Task formTask() {
        Task taskToReturn = new Task(
        							Type  = activityValue,
        							Status = 'Completed',
        							WhatId = objId,
            						Subject = activityValue,
        							OwnerId = UserInfo.getUserId(),
            						ActivityDate = Date.today()
        							); 
        if(!String.isEmpty(contId)) {
            taskToReturn.WhoId = contId;
        }
    return taskToReturn;
    }
    
    public Pagereference back() {
        return new PageReference('/' + objId);
    }
    
    

}