trigger OpportunityLienTrigger on Lien__c (after insert, after update, after delete) {
    TriggerSettings__mdt settings = (TriggerSettings__mdt)ApexHelperUtility.queryCustomMetaType('TriggerSettings__mdt', 'Lien');
    if(settings.isActive__c) {
    // fires after both insert and update
        system.debug('In Trigger.................');
        if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
        // find the ids of all opportunities that were affected
            Set<Id> opportunityIds = new Set<Id>();
            for (Lien__c lien : [select Id, Opportunity__c from Lien__c where Id IN :Trigger.newMap.keySet()]){
                opportunityIds.add(lien.Opportunity__c);
            }
            OpportunityLienTriggerHandler.ProcessLienAsync(opportunityIds);
            OpportunityRelatedRecordsUpdater.updateChildDate(opportunityIds);
        // fires when records are deleted. may want to do undelete also?
        } else if(Trigger.isDelete && Trigger.isAfter){
            Set<Id> opportunityIds = new Set<Id>();
            for (ID id : Trigger.oldMap.keySet()){
                opportunityIds.add(Trigger.oldMap.get(id).Opportunity__c);
            }
            OpportunityLienTriggerHandler.ProcessLienAsync(opportunityIds);
        }
    }
}