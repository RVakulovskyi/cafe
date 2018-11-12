trigger AttachmentTrigger on Attachment (after insert, after update, before insert, before update)  { 
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            AttachmentTriggerHandler.onAfterInsert(Trigger.new);
        }
    }

}