/**
 * Created by wendysadeh on 10/17/16.
 */

public with sharing class RollUpSummaryUtility {
    //the following class will be used to house the field names
    //and desired operations
    public class fieldDefinition {
        public String operation {get;set;}
        public String childField {get;set;}
        public String parentField {get;set;}

        public fieldDefinition (String o, String c, String p) {
            operation = o;
            childField = c;
            parentField = p;
        }
    }

    public Class ObjectDefination{
        public String childObject{get;set;}
        public String childParentLookupField{get;set;}
        public String parentObject{get;set;}
        public String queryFilter{get;set;}
        public list<String> additionalListFilter{get;set;}
        public ObjectDefination(String childObject, String childParentLookupField, String parentObject,String queryFilter, list<String> additionalListFilter){
            this.childObject = childObject;
            this.childParentLookupField = childParentLookupField;
            this.parentObject = parentObject;
            this.queryFilter = queryFilter;
            this.additionalListFilter = additionalListFilter;
        }
    }

    public void rollUp(list<fieldDefinition> fieldDefinitions, ObjectDefination objDef, list<sObject> records) {

        //Limit the size of list by using Sets which do not contain duplicate
        //elements prevents hitting governor limits
        set<Id> parentIds = new set<Id>();

        for(sObject s : records) {
            parentIds.add((Id)s.get(objDef.childParentLookupField));
        }

        //populate query text strings to be used in child aggregrator and
        //parent value assignment
        String fieldsToAggregate = '';
        String parentFields = '';

        for(fieldDefinition d : fieldDefinitions) {
            fieldsToAggregate += d.operation + '(' + d.childField + ') ' +
                    ', ';
            parentFields += d.parentField + ', ';
        }

        String aggregateQuery = 'Select ' + fieldsToAggregate +
                objDef.childParentLookupField + ' from ' + objDef.childObject + ' where  ' +
                objDef.childParentLookupField + ' IN :parentIds ' + objDef.queryFilter + ' ' +
                ' group by ' + objDef.childParentLookupField;
        // additional filters will get added via this condition
        if(objDef.additionalListFilter != null){
            aggregateQuery = aggregateQuery.replace('XYZ','objDef.additionalListFilter');
        }
        //Using dynamic SOQL with aggergate results to populate parentValueMap
        //Map will contain one parent record Id per one aggregate object
        map<Id, AggregateResult> parentValueMap = new map <Id, AggregateResult>();
        System.debug('======RollUpSummaryUtility=rollUp=aggregateQuery====='+aggregateQuery);
        for(AggregateResult q : Database.query(aggregateQuery)){
            parentValueMap.put((Id)q.get(objDef.childParentLookupField), q);
        }
        // no child records found for processing
        if(parentValueMap.size() == 0 && Trigger.isDelete == false)
            return;

        System.debug('=====RollUpSummaryUtility=rollUp=AggregateResult======='+parentValueMap);

        //list of parent object records to update
        list<sObject> parentsToUpdate = new list<sObject>();

        String parentQuery = 'select ' + parentFields + ' Id ' +
                ' from ' + objDef.parentObject + ' where Id IN :parentIds';

        //for each affected parent object, retrieve aggregate results and
        //for each field definition add aggregate value to parent field
        for(sObject s : Database.query(parentQuery)) {

            Integer row = 0; //row counter reset for every parent record
            for(fieldDefinition d : fieldDefinitions) {
                String field = 'expr' + row.format();
                AggregateResult r = parentValueMap.get(s.Id);
                //r will be null if no records exist
                //(e.g. last record deleted)
                if(r != null) {
                    Decimal value = ((Decimal)r.get(field) == null ) ? 0 :
                            (Decimal)r.get(field);
                    s.put(d.parentField, value);
                } else {
                    s.put(d.parentField, 0);
                }
                row += 1; //plus 1 for every field definition after first
            }
            parentsToUpdate.add(s);
        }

        //if parent records exist, perform update of all parent records
        //with a single DML statement
        if(parentsToUpdate.Size() > 0) {
            System.debug('=====RollUpSummaryUtility=rollUp=parentsToUpdate======='+parentsToUpdate);
            try{
                update parentsToUpdate;
            }catch(Exception e){
                System.debug('Exception occured'+e.getMessage());
            }
            System.debug(System.limits.getLimitAggregateQueries()+'  ==  System.limits.getLimitAggregateQueries() = System.limits.getLimitAggregateQueries()   '+System.limits.getLimitAggregateQueries());
        }
    }
}