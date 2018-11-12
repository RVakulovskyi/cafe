public class OpportunityLienTriggerHandler {

    @future
    public static void ProcessLienAsync(Set<ID> opportunityIds){

        // holds a map of the opportunity id and comma separated regions to build
        Map<Id, String> lienLenderMap = new Map<Id, String>();
        Map<Id, String> lienLenderAckMap = new Map<Id, String>();

        // get ALL of the liens for all affected opportunities so we can build
        List<Lien__c> liens = [select id, opportunity__c, Mortgage_Lender__r.Name, Lender_Acknowledgement__c from Lien__c
        	where Opportunity__C IN :opportunityIds order by Debt_Position__c];
        List<AggregateResult> liensCountbyOpp = [Select Opportunity__c, Count(Id), Count(Lender_Acknowledgement__c) From Lien__c 
        	where Opportunity__C IN :opportunityIds Group By Opportunity__c];

        for (Lien__c lien : liens) {
            if (!lienLenderMap.containsKey(lien.Opportunity__C)) {
                // if the key (opportunity) doesn't exist, add it with the lien
                system.debug('Oppurtunity Id1 new lien: ' + lien.Mortgage_Lender__r.Name);
                lienLenderMap.put(lien.Opportunity__C,lien.Mortgage_Lender__r.Name);
            } else {
                // if the key (opportunity) already exist, add ", lien"
                system.debug('Oppurtunity Id2 old lien: ' + lien.Mortgage_Lender__r.Name);
                if (lien.Mortgage_Lender__r.Name != null)
                	lienLenderMap.put(lien.Opportunity__C,lienLenderMap.get(lien.Opportunity__C) +
                        ';' + lien.Mortgage_Lender__r.Name);
            }
        }
 
        for (AggregateResult lienrollup : liensCountbyOpp) {
            Integer numOfLiens = (Integer) lienrollup.get('expr0');
            Integer numOfAcknowledgements = (Integer) lienrollup.get('expr1');
            String oppId = (String) lienrollup.get('Opportunity__c');
            
            if (numOfAcknowledgements == numOfLiens)
                lienLenderAckMap.put(oppId, 'Received');
            else if (numOfAcknowledgements == 0)
                lienLenderAckMap.put(oppId, 'None Received');
            else if (numOfAcknowledgements < numOfLiens)
                lienLenderAckMap.put(oppId, 'Some Received');
            else 
                lienLenderAckMap.put(oppId, 'N/A');
        }


        // get the opportunities that were affected
        List<Opportunity> opportunities = [select id, Lender_Ack_Start_Date__c  from Opportunity where Id IN :opportunityIds];

        // add the comma separated list of regions
        for (Opportunity o : opportunities) {
            o.Mortgage_Lenders__c  = lienLenderMap.get(o.id);
            o.Lender_Ack_Status__c  = lienLenderAckMap.get(o.id);
        }
        update opportunities;

    }

}