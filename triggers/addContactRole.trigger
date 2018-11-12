trigger addContactRole on Opportunity (after Insert, after update) 
{    
    List<OpportunityContactRole> newContactRoleList = new List<OpportunityContactRole>();
    List<OpportunityContactRole> oldContactRoleList = new List<OpportunityContactRole>();
    List<OpportunityContactRole> existingContactRoles;
    Set<Id> OppId     =  new Set<Id>(); 
    Set<Id> ContactId =  new Set<Id>();
    
    existingContactRoles = new List<OpportunityContactRole>([ SELECT Id,ContactId,OpportunityId FROM OpportunityContactRole
                                                              WHERE OpportunityId in:Trigger.New ]);
                                                                
    Map<Id,list<OpportunityContactRole>> groupedContactRoles = Groupby.Ids( 'OpportunityId' , existingContactRoles  );
        
    for( Opportunity oppObj: Trigger.new )
    {
        //Insert condition    
        if( Trigger.isInsert )
        {
            if( oppObj.Channel_Partner_Main_Contact__c!=null )
            {
                //Creating new contact role
                newContactRoleList.add( new OpportunityContactRole( ContactId = oppObj.Channel_Partner_Main_Contact__c,
                                                                    OpportunityId = oppObj.Id, 
                                                                    Role = 'Influencer',IsPrimary = True ) );
                                                                                         
            }
        }
        else
        {     
            //Getting the contact and oppty Id from old values and adding this in set 
            Opportunity OldoppObj = Trigger.oldMap.get(oppObj.Id);
            
            if( oppObj.Channel_Partner_Main_Contact__c!=null )
            {
                if( groupedContactRoles.get( oppObj.Id )!=null )
                {
                
                    set<Id> conIds = new set<Id>();
                    
                    for( OpportunityContactRole cntrole : groupedContactRoles.get( oppObj.Id ) )
                    {
                        conIds.add( cntrole.ContactId );
                                         
                        if( cntrole.ContactId!=oppObj.Channel_Partner_Main_Contact__c ) 
                            cntrole.IsPrimary = false;       
                        else
                            cntrole.IsPrimary = true;
                            
                        oldContactRoleList.add( cntrole );
                    }
                    
                    if( !conIds.contains(oppObj.Channel_Partner_Main_Contact__c) )    {
                        newContactRoleList.add( new OpportunityContactRole( 
                                                ContactId = oppObj.Channel_Partner_Main_Contact__c, 
                                                OpportunityId = oppObj.Id, 
                                                Role = 'Influencer',
                                                IsPrimary = True ) );
                    }
                    
                }  
                else
                {
                    newContactRoleList.add( new OpportunityContactRole( 
                                            ContactId = oppObj.Channel_Partner_Main_Contact__c, 
                                            OpportunityId = oppObj.Id, 
                                            Role = 'Influencer',
                                            IsPrimary = True ) );
                }                 
            }
        }                    
    }   
    
    newContactRoleList.addAll(oldContactRoleList);     
    
    try
    {
        if( !newContactRoleList.IsEmpty() ) 
        upsert newContactRoleList;
    }
    catch( Exception ex )
    {
        System.debug('ex=='+ex);
        trigger.new[0].addError('Technical error occurred. Please contact to your system administrator or try after some time.');       
    }
}