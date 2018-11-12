trigger CleanQuoteTrigger on CleanQuote__c (before insert, before update, after insert, after update, after delete) {
    TriggerSettings__mdt settings = (TriggerSettings__mdt)ApexHelperUtility.queryCustomMetaType('TriggerSettings__mdt', 'CleanQuote');
    if(settings.isActive__c){
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                CleanQuoteParserHandler.onBeforeInsert(Trigger.new);
            }
            if(Trigger.isUpdate) {
                CleanQuoteParserHandler.onbeforeUpdate(Trigger.new, Trigger.newMap);
            }
        }
     }

}