/**
 * Created by wendysadeh on 4/27/17.
 * 12.08.2018 Rodion Vakulovskyi updated class with new structure
 */

public with sharing class OpportunityParcelTriggerHandler {
    
    public static void onAfterUpdate(List<Parcel__c> inputList, Map<Id, Parcel__c> inputNewMap) {
        processAfter(inputList, inputNewMap);
    }
    
     public static void onAfterInsert(List<Parcel__c> inputList, Map<Id, Parcel__c> inputNewMap) {
        processAfter(inputList, inputNewMap);
    }
    
    public static void onAfterDelete(Map<Id, Parcel__c> inputOldMap) {
        processAfterDelete(inputOldMap);
    }
    
    private static void processAfter(List<Parcel__c> inputList, Map<Id, Parcel__c> inputNewMap) {
         // find the ids of all opportunities that were affected
        Set<Id> opportunityIds = new Set<Id>();
        for (Parcel__c apn : [select Id, Opportunity__c from Parcel__c where Id IN :inputNewMap.keySet()]){
            opportunityIds.add(apn.Opportunity__c);
        }
        // process the opportunities
        processParcelAsync(opportunityIds);
    }
    
    private static void processAfterDelete(Map<Id, Parcel__c> inputOldMap) {
         // find the ids of all opportunities that were affected
        Set<Id> opportunityIds = new Set<Id>();
        for (ID idOfOpp : inputOldMap.keySet()) {
            opportunityIds.add(inputOldMap.get(idOfOpp).Opportunity__c);
        }
        // process the opportunities
        processParcelAsync(opportunityIds);

    }

    @future
    public static void processParcelAsync(Set<ID> opportunityIds){

        system.debug('Got Here..........');

        // holds a map of the opportunity id and comma separated regions to build
        Map<Id, String> parcelMap = new Map<Id, String>();

        // get ALL of the apns for all affected opportunities so we can build
        List<Parcel__c> parcels = [SELECT Id, opportunity__c, Name FROM Parcel__c WHERE Opportunity__C IN :opportunityIds ORDER BY Name];

        for (Parcel__c apn : parcels) {
            if (!parcelMap.containsKey(apn.Opportunity__C)) {
                // if the key (opportunity) doesn't exist, add it with the apn
                system.debug('Oppurtunity Id1 new apn: ' + apn.Name);
                parcelMap.put(apn.Opportunity__C,apn.Name);
            } else {
                // if the key (opportunity) already exist, add ", apn"
                system.debug('Oppurtunity Id2 old apn: ' + apn.Name);
                parcelMap.put(apn.Opportunity__C,parcelMap.get(apn.Opportunity__C) + ', ' + apn.Name);
            }
        }
        // get the opportunities that were affected
        List<Opportunity> opportunities = [select id from Opportunity where Id IN :opportunityIds];
        // add the comma separated list of regions
        for (Opportunity oppItem : opportunities)
            oppItem.Property_Parcel_Number__c = parcelMap.get(oppItem.id);
        system.debug('In Loop..........');
        if(opportunities.size() > 0) {
        	update opportunities;
        }

    }

}