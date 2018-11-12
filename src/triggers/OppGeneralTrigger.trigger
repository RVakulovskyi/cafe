/**
 * 12.08.2018 Rodion Vakulovskyi general trigger for Opportunity
 */
trigger OppGeneralTrigger on Opportunity (before insert, before update, after insert, after update, after delete, after undelete) {
    @testVisible TriggerSettings__mdt settings = (TriggerSettings__mdt)ApexHelperUtility.queryCustomMetaType('TriggerSettings__mdt', 'Opportunity');
    if(settings.isActive__c){
        if(Trigger.isAfter) {
            if(Trigger.isInsert) {
                AddContactRoleTrgHandler.onAfterInsert(Trigger.new);
                AssesstmentContactCountHandler.onAfterInsert(Trigger.new);
                BondCostRollupHandler.onAfterInsert(Trigger.new);
                BondRollupHandler.onAfterInsert(Trigger.new);
                PrepaymentStepCreationTrgHandler.onAfterInsert(Trigger.new);
                OpportunityEgnyteHandler.onAfterInsert(Trigger.new);
            }
            if(Trigger.IsUpdate) {
                    AddContactRoleTrgHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
                    AssesstmentContactCountHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
                    BondCostRollupHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
                    BondRollupHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
                    PrepaymentStepCreationTrgHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
                    OpportunityEgnyteHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
                    OpportunityEgnyteHandler.moveWhenNameIsChanged(Trigger.new, Trigger.oldMap);
            }
            if(Trigger.isDelete) {
                    AssesstmentContactCountHandler.onAfterDelete(Trigger.old);
                    BondCostRollupHandler.onAfterDelete(Trigger.old);
                    BondRollupHandler.onAfterDelete(Trigger.old);
            }
            if(Trigger.isUndelete) {
                    AssesstmentContactCountHandler.onAfterUndelete(Trigger.new);
                    BondCostRollupHandler.onAfterUndelete(Trigger.new);
                    BondRollupHandler.onAfterUndelete(Trigger.new);
            }  
        }
        if(Trigger.isBefore) {
            if(Trigger.isInsert) {
                OpportunityRelatedRecordsUpdater.updateOppField(Trigger.new);
            }
            if(Trigger.isUpdate) {
                OpportunityRelatedRecordsUpdater.updateOppField(Trigger.new);
            }
        }
    }
}