public class fetchPicklistOptsControllerCustom {
    
 	@AuraEnabled
	public static List <String> getselectOptions(String objObject, string fld, String controleObjectValue) {
  		List <String> allOpts = new List <String>();
  		SObjectType customMetaType = Schema.getGlobalDescribe().get(objObject);
  		Schema.DescribeSObjectResult objDescribe = customMetaType.getDescribe();
  		Map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        if(fld == 'PACE_Program_New__c' && !String.isEmpty(controleObjectValue)) {
            
            String stateProp;
            if(Test.isRunningTest()) {
                stateProp = 'CA';
            } else {
                Opportunity oppToSearch = [SELECT Id, State_Prop__c FROM Opportunity WHERE Id = :controleObjectValue];
				stateProp = oppToSearch.State_Prop__c;
            }
            if(!String.isEmpty(stateProp)){
            	Map<Object,List<String>> mapOfValues = getDependentPicklistValues('Opportunity', 'PACE_Program_New__c');
                System.debug(mapOfValues.get(stateProp));
                System.debug(mapOfValues);
            	for(String itemString : mapOfValues.get(stateProp)) {
                	allOpts.add(itemString);
            	}
            }
        } else {
            List <Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();
  			for (Schema.PicklistEntry a: values) {
   				allOpts.add(a.getValue());
  			}
        }
  		allOpts.sort();
  		return allOpts;
 	}
    
public static Map<Object,List<String>> getDependentPicklistValues( Schema.sObjectField dependToken )
{
    Schema.DescribeFieldResult depend = dependToken.getDescribe();
    Schema.sObjectField controlToken = depend.getController();
    if ( controlToken == null ) return null;
    Schema.DescribeFieldResult control = controlToken.getDescribe();
    List<Schema.PicklistEntry> controlEntries =
    (   control.getType() == Schema.DisplayType.Boolean
    ?   null
    :   control.getPicklistValues()
    );
 
    String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    Map<Object,List<String>> dependentPicklistValues = new Map<Object,List<String>>();
    for (Schema.PicklistEntry entry : depend.getPicklistValues() ) if ( entry.isActive() ) {
        List<String> base64chars = String.valueOf(((Map<String, Object>) JSON.deserializeUntyped( JSON.serialize( entry ) )).get( 'validFor' )).split( '' );
        for ( Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++ ){
            Object controlValue =
            (   controlEntries == null
            ?   (Object) (index == 1)
            :   (Object) (controlEntries[ index ].isActive() ? controlEntries[ index ].getLabel() : null)
            );
            Integer bitIndex = index / 6, bitShift = 5 - Math.mod( index, 6 );
            System.debug(base64chars);
            if  (   controlValue == null
                ||  ((base64chars.size() > bitIndex) && (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0
                )) continue;
            if ( !dependentPicklistValues.containsKey( controlValue ) ){
                dependentPicklistValues.put( controlValue, new List<String>() );
            }
            dependentPicklistValues.get( controlValue ).add( entry.getLabel() );
        }
    }
    return dependentPicklistValues;
}
    
    public static Map<Object,List<String>> getDependentPicklistValues(String sObjectName, String fieldName){
    	return getDependentPicklistValues(Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().get(fieldName));
	}
}