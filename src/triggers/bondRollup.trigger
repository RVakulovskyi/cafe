/**
 * Created by wendysadeh on 10/17/16.
 */

trigger bondRollup on Opportunity (after insert, after update, after delete, after undelete) {
    List<Opportunity>  opportunities =  new  List<Opportunity>();
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUndelete){
            opportunities = Trigger.new;
        }else if(Trigger.isUpdate){
            for(Opportunity opp : Trigger.new){
                if((opp.Bond_Total__c != Trigger.oldMap.get(opp.id).Bond_Total__c)||
                    (opp.Bond__c != Trigger.oldMap.get(opp.id).Bond__c)||
                    (opp.Bond_Cost__c != Trigger.oldMap.get(opp.id).Bond_Cost__c)||
                    (opp.Parcel_Count__c != Trigger.oldMap.get(opp.id).Parcel_Count__c)) {
                    opportunities.add(opp);
                }
            }
        } else if(Trigger.isDelete){
            opportunities  = trigger.old;
        }
    }
    list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions1 =

            new list<RollUpSummaryUtility.fieldDefinition> {

                    new RollUpSummaryUtility.fieldDefinition('SUM', 'Bond_Total__c',

                            'Bond_Amount__c')

            };

    list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions2 =

            new list<RollUpSummaryUtility.fieldDefinition> {

                    new RollUpSummaryUtility.fieldDefinition('SUM', 'Contribution_to_Bond_Rate__c',

                            'Blended_Coupon__c')

            };


    list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions3 =

        new list<RollUpSummaryUtility.fieldDefinition> {

                new RollUpSummaryUtility.fieldDefinition('SUM', 'Bond_Cost__c',

                    'Bond_Cost__c')

                };

    list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions4 =

        new list<RollUpSummaryUtility.fieldDefinition> {

            new RollUpSummaryUtility.fieldDefinition('SUM', 'Parcel_Count__c',

                'AC_Count__c')

        };




RollUpSummaryUtility.ObjectDefination objDef =
            new RollUpSummaryUtility.ObjectDefination('Opportunity','Bond__c','Bond__c','',null);

    new RollUpSummaryUtility().rollUp(fieldDefinitions1, objDef , opportunities);
    new RollUpSummaryUtility().rollUp(fieldDefinitions2, objDef , opportunities);
    new RollUpSummaryUtility().rollUp(fieldDefinitions3, objDef , opportunities);
    new RollUpSummaryUtility().rollUp(fieldDefinitions4, objDef , opportunities);

}