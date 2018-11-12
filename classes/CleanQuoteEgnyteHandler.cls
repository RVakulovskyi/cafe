public class CleanQuoteEgnyteHandler  {

     public static void uploadAttachmentToEgnyte(List<CleanQuote__c> inputList, Map<Id, CleanQuote__c> newMap) {
        Map<String, List<Attachment>> mapOfAttachments = new Map<String, List<Attachment>>();
        for(Attachment itemQuoteAtt : [SELECT Id, Name, Parent.Name, Body, Description FROM Attachment WHERE ParentId IN :newMap.keySet()]) {
            if(!mapOfAttachments.containsKey(itemQuoteAtt.Parent.Name)) {
                mapOfAttachments.put(itemQuoteAtt.Parent.Name, new List<Attachment>());
                mapOfAttachments.get(itemQuoteAtt.Parent.Name).add(itemQuoteAtt);
            }
            mapOfAttachments.get(itemQuoteAtt.Parent.Name).add(itemQuoteAtt);
        }
        List<Attachment> listOfAtt = new List<Attachment>();
        for(String itemIdCleanQuote : mapOfAttachments.keySet()) {
            for(Attachment itemAtt : mapOfAttachments.get(itemIdCleanQuote)){
                listOfAtt.add(itemAtt);
                EgnyteAPIHandler.uploadFile(itemAtt.Parent.Name, itemAtt.Body, itemAtt.Name);
            }
        }
        delete listOfAtt;
    }
}