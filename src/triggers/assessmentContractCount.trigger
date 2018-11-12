/**
 * Created by wendysadeh on 10/17/16.
 */

trigger assessmentContractCount on Opportunity (after insert, after update, after delete, after undelete) {
    List<Opportunity>  opportunities =  new  List<Opportunity>();
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUndelete){
            opportunities = Trigger.new;
        }else if(Trigger.isUpdate){
            for(Opportunity opp : Trigger.new){
                if((opp.Parcel_Count__c != Trigger.oldMap.get(opp.id).Parcel_Count__c) ||
                (opp.Bond__c != Trigger.oldMap.get(opp.id).Bond__c)){
                    opportunities.add(opp);
                }
            }
        } else if(Trigger.isDelete){
            opportunities  = trigger.old;
        }
    }
    list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions1 =

            new list<RollUpSummaryUtility.fieldDefinition> {

                    new RollUpSummaryUtility.fieldDefinition('SUM', 'Parcel_Count__c',

                            'AC_Count__c')

            };

    RollUpSummaryUtility.ObjectDefination objDef =
            new RollUpSummaryUtility.ObjectDefination('Opportunity','Bond__c','Bond__c','',null);

    new RollUpSummaryUtility().rollUp(fieldDefinitions1, objDef , opportunities);

}