trigger ContactTrigger on Contact (before insert, before update, after insert, after update) {
    ContactTriggerHandler CTH = new ContactTriggerHandler();
    TriggerSettings__mdt settings = (TriggerSettings__mdt)ApexHelperUtility.queryCustomMetaType('TriggerSettings__mdt', 'Contact');
    if(settings.isActive__c){
        If(Trigger.isBefore){
            if(trigger.isInsert){
                CTH.PossibleMatchName(Trigger.New);
            } else if (Trigger.isUpdate){
                CTH.PossibleMatchNameOnUpdate(Trigger.New);
            }
        }
        else
            if(Trigger.isAfter){
                If(Trigger.isInsert){
                //CTH.PossibleMatchContacts(Trigger.New);
                }            
            }
     }
}