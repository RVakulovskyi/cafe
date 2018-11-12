public class AttachmentTriggerHandler  {

    public static void onAfterInsert(List<Attachment> listOfAttachment) {
        SObjectType customMetaType = Schema.getGlobalDescribe().get('CleanQuote__c');
        String keyPrefix = customMetaType.getDescribe().getKeyPrefix();
        Set<String> setOFCleanQuotes = new Set<String>();
        for(Attachment itemAtt : listOfAttachment) {
            if(String.valueOf(itemAtt.ParentId).startsWith(keyPrefix)) {
                setOFCleanQuotes.add(itemAtt.ParentId);
            }
        }
        List<Attachment> listToInsert = moveAttachmentsToLead(setOFCleanQuotes);
        if(listToInsert.size() > 0) {
            insert listToInsert;
        }

    }

    private static List<Attachment> moveAttachmentsToLead(Set<String> setOFCleanQuotes) {
        System.debug(setOFCleanQuotes);
        Map<Id, Id> mapofQuoteLead = new Map<Id,Id>();
        for(CleanQuote__c itemQuote : [SELECt Id, CQ_Lead__c FROM CleanQuote__c WHERE Id IN :setOFCleanQuotes]) {
            mapofQuoteLead.put(itemQuote.Id, itemQuote.CQ_Lead__c);
        }
        System.debug(mapofQuoteLead);
        Set<String> setOfLeadAttachment = new Set<String>();
        for(Attachment itemAtt : [SELECT Id, Name FROM Attachment WHERE ParentId = :mapofQuoteLead.values()]) {
            setOfLeadAttachment.add(itemAtt.Name);
        }
        List<Attachment> listOfAttachment = new List<Attachment>();
        for(Attachment itemAtt : [SELECT Id, BodyLength, Body, ParentId, ContentType, Description, IsPrivate, IsPartnerShared, Name FROM Attachment WHERE ParentId = :mapofQuoteLead.keySet()]) {
            if(!setOfLeadAttachment.contains(itemAtt.Name)){
                Attachment attInsert = itemAtt.clone(false,false,false,false);
                attInsert.ParentId = mapofQuoteLead.get(itemAtt.ParentId);
                listOfAttachment.add(attInsert);
            }
        }
        return listOfAttachment;
    }
}