trigger AccountTrigger on Account (before insert, before update, after insert, after update, after delete) {
    AccountTriggerHandler ATH = new AccountTriggerHandler();
    TriggerSettings__mdt settings = (TriggerSettings__mdt)ApexHelperUtility.queryCustomMetaType('TriggerSettings__mdt', 'Account');
    if(settings.isActive__c){
        If(Trigger.isBefore){
            if(trigger.isInsert){
             ATH.PossibleMatchName(Trigger.New);
             ContractorDupeCather.onBeforeInsert(Trigger.New);
            } else if (Trigger.isUpdate){
                ATH.PossibleMatchNameOnUpdate(Trigger.New);
                ATH.PossibleMatchAccounts(Trigger.New);
            }
        }
        else
            if(Trigger.isAfter){
                If(Trigger.isInsert){
                  ATH.PossibleMatchAccounts(Trigger.New);
                } else if (Trigger.isDelete){
                    ATH.updateTasksMergeWizardLink(Trigger.old);
                }            
            }
     }
}