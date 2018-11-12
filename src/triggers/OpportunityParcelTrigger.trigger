/**
 * Created by wendysadeh on 4/27/17.
 */

trigger OpportunityParcelTrigger on Parcel__c (after insert, after update, after delete) {
    TriggerSettings__mdt settings = (TriggerSettings__mdt)ApexHelperUtility.queryCustomMetaType('TriggerSettings__mdt', 'Parcel');
    if(settings.isActive__c){
    // fires after both insert and update
        system.debug('In Trigger.............');
        if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
            OpportunityParcelTriggerHandler.onAfterInsert(Trigger.new, Trigger.newMap);
            OpportunityParcelTriggerHandler.onAfterUpdate(Trigger.new, Trigger.newMap);
            Set<Id> opportunityIds = new Set<Id>();
            for(Parcel__c itemOpp : Trigger.new) {
                opportunityIds.add(itemOpp.Opportunity__c);
            }
            OpportunityRelatedRecordsUpdater.updateChildDate(opportunityIds);
        // fires when records are deleted. may want to do undelete also?
        } else if(Trigger.isDelete && Trigger.isAfter){
            OpportunityParcelTriggerHandler.onAfterDelete(Trigger.oldMap);
        }
    }

}