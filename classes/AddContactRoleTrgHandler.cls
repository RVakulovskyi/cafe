public class AddContactRoleTrgHandler {
    public static void onAfterUpdate(List<Opportunity> inputList, Map<Id, Opportunity> oldMap) {
        processAfterUpdate(inputList, oldMap);
    }
    
    public static void onAfterInsert(List<Opportunity> inputList) {
        processAfterInsert(inputList);
    }
    
    private static void processAfterInsert(List<Opportunity> inputList) {
        List<OpportunityContactRole> newContactRoleList = new List<OpportunityContactRole>();
    	List<OpportunityContactRole> oldContactRoleList = new List<OpportunityContactRole>();
    	List<OpportunityContactRole> existingContactRoles;
    	Set<Id> OppId     =  new Set<Id>(); 
    	Set<Id> ContactId =  new Set<Id>();
    	existingContactRoles = new List<OpportunityContactRole>([ SELECT Id,ContactId,OpportunityId FROM OpportunityContactRole WHERE OpportunityId IN :Trigger.New ]);                                                          
    	Map<Id,list<OpportunityContactRole>> groupedContactRoles = Groupby.Ids( 'OpportunityId' , existingContactRoles  );
    	for( Opportunity oppObj: inputList) {
        	if( oppObj.Channel_Partner_Main_Contact__c!=null ) {
        		newContactRoleList.add( new OpportunityContactRole( ContactId = oppObj.Channel_Partner_Main_Contact__c, OpportunityId = oppObj.Id, Role = 'Influencer',IsPrimary = True));              
        	}
        }
        try {
            if( !newContactRoleList.IsEmpty() ) {
        		upsert newContactRoleList;
            }
    	} catch( Exception ex ) {
        	System.debug('ex=='+ex);
        	inputList[0].addError('Technical error occurred. Please contact to your system administrator or try after some time.');       
    	}
    }
    
    public static void processAfterUpdate(List<Opportunity> inputList, Map<Id, Opportunity> inputOldMap) {
        List<OpportunityContactRole> newContactRoleList = new List<OpportunityContactRole>();
    	List<OpportunityContactRole> oldContactRoleList = new List<OpportunityContactRole>();
    	List<OpportunityContactRole> existingContactRoles;
    	Set<Id> OppId     =  new Set<Id>(); 
    	Set<Id> ContactId =  new Set<Id>();
    	existingContactRoles = new List<OpportunityContactRole>([ SELECT Id,ContactId,OpportunityId FROM OpportunityContactRole WHERE OpportunityId IN :inputList]);                                                          
    	Map<Id,list<OpportunityContactRole>> groupedContactRoles = Groupby.Ids( 'OpportunityId' , existingContactRoles  );
        for( Opportunity oppObj: inputList) {
            //Getting the contact and oppty Id from old values and adding this in set 
            Opportunity OldoppObj = inputOldMap.get(oppObj.Id);
            if( oppObj.Channel_Partner_Main_Contact__c!=null ) {
                if( groupedContactRoles.get( oppObj.Id )!=null ) {
                    set<Id> conIds = new set<Id>();
                    for( OpportunityContactRole cntrole : groupedContactRoles.get( oppObj.Id ) ) {
                        conIds.add( cntrole.ContactId );                
                        if( cntrole.ContactId!=oppObj.Channel_Partner_Main_Contact__c ) {
                            cntrole.IsPrimary = false; 
                        } else{
                            cntrole.IsPrimary = true;
                        }
                        oldContactRoleList.add( cntrole );
                    }
                    if( !conIds.contains(oppObj.Channel_Partner_Main_Contact__c)) {
                        newContactRoleList.add( new OpportunityContactRole( 
                                                ContactId = oppObj.Channel_Partner_Main_Contact__c, 
                                                OpportunityId = oppObj.Id, 
                                                Role = 'Influencer',
                                                IsPrimary = True ) );
                    }  
                }  else {
                    newContactRoleList.add( new OpportunityContactRole( 
                                            ContactId = oppObj.Channel_Partner_Main_Contact__c, 
                                            OpportunityId = oppObj.Id, 
                                            Role = 'Influencer',
                                            IsPrimary = True ) );
                }                 
            }
        }
         newContactRoleList.addAll(oldContactRoleList);     
    	try {
        	if( !newContactRoleList.IsEmpty() ) 
        		upsert newContactRoleList;
    	} catch( Exception ex ) {
        	System.debug('ex=='+ex);
        	trigger.new[0].addError('Technical error occurred. Please contact to your system administrator or try after some time.');       
    	}
    }
}