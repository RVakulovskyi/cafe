trigger LeadAutoConvertTrigger on Lead (before insert, before update, after insert, after update) {
    LeadTriggerHandler LTH = new LeadTriggerHandler();
    TriggerSettings__mdt settings = (TriggerSettings__mdt)ApexHelperUtility.queryCustomMetaType('TriggerSettings__mdt', 'Lead');
    if(settings.isActive__c){
        If(Trigger.isBefore){
            if(trigger.isInsert){
              //  LTH.PossibleMatchCompany(Trigger.New);
            } else if (Trigger.isUpdate){
               // LTH.PossibleMatchCompanyOnUpdate(Trigger.New);
				LTH.assignLeadDate(Trigger.New);
                LeadTriggerHandler.updateEmailAndContact(trigger.new, Trigger.oldMap);
            }
        }
        else
            if(Trigger.isAfter){
                If(Trigger.isInsert){
                  //  LTH.AutoConvert(Trigger.New);
                    EgnyteLeadHAndler.createFolderForLead(Trigger.new);
                    //LTH.PossibleMatchLeads(Trigger.New);
                } 
                if (Trigger.isUpdate){
                  //  LTH.AutoConvert(Trigger.New);
                    EgnyteLeadHAndler.changeFolderAndName(Trigger.new, Trigger.oldMap);
                }             
        }
     }
}