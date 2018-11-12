/**
 * Created by wendysadeh on 10/20/16.
 */

trigger bondCostRollUp on Opportunity (after insert, after update, after delete, after undelete) {
    List<Opportunity>  opportunities =  new  List<Opportunity>();
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUndelete){
            opportunities = Trigger.new;
        }else if(Trigger.isUpdate){
            for(Opportunity opp : Trigger.new){
                if((opp.Bond_Cost__c != Trigger.oldMap.get(opp.id).Bond_Cost__c)||
                        (opp.Bond__c != Trigger.oldMap.get(opp.id).Bond__c)) {
                    opportunities.add(opp);
                }
            }
        } else if(Trigger.isDelete){
            opportunities  = trigger.old;
        }
    }
    list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions1 =

            new list<RollUpSummaryUtility.fieldDefinition> {

                    new RollUpSummaryUtility.fieldDefinition('SUM', 'Bond_Cost__c',

                            'Bond_Cost__c')

            };

    RollUpSummaryUtility.ObjectDefination objDef =
            new RollUpSummaryUtility.ObjectDefination('Opportunity','Bond__c','Bond__c','',null);

    new RollUpSummaryUtility().rollUp(fieldDefinitions1, objDef , opportunities);


}