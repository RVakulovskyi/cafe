/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 * 12.02.2018 Rodion Vakulovskyi modifying class
 **/
trigger dlrs_TaskTrigger on Task
    (before delete, before insert, before update, after delete, after insert, after undelete, after update) {
    
    TriggerSettings__mdt settings = (TriggerSettings__mdt)ApexHelperUtility.queryCustomMetaType('TriggerSettings__mdt', 'Task');
    if(settings.isActive__c) {
    	dlrs.RollupService.triggerHandler();
    }
}