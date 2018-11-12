public class CleanQuoteParserHandler {
    
    public static void onBeforeInsert(List<CleanQuote__c> inputNewList) {
        Map<CleanQuote__c, Lead> mapOfLeads = new Map<CleanQuote__c, Lead>();
        Map<Id, Id> mapOfLeadsCleanQuote = new Map<Id, Id>();
        Field_Mapping_Setting__mdt fieldList = (Field_Mapping_Setting__mdt)ApexHelperUtility.queryCustomMetaType('Field_Mapping_Setting__mdt', 'CleanQuoteOWner');
        User defaultOwner = [Select Id FROM User WHERE email = :fieldList.FieldMapList__c];
        for(CleanQuote__c itemCleanQuote : inputNewList) {
            if(!itemCleanQuote.Is_StandAlone__c && itemCleanQuote.CQ_Lead__c == null){
                if(String.isEmpty(itemCleanQuote.Project_Name__c)) {
            	    itemCleanQuote.Project_Name__c = 'Default';  
                }

                mapOfLeads.put(itemCleanQuote, createObjects(itemCleanQuote, defaultOwner));   
            }
            if(String.isEmpty(itemCleanQuote.Next_Step__c)) {
                itemCleanQuote.Next_Step__c = 'Default';
                itemCleanQuote.Next_Step_Tickler__c = Date.today().addDays(2); 
             }


        }
        System.debug(mapOfLeads);
        for(Lead itemLead : mapOfLeads.values()) {
            if(String.isEmpty(itemLead.Next_Step__c) || itemLead.Next_Step__c == null) {
                itemLead.Next_Step__c = 'Default';
                itemLead.Next_Step_Tickler__c = Date.today().addDays(2); 
            }
        }
        if(mapOfLeads.values().size() > 0){
        	upsert mapOfLeads.values();
            for(CleanQuote__c itemCleanQuote : mapOfLeads.keySet()) {
                mapOfLeadsCleanQuote.put(mapOfLeads.get(itemCleanQuote).Id, itemCleanQuote.Id);
            }
          //  emailMessagerService(mapOfLeads.values(), mapOfLeadsCleanQuote);
        	for(CleanQuote__c cleanQItem : mapOfLeads.keySet()) {
            	cleanQItem.CQ_Lead__c = mapOfLeads.get(cleanQItem).Id;
        	}
            List<Attachment> listOfAtatchments = new List<Attachment>();
            listOfAtatchments.addAll(moveAttachmentsToLead(mapOfLeads));
            if(listOfAtatchments.size() > 0) {
                upsert listOfAtatchments;
            }
        }
    }

  
    public static void onBeforeUpdate(List<CleanQuote__c> inputNewList, Map<Id, CleanQuote__c> newMap) {
        Map<CleanQuote__c, Lead> mapOfLeads = new Map<CleanQuote__c, Lead>();
        Field_Mapping_Setting__mdt fieldList = (Field_Mapping_Setting__mdt)ApexHelperUtility.queryCustomMetaType('Field_Mapping_Setting__mdt', 'CleanQuoteOWner');
        User defaultOwner = [Select Id FROM User WHERE email = :fieldList.FieldMapList__c];
        for(CleanQuote__c itemCleanQuote : inputNewList) {
        	mapOfLeads.put(itemCleanQuote, createObjects(itemCleanQuote, defaultOwner));
            if(String.isEmpty(itemCleanQuote.Next_Step__c)) {
                    itemCleanQuote.Next_Step__c = 'Default';
                    itemCleanQuote.Next_Step_Tickler__c = Date.today().addDays(2); 

            }
        }
        
        for(CleanQuote__c cleanQItem : mapOfLeads.keySet()) {
            cleanQItem.CQ_Lead__c = mapOfLeads.get(cleanQItem).Id;
        }
     //   CleanQuoteEgnyteHandler.uploadAttachmentToEgnyte(inputNewList, newMap);
        update mapOfLeads.values();
    }
    
    private static Lead createObjects(CleanQuote__c cleanQuoteToQuery, User inputUser) {
        Lead leadForInsert;
        Map<String, Object> mapOfLeadFields = new Map<String, Object>();
        Set<String> setOfLeadFields = getLeadApiFields();
        List<String> listOfCleanQuoteFields = getCleanQuoteApiFields();
        for(String itemString : listOfCleanQuoteFields) {
            if(setOfLeadFields.contains(itemString)) {
                mapOfLeadFields.put(itemString, cleanQuoteToQuery.get(itemString));
            }
        }
        if(mapOfLeadFields.values().size() >0) {
            leadForInsert = formAndInsertLead(mapOfLeadFields, cleanQuoteToQuery, inputUser);
        }
        return leadForInsert;
    }
    
    private static Set<String> getLeadApiFields() {
        Set<String> setToReturn = new Set<String>();
        SObjectType customObect = Schema.getGlobalDescribe().get('Lead');
		Map<String,Schema.SObjectField> mfields = customObect.getDescribe().fields.getMap();
		for(String itemString : mfields.keySet()) {
			setToReturn.add(itemString);
		}
        return setToReturn;
    }
    
    private static List<String> getCleanQuoteApiFields() {
        List<String> listToReturn = new List<String>();
        SObjectType customObect = Schema.getGlobalDescribe().get('CleanQuote__c');
		Map<String,Schema.SObjectField> mfields = customObect.getDescribe().fields.getMap();
		for(String itemString : mfields.keySet()) {
			listToReturn.add(itemString);
		}
        return listToReturn;
    }
    
    private static Lead formAndInsertLead(Map<String, Object> mapOfInputs, CleanQuote__c cleanQuoteToQuery, User inputUser) {
        Lead leadToInsert = (Lead)formObjectRecord(mapOfInputs,'Lead');
        	if(!String.isEmpty(cleanQuoteToQuery.CQ_Lead__c)){
        		leadToInsert.put('Id',cleanQuoteToQuery.CQ_Lead__c);
        	}
        	leadToInsert.put('AccountTypeNew__c','Owner');
        	leadToInsert.put('Application_Submission_Date__c',cleanQuoteToQuery.Application_Submission_Date__c);
        	leadToInsert.put('Contractor_or_EPC__c', createCheckContractor(cleanQuoteToQuery));
        	leadToInsert.put('Project_Finish_Date__c', cleanQuoteToQuery.Desired_Project_Finish_Date__c);
        	if(!String.isEmpty(cleanQuoteToQuery.FirstName__c)){
        		leadToInsert.put('FirstName',cleanQuoteToQuery.FirstName__c);
            }
        	if(String.isEmpty(cleanQuoteToQuery.CQ_Lead__c) && String.isEmpty(cleanQuoteToQuery.FirstName__c)) {
            	leadToInsert.put('FirstName','Default');
        	}
        	if(String.isEmpty(cleanQuoteToQuery.CQ_Lead__c) && String.isEmpty(cleanQuoteToQuery.LastName__c)) {
            	leadToInsert.put('LastName','Default');
        	}
        	if(!String.isEmpty(cleanQuoteToQuery.LastName__c) && String.isEmpty(cleanQuoteToQuery.CQ_Lead__c)){
        		leadToInsert.put('LastName',cleanQuoteToQuery.LastName__c);
        	}
        	leadToInsert.put('Is_there_a_groundlease_in_place_c__c',cleanQuoteToQuery.Ground_Lease__c); 
        	leadToInsert.put('Indicative_Interest_Rate_at_Quote__c',cleanQuoteToQuery.Indicative_Interest_Rate__c);
        	leadToInsert.put('Stage__c',cleanQuoteToQuery.Lead_Stage__c );
        	leadToInsert.put('Project_Scope__c',cleanQuoteToQuery.Opp_Project_Scope__c);
        	leadToInsert.put('Channel_Partner_Main_Contact__c', createCheckContact(cleanQuoteToQuery));
        	leadToInsert.put('Improvement_Cost_Est__c', cleanQuoteToQuery.Project_Size_In_Dollars__c);  //question
       	    if(!String.isEmpty(cleanQuoteToQuery.Company__c)){
        		leadToInsert.put('Company',cleanQuoteToQuery.Company__c);
            }
       	    if(cleanQuoteToQuery.CF_Lead_Source__c == 'Web Quote Owner Rep'){
        		leadToInsert.put('Company','Uncategorized');
        	}
        	Contact contactOwner = createCheckContactOwner(cleanQuoteToQuery);
        	System.debug(contactOwner);
        	if(contactOwner!=null && !String.isEmpty(contactOwner.Name) &&contactOwner.Name == 'Unknown Owner' ) {
            	leadToInsert.put('OwnerId', inputUser.Id);
            	leadToInsert.put('Property_Owner_Main_Contact__c', contactOwner.Id);
        	}
            if(!String.isEmpty(cleanQuoteToQuery.Partner_Company__c)) {
                leadToInsert.put('Channel_Partner_Name__c', queryAccount(cleanQuoteToQuery.Partner_Company__c).Id);
            }
            if(cleanQuoteToQuery.PPA__c == 'Yes') {
                leadToInsert.put('Owner_has_tax_appetite__c','No');
                leadToInsert.put('Solar_System_Ownership__c','Third Party');
            }
            if(cleanQuoteToQuery.PPA__c == 'No') {
                leadToInsert.put('Owner_has_tax_appetite__c','Yes');
                leadToInsert.put('Solar_System_Ownership__c','Owner');
            }
            if(!String.isEmpty(String.valueOf(cleanQuoteToQuery.System_Size_kW_DC__c))) {
                leadToInsert.put('Solar_Component__c','Yes');
            } else{
                leadToInsert.put('Solar_Component__c','No');
            }
            leadToInsert.put('Solar_PV_System_Size_kW__c', cleanQuoteToQuery.System_Size_kW_DC__c);
            leadToInsert.put('Total_Financing_Fee__c',cleanQuoteToQuery.Total_Financing_Fee__c);
            leadToInsert.put('Stage__c','Pre-Qualified Lead');
            leadToInsert.put('CleanQuote__c',cleanQuoteToQuery.Id);
            leadToInsert.put('Next_Step__c',cleanQuoteToQuery.Next_Step__c);
            leadToInsert.put('Next_Step_Tickler__c',cleanQuoteToQuery.Next_Step_Tickler__c);
            if(cleanQuoteToQuery.Mortgage_Lender_1st__c != null){
                leadToInsert.put('First_Mortgage__c', 'Yes');
            } else {
                leadToInsert.put('First_Mortgage__c', 'No');
            }
            if(cleanQuoteToQuery.Mortgage_Lender_2nd__c != null){
                leadToInsert.put('Second_Mortgage__c', 'Yes');
            } else {
                leadToInsert.put('Second_Mortgage__c', 'No');
            }
        System.debug(leadToInsert);
        return leadToInsert;
    }
    
    private static sObject formObjectRecord(Map<String, Object> mapOfMappedFields, String objectName) {
        sObject objToReturn = Schema.getGlobalDescribe().get(objectName).newSObject() ;
        Map<String, Schema.SObjectField> mapOfLeadFields = Schema.SObjectType.Lead.fields.getMap();
        for(String itemFieldName : mapOfMappedFields.keySet()) {
            System.debug(itemFieldName + ' CleanFund ' + mapOfLeadFields.get(itemFieldName));
            System.debug(mapOfLeadFields.containsKey(itemFieldName) + ' Lead');
            if(mapOfMappedFields.containsKey(itemFieldName) && mapOfLeadFields.get(itemFieldName).getDescribe().isUpdateable()){
              //  System.debug(mapOfMappedFields.get(itemFieldName) + 'Value FieldName');
            	Object objToAssign = mapOfMappedFields.get(itemFieldName);
                System.debug(itemFieldName + ' CleanFund ' + mapOfLeadFields.get(itemFieldName) + ' Value ' + objToAssign);
            	if(objToAssign instanceof Integer) {
                	objToReturn.put(mapOfLeadFields.get(itemFieldName), Integer.valueOf(objToAssign));
            	}
            	if(objToAssign instanceof String) {
                	objToReturn.put(mapOfLeadFields.get(itemFieldName), String.valueOf(objToAssign));
            	}
                if(objToAssign instanceof DateTime && !(objToAssign instanceof Date)) {
                    objToReturn.put(mapOfLeadFields.get(itemFieldName), (DateTime)objToAssign);
                }
            	if(objToAssign instanceof Date || (objToAssign instanceof DateTime)) {
                	objToReturn.put(itemFieldName, (Date)objToAssign);
                } 
            	if(objToAssign instanceof Boolean) {
                	objToReturn.put(mapOfLeadFields.get(itemFieldName), Boolean.valueOf(objToAssign));
            	}
                if(objToAssign instanceof Decimal) {
                	objToReturn.put(mapOfLeadFields.get(itemFieldName), Decimal.valueOf(String.valueOf(objToAssign)));
            	}
                if(objToAssign instanceof Double) {
                    objToReturn.put(mapOfLeadFields.get(itemFieldName), Double.valueOf(objToAssign));
                }
                if(itemFieldName == 'Project_Start_Date__c') {
                    System.debug(objToAssign instanceof Date);
                    System.debug(objToReturn);
                }
            }
        }
        return objToReturn;
    }
    
    private static Id createCheckContractor(CleanQuote__c cleanQuoteToQuery) {
    	Id idToReturn = null;
        if(!String.isEmpty(cleanQuoteToQuery.Contractor_Company_Name__c)){
        	RecordType contractorRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Contractor'];
        	List<Account> listOfContractorsAccounts = new List<Account>([SELECT Id FROM Account WHERE RecordTypeId = :contractorRecordType.Id AND Name = :cleanQuoteToQuery.Contractor_Company_Name__c ]);
        	if(listOfContractorsAccounts.size() > 0){
            	idToReturn = listOfContractorsAccounts[0].Id;
        	} else {
            	Account newAcc = new Account(Name = cleanQuoteToQuery.Contractor_Company_Name__c);
            	insert newAcc;
            	idToReturn = newAcc.Id; 
        	}
        }
    	return idToReturn;
    }
    
    private static Id createCheckContact(CleanQuote__c cleanQuoteToQuery) {
    	Id idToReturn = null;
        if(!String.isEmpty(cleanQuoteToQuery.Partner_Email__c)){
        	List<Contact> listOfContacts = new List<Contact>([SELECT Id FROM Contact WHERE Email = :cleanQuoteToQuery.Partner_Email__c ]);
        	if(listOfContacts.size() > 0){
            	idToReturn = listOfContacts[0].Id;
        	} else {
            	Contact newContact = new Contact(FirstName = cleanQuoteToQuery.Partner_First_Name__c , 
                                                 LastName = cleanQuoteToQuery.Partner_Last_Name__c, 
                                                 Email = cleanQuoteToQuery.Partner_Email__c,
                                                 Phone = cleanQuoteToQuery.Partner_Phone__c );
            	insert newContact;
            	idToReturn = newContact.Id; 
        	}
        }
    	return idToReturn;
    }
    
    private static Contact createCheckContactOwner(CleanQuote__c cleanQuoteToQuery) {
    	Contact idToReturn = null;
        if(!String.isEmpty(cleanQuoteToQuery.Property_Owner_Email__c)){
        	List<Contact> listOfContacts = new List<Contact>([SELECT Id, Name FROM Contact WHERE Email = :cleanQuoteToQuery.Property_Owner_Email__c]);
        	if(listOfContacts.size() > 0){
            	idToReturn = listOfContacts[0];
        	} else {
            	List<Contact> listOfContactsDef = new List<Contact>([SELECT Id, Name FROM Contact WHERE Name = 'Unknown Owner']);
                if(listOfContactsDef.size() > 0){
            		idToReturn = listOfContactsDef[0]; 
                }
        	}
        }
    	return idToReturn;
    }

    private static Account queryAccount(String accountName) {
        List<Account> listAccToReturn = new List<Account>([SELECT Id FROM Account WHERE Name =:accountName]);
        Account accToReturn;
        if(listAccToReturn.size() > 0) {
            accToReturn = listAccToReturn[0];
        } else {
            accToReturn = new Account(Name = accountName);
            insert accToReturn;
        }
        return accToReturn;
    }

    private static List<Attachment> moveAttachmentsToLead(Map<CleanQuote__c, Lead> inputMap) {
        Map<Id, Lead> mapOfCleanQuoteLead = new Map<Id, Lead>();
        Set<String> setOfLeadAttachment = new Set<String>();
        for(CleanQuote__c itemQuote : inputMap.keySet()) {
            mapOfCleanQuoteLead.put(itemQuote.Id, inputMap.get(itemQuote));
        }
        for(Attachment itemAtt : [SELECT Id, Name FROM Attachment WHERE ParentId = :inputMap.values()]) {
            setOfLeadAttachment.add(itemAtt.Name);
        }
        List<Attachment> listOfAttachment = new List<Attachment>();
        for(Attachment itemAtt : [SELECT Id, BodyLength, Body, ParentId, ContentType, Description, IsPrivate, IsPartnerShared, Name FROM Attachment WHERE ParentId = :mapOfCleanQuoteLead.keySet()]) {
            if(!setOfLeadAttachment.contains(itemAtt.Name)){
                Attachment attInsert = itemAtt.clone(false,false,false,false);
                attInsert.ParentId = mapOfCleanQuoteLead.get(itemAtt.ParentId).Id;
                listOfAttachment.add(attInsert);
            }
        }
        return listOfAttachment;
    }

 /*   private static void messagingHandler(List<Lead> inputList, String contentData, Map<Id, Id> mapOfLeadsCleanQuote) {
         List<Messaging.SingleEmailMessage> listOfEmails = new List<Messaging.SingleEmailMessage>();
         Set<Id> setOfChannelPartner = new Set<Id>();
         for(Lead itemLead : [SELECT Id, Channel_Partner_Main_Contact__r.Name, Channel_Partner_Main_Contact__r.Owner.Name, Channel_Partner_Main_Contact__r.Account.Name, Total_PACE_financing_amount_Est__c, Property_City__c, Property_State__c, Close_Date__c FROM Lead WHERE Id IN :inputList]) {
                setOfChannelPartner.add(itemLead.Channel_Partner_Main_Contact__c);
         }
         Map<Id,Contact> mapOFContactAndOwners = new Map<Id,Contact>();
         for(Contact itemContact : [SELECT Name, Owner.Email, Id FROM Contact WHERE Id IN :setOfChannelPartner]) {
                mapOFContactAndOwners.put(itemContact.Id, itemContact);
         }
         for(Lead itemLead : inputList){
            if(mapOFContactAndOwners.get(itemLead.Channel_Partner_Main_Contact__c) != null && mapOFContactAndOwners.get(itemLead.Channel_Partner_Main_Contact__c).OwnerId != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();     
                mail.setSubject('Quote '+itemLead.Name);
                mail.setToAddresses(new List<String>{mapOFContactAndOwners.get(itemLead.Channel_Partner_Main_Contact__c).Owner.Email});   
                mail.setBccSender(false);
                String body='Hi '+itemLead.Channel_Partner_Main_Contact__r.Owner.Name+',\n\n A contact of yours '+itemLead.Channel_Partner_Main_Contact__r.Name+' from '+itemLead.Channel_Partner_Main_Contact__r.Account.Name+' '+contentData+' '+itemLead.Total_PACE_financing_amount_Est__c+' in '+itemLead.Property_City__c+', '+itemLead.Property_State__c+'. The project is targeted to close '+itemLead.Close_Date__c+'.\n\n '+System.URL.getSalesforceBaseUrl()+'/'+mapOfLeadsCleanQuote.get(itemLead.Id)+'\n\n '+'Thanks'+'\n\n '+'CleanQuote';
                mail.setPlainTExtBody(body);
                mail.setToAddresses(new List<String>{mapOFContactAndOwners.get(itemLead.Channel_Partner_Main_Contact__c).Owner.Email}); 
                mail.setSaveAsActivity(false);
                listOfEmails.add(mail);
             }

         }
         Messaging.sendEmail(listOfEmails);
    }

    private static void emailMessagerService(List<Lead> inputList, Map<Id, Id> mapOfLeadsCleanQuote) {
        List<Lead> firstRun  = new List<Lead>();
        List<Lead> secondRun  = new List<Lead>();
        List<Lead> thirdRun  = new List<Lead>();
        Set<Id> setOFContactIds = new Set<Id>();
        for(Lead itemLead : inputList) {
            if(itemLead.Channel_Partner_Main_Contact__c != null){
                    setOFContactIds.add(itemLead.Channel_Partner_Main_Contact__c);
                }
            }
        Set<Id> setOfIds = new Set<Id>();
        Map<Id, List<Lead>> mapOfQuoteNumber = new Map<Id, List<Lead>>();
        for(Lead itemLead: [SELECT Id, CreatedDate, Channel_Partner_Main_Contact__c FROM Lead WHERE Channel_Partner_Main_Contact__c IN :setOFContactIds]) {
            if(!mapOfQuoteNumber.containsKey(itemLead.Channel_Partner_Main_Contact__c)) {
                mapOfQuoteNumber.put(itemLead.Channel_Partner_Main_Contact__c, new List<Lead>());
                if(Date.today().daysBetween(Date.valueOf(itemLead.CreatedDate)) >= 30){
                    mapOfQuoteNumber.get(itemLead.Channel_Partner_Main_Contact__c).add(itemLead);
                }
            }
           if(Date.today().daysBetween(Date.valueOf(itemLead.CreatedDate)) >= 30){
                    mapOfQuoteNumber.get(itemLead.Channel_Partner_Main_Contact__c).add(itemLead);
            }
            setOfIds.add(itemLead.Channel_Partner_Main_Contact__c);
        }
        for(Lead itemLead : inputList) {
            if(!setOfIds.contains(itemLead.Channel_Partner_Main_Contact__c)) {
                firstRun.add(itemLead);
            }
            if(itemLead.Total_PACE_financing_amount_Est__c >= 5000000 && itemLead.Channel_Partner_Main_Contact__c != null) {
                secondRun.add(itemLead);
            }
            if(mapOfQuoteNumber.containsKey(itemLead.Channel_Partner_Main_Contact__c) && mapOfQuoteNumber.get(itemLead.Channel_Partner_Main_Contact__c).size() >= 6) {
                thirdRun.add(itemLead);
            }
        }
        if(firstRun.size() > 0) {
            String contentData = 'has run first quote';
            messagingHandler(firstRun, contentData, mapOfLeadsCleanQuote);
        }
        if(secondRun.size() > 0) {
            String contentData = 'ran a large quote';
            messagingHandler(secondRun, contentData, mapOfLeadsCleanQuote);
        }
        if(thirdRun.size() > 0) {
            String contentData = 'has run over 6 quotes in the last 30 days, the last quote was';
            messagingHandler(thirdRun, contentData, mapOfLeadsCleanQuote);
        }
    }*/
}