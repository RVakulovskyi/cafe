trigger updateTenantSortOrder on Tenant__c (after insert, after update, after delete) {
    TriggerSettings__mdt settings = (TriggerSettings__mdt)ApexHelperUtility.queryCustomMetaType('TriggerSettings__mdt', 'Task');
    if(settings.isActive__c) {
        Set<Id> opportunityIds = new Set<Id>();
        if(TriggerContextUtility.isFirstRun()){
        // get opportunity id to be used as a key to get entire list.
            if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
                TriggerContextUtility.setFirstRunFalse();
                for (Tenant__c tenant : Trigger.new) {
                    opportunityIds.add(tenant.Opportunity__c);
                }
            } else if(Trigger.isDelete && Trigger.isAfter){
                for (Tenant__c tenant : Trigger.old) {
                    opportunityIds.add(tenant.Opportunity__c);
                }
            }
            updateTenantSortOrderHandler.processUpdate(opportunityIds);
        }
        if((Trigger.isUpdate || Trigger.isInsert) && Trigger.isAfter) {
            for(Tenant__c itemTenant : Trigger.new) {
                opportunityIds.add(itemTenant.Opportunity__c);
            }
            OpportunityRelatedRecordsUpdater.updateChildDate(opportunityIds);
        }
    }
}