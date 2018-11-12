/**
 * 12.08.2018 Rodion Vakulovskyi custom lead convert class
 * 19.08.2018 Rodion Vakulovskyi updating class
 * 20.08.2018 Rodion Vakulovskyi updating class
 * 21.08.2018 Rodion Vakulovskyi updating class
 */
public class LeadConvertClass {

    public String convertLead(Lead inputLead) {
            List<IntegrationHistory__c> hisotryListToInsert = new List<IntegrationHistory__c>();
            String accId = '';
            Contact contactCreated = searchContactDupesSimple(inputLead.Property_Owner_Email__c, inputLead.Property_Owner_First__c, inputLead.Property_Owner_Last__c);
            Account accountCreated = checkAccDupes(inputLead.Legal_Name_of_Property_Owner__c, false);
            if(contactCreated != null && contactCreated.AccountId != null) {
                accountCreated = checkAccDupes(contactCreated.Account.Name, false);
            }
            if(accountCreated == null){
                accountCreated = createAccount(inputLead);
            }
            accId = accountCreated.Id;
            if(contactCreated == null) {
                contactCreated = createContact(inputLead, accountCreated);
            }
            Opportunity oppCreated = createOpportunity(inputLead, accountCreated, contactCreated.Id);
        System.debug(oppCreated);
            OpportunityRelatedRecordsUpdater.FlagForUpdate = false;
            List<Parcel__c> parselListCreated = createParcel(inputLead, oppCreated);
            List<Lien__c> lienlistCreated = createLien(accountCreated, inputLead, oppCreated);
            List<Tenant__c> tenantListCreated = createTenant(inputLead, oppCreated);
            attachmentReaasign(inputLead.Id, oppCreated.Id);
          //  String accStr =  IntegrationHistoryHandler.formObjectStr('Account', inputLead, accountCreated);
         //   hisotryListToInsert.add(IntegrationHistoryHandler.formAndUpdateRecord(inputLead.Id, accStr));
           // String oppStr =  IntegrationHistoryHandler.formObjectStr('Opportunity', inputLead, oppCreated);
          //  hisotryListToInsert.add(IntegrationHistoryHandler.formAndUpdateRecord(inputLead.Id, oppStr));
           // String contactStr =  IntegrationHistoryHandler.formObjectStr('Contact', inputLead, contactCreated);
          //  hisotryListToInsert.add(IntegrationHistoryHandler.formAndUpdateRecord(inputLead.Id, contactStr));
         //   if(hisotryListToInsert.size() > 0) {
          //      upsert hisotryListToInsert;
         //   }
         //   updateProspectRecord(inputLead.Id, oppCreated.Id);
            delete inputLead;   
            return accId;
    }

    public String convertLeadAccount(Lead inputLead){
        String accId = '';
        List<Contact> contactCreated = new List<Contact>([SELECT Id FROM Contact WHERE Email = :inputLead.Email AND AccountId = :inputLead.Account_Name__c]);
        if(contactCreated.isEmpty()) {
            Contact contactToCreate = new Contact(
                                    Email = inputLead.Email,
                                    AccountId = inputLead.Account_Name__c,
                                    LastName = inputLead.LastName,
                                    FirstName = inputLead.FirstName
            );
            insert contactToCreate;
            accId = contactToCreate.AccountId;
        } else {
            accId = contactCreated[0].AccountId;
        }
        delete inputLead;
        return accId;
    }

    public String convertLeadAccountAndContact(Lead inputLead){
        String accId = '';
        List<Account> accToCreate = new List<Account>([SELECT Id FROM Account WHERE Name = :inputLead.Company]);
        if(accToCreate.size() > 0) {
            accId = accToCreate[0].Id;
        } else {
            Account accToInsert = new Account(
                                            AccTypeNew__c = inputLead.AccountTypeNew__c,
                                            Segment_Affiliation__c = inputLead.Segmentation_Affiliation__c,
                                            CF_Lead_Source__c = inputLead.CF_Lead_Source__c,
                                            Sub_Lead_Source__c = inputLead.CF_Sub_Lead_Source__c,
                                            Website = inputLead.Website,
                                            Phone = inputLead.Phone
            );
            insert accToInsert;
            accId = accToInsert.Id;
        }
        List<Contact> contactCreated = new List<Contact>([SELECT Id, AccountId FROM Contact WHERE Email = :inputLead.Email]);
        if(contactCreated.size() > 0) {
            contactCreated[0].AccountId = accId;
            update contactCreated;
        } else {
             Contact contactToCreate = new Contact(
                                    Email = inputLead.Email,
                                    AccountId = accId,
                                    LastName = inputLead.LastName,
                                    FirstName = inputLead.FirstName
            );
            insert contactToCreate;
        }
        delete inputLead;
        return accId;
    }
    
    private static Account createAccount(Lead inputLead) {
        Account accToInsert = (Account)LeadConvertUtil.processLeadConvertionWithObject(inputLead, 'Account');
        System.debug(accToInsert);
        accToInsert.Client_Status__c = 'Pre-Contact';
        if(inputLead.CF_Lead_Source__c == 'Web Quote Owner') {
            accToInsert.Type = 'Owner';     
        } else {
            if(inputLead.CF_Lead_Source__c == 'Web Quote Owner Rep') {
                accToInsert.Type = 'Owner Rep'; 
            }
        }
        accToInsert.CF_Lead_Source__c = 'CleanQuote';
        System.debug(accToInsert);
        insert accToInsert;
        return accToInsert;
    }
    
    private static Opportunity createOpportunity(Lead inputLead, Account inputAccount, String contactId) {
        Opportunity oppToInsert = (Opportunity)LeadConvertUtil.processLeadConvertionWithObject(inputLead, 'Opportunity');
        System.debug(oppToInsert);
        List<String> envStatusCommList = new List<String>{inputLead.Contamination_Comment__c, inputLead.Government_Regulations_Comment__c, inputLead.Hazardous_Substances_Comment__c, inputLead.Pending_Proceedings_or_Lawsuits_Comments__c, inputLead.Risk_Studies_or_Assessments_Comments__c, inputLead.Sensitive_Industries_Comment__c};
        List<String> ownerStatusCommList = new List<String>{inputLead.Financial_Crime_Comments__c, inputLead.Foreclosure_Short_Sale_Comment__c, inputLead.Owner_as_Defendant_Comments__c, inputLead.Owner_Bankruptcy_Comment__c};
        oppToInsert.Property_Market_Value_Based_Upon__c = 'Initial Application';
        if(inputLead.More_than_2_Lenders__c) {
            oppToInsert.Estimated_Number_of_Lenders__c = 3;
        }
        oppToInsert.Environmental_Status_Explanation__c = concatComments(envStatusCommList);
        oppToInsert.Owner_Status_Explanation__c = concatComments(ownerStatusCommList);
        if(inputLead.Primary_Type__c == 'Other') {
            oppToInsert.Primary_Property_Type__c = 'UNCATEGORIZED';
        } else {
            oppToInsert.Primary_Property_Type__c = inputLead.Primary_Type__c;
        }
        oppToInsert.AccountId = inputAccount.Id;
        oppToInsert.App_Executed_Date__c = inputLead.Application_Submission_Date__c;
        oppToInsert.Application_Submission_Date__c = inputLead.Application_Submission_Date__c;
        if(inputLead.Partner_Company__c != null) {
            Account partnerNameAcc = checkAccDupes(inputLead.Partner_Company__c, false);
            Contact partnerContact = searchContactDupesPartner(inputLead.Partner_Email__c, inputLead.Partner_First_Name__c, inputLead.Partner_Last_Name__c);
            if(partnerContact == null && inputLead.Partner_Last_Name__c != null && inputLead.Partner_Email__c != inputLead.Property_Owner_Email__c) {
                partnerContact = new Contact(Email = inputLead.Partner_Email__c, FirstName = inputLead.Partner_First_Name__c, LastName = inputLead.Partner_Last_Name__c, Phone = inputLead.Partner_Phone__c);
                insert partnerContact;
                oppToInsert.Channel_Partner_Main_Contact__c = partnerContact.Id;
            }
            if(partnerContact == null && inputLead.Partner_Last_Name__c != null && inputLead.Partner_Email__c == inputLead.Property_Owner_Email__c) {
                oppToInsert.Channel_Partner_Main_Contact__c = contactId;
            }
            if(partnerNameAcc == null && inputLead.Partner_Company__c != null) {
                partnerNameAcc = new Account(Name = inputLead.Partner_Company__c);
                insert partnerNameAcc;
            }
            oppToInsert.Channel_Partner_Entity__c = partnerNameAcc.Id;
        }
        oppToInsert.Name = inputLead.Property_Street_Address__c + ' ' + inputLead.Property_City__c;
        oppToInsert.CloseDate = Date.today().addMonths(3);
        oppToInsert.Property_Owner_Main_Contact__c = contactId;
        oppToInsert.Relationship_to_Main_Contact__c = 'Owner';
        oppToInsert.Occupancy_Rate__c = inputLead.Current_Occupancy__c;
        oppToInsert.Last_Stage_Change_Date__c = Date.today();
        //picklist assignment Solar
        Map<String,String> mapOfPicklistsSolar = new Map<String, String>{'solar'=>'Solar', 'seismic' => 'Seismic', 'Energy Efficiency' => 'Renewable Energy (Non-Solar)'};
        for(String itemKey : mapOfPicklistsSolar.keySet()) {
            if(!String.isEmpty(inputLead.Property_Scope_Text__c) && inputLead.Property_Scope_Text__c.toLowerCase().contains(itemKey)) {
                oppToInsert.Type_of_Improvements_Multi__c = mapOfPicklistsSolar.get(itemKey);
            }     
        }
        //picklist assignment Solar Project Objective
        Map<String,String> mapOfPicklistsProjObj = new Map<String, String>{'New Construction'=>'New Construction', 'Upgrade/Retrofit' => 'Property Upgrades', 'Gut Rehab' => 'Repositioning'};
        for(String itemKey : mapOfPicklistsProjObj.keySet()) {
            if(!String.isEmpty(inputLead.Opp_Project_Scope__c) && inputLead.Opp_Project_Scope__c.contains(itemKey)) {
                oppToInsert.Project_Objective__c = mapOfPicklistsProjObj.get(itemKey);
            }     
        }
        //picklist assignment Work Status
        Map<String,String> mapOfConstWorkStatus = new Map<String, String>{'Planning'=>'Conceptual and Planning Stage', 'Permitting' => 'Contractor Identified', 'Construction' => 'In Construction','Completed - Looking for PACE reimbursement'=>'Construction Complete'};
        for(String itemKey : mapOfConstWorkStatus.keySet()) {
            if(!String.isEmpty(inputLead.Project_Stage__c) && inputLead.Project_Stage__c.contains(itemKey)) {
                oppToInsert.Construction_Work_Status__c = mapOfConstWorkStatus.get(itemKey);
            }     
        }
        if(inputLead.Environmental_Site_Assessment_Completed__c == 'Yes'){
            oppToInsert.Existing_Phase_I_Report_Completed__c = inputLead.Environmental_Site_Assessment_Completed__c;
        }
        if(!String.isEmpty(inputLead.Property_Scope_Text__c) && inputLead.Property_Scope_Text__c.toLowerCase().contains('solar')) {
            oppToInsert.Solar_Component__c = 'Yes';
        }else {
            oppToInsert.Solar_Component__c = 'No';
        }
        if(inputLead.Application_Submission_Date__c != null){
            oppToInsert.Next_Steps_Tickler__c  = inputLead.Application_Submission_Date__c.addDays(3);
        }
        if(inputLead.PPA__c == 'Yes') {
            oppToInsert.Solar_TPO_Structure__c = 'PPA';
        }
        System.debug(oppToInsert);
        if(!Test.isRunningTest()){
            oppToInsert.StageName = 'Initial App';
        }
        oppToInsert.Name = inputLead.Project_Name__c;
        oppToInsert.OwnerId = inputLead.OwnerId;
        if(Test.isRunningTest()) {
            oppToInsert.OwnerId = UserInfo.getUserId();
        }
        insert oppToInsert;
        moveFilesFromLeadToOpp(inputLead.Project_Name__c, oppToInsert.Name);
        assignFeedItemFromLeadToopp(inputLead.Id, oppToInsert.Id);
        updateProspectRecord(inputLead.Id, oppToInsert.Id);
        return oppToInsert;
    }
    
    private static List<Lien__c> createLien(Account inputAccount, Lead inputLead, Opportunity inputOpp) {
        List<Lien__c> lienToInsertList= new List<Lien__c>();
            Lien__c lienToInsert = (Lien__c)LeadConvertUtil.processLeadConvertionWithObject(inputLead, 'Lien__c');
            Lien__c lienToInsert2 = (Lien__c)LeadConvertUtil.processLeadConvertionWithObject(inputLead, 'Lien__c');
            Account accToAssign;
                if(inputLead.Mortgage_Lender_1st__c != null) {
                    accToAssign = checkAccDupes(inputLead.MORTGAGE_LENDER_1ST__C, true);
                    lienToInsert.Debt_Position__c = '1st';
                    if(accToAssign != null){
                        lienToInsert.Mortgage_Lender__c  = accToAssign.Id;
                    } else {
                        lienToInsert.Mortgage_Lender__c  = formAndInsAcc(inputLead.MORTGAGE_LENDER_1ST__C).Id;
                    }
                    lienToInsert.Opportunity__c = inputOpp.Id;
                    if(inputLead.Current_Balance_1st__c != null) {
                        lienToInsert.Current_Loan_Balance__c = inputLead.Current_Balance_1st__c;
                    }
                    if(inputLead.Current_Balance_2nd__c != null){
                        lienToInsert.Current_Loan_Balance__c += inputLead.Current_Balance_2nd__c;
                    }
                    lienToInsertList.add(lienToInsert);
                }
                if(inputLead.Mortgage_Lender_2nd__c != null) {
                    accToAssign = checkAccDupes(inputLead.MORTGAGE_LENDER_2ND__C, true);
                    lienToInsert2.Debt_Position__c = '2nd';
                    if(accToAssign != null){
                        lienToInsert2.Mortgage_Lender__c  = accToAssign.Id;
                    } else {
                        lienToInsert2.Mortgage_Lender__c  = formAndInsAcc(inputLead.MORTGAGE_LENDER_2ND__C).Id;
                    }
                    lienToInsert2.Opportunity__c = inputOpp.Id;
                    if(inputLead.Current_Balance_1st__c != null) {
                        lienToInsert2.Current_Loan_Balance__c = inputLead.Current_Balance_1st__c;
                    }
                    if(inputLead.Current_Balance_2nd__c != null){
                        lienToInsert2.Current_Loan_Balance__c += inputLead.Current_Balance_2nd__c;
                    }
                    lienToInsertList.add(lienToInsert2);
                }
                if(inputLead.MORE_THAN_2_LENDERS__C) {
                    Lien__c lienToInsert3 = (Lien__c)LeadConvertUtil.processLeadConvertionWithObject(inputLead, 'Lien__c');
                    Account accToConnect = checkAccDupes('Bank-TBD', false);
                    lienToInsert3.Type_of_Lender__c = 'Bank';
                    lienToInsert3.Opportunity__c = inputOpp.Id;
                    if(inputLead.Current_Balance_1st__c != null) {
                        lienToInsert3.Current_Loan_Balance__c = inputLead.Current_Balance_1st__c;
                    }
                    if(inputLead.Current_Balance_2nd__c != null){
                        lienToInsert3.Current_Loan_Balance__c += inputLead.Current_Balance_2nd__c;
                    }
                    if(accToAssign != null) {
                        lienToInsert3.Mortgage_Lender__c = accToConnect.Id;
                    }
                    lienToInsertList.add(lienToInsert3);
                }   
            insert lienToInsertList;
        return lienToInsertList;
    }
    
    private static List<Parcel__c> createParcel(Lead inputLead, Opportunity inputOpp) {
        List<Parcel__c> listToReturn = new List<Parcel__c>();
        if(inputLead.Number_of_Parcels__c > 0){
            for(Integer i = 0; i < inputLead.Number_of_Parcels__c; i++) {
                listToReturn.add(new Parcel__c(Name = 'Parcel ' + i, Opportunity__c = inputOpp.Id));
            }
            insert listToReturn;
        }
        return listToReturn;
    }

    private static Contact createContact(Lead inputLead, Account inputAccount) {
        Contact contactToInsert = (Contact)LeadConvertUtil.processLeadConvertionWithObject(inputLead, 'Contact');
            contactToInsert.Can_contact_with_marketing_materials__c = 'Yes';
            contactToInsert.LeadSource = 'CleanQuote';
            contactToInsert.Sub_Lead_Source__c = 'CleanQuote';
            contactToInsert.AccountId = inputAccount.Id;
            contactToInsert.LastName = inputLead.LastName;
            contactToInsert.Email = inputLead.Email;
        insert contactToInsert;
        return contactToInsert;
    }

    private static Account checkAccDupes(String accName, Boolean bankingAcc) {
        String queryAcc = 'SELECT Id, City__c, State__c, Street_Address__c, Zip_Code__c, Entity_Type__c, Type, Name FROM Account WHERE Name = :accName';
        List<Account> accToReturn = new List<Account>();
        if(bankingAcc) {
            queryAcc += ' AND Client_Status__c = \'Pre-Contact\' AND Type = \'Bank\'';
        }
        queryAcc += ' LIMIT 1';
        accToReturn = Database.query(queryAcc);
        if(accToReturn.size() > 0) {
            return accToReturn[0];
        } else {
            return null;
        }
    }

    private static List<Tenant__c> createTenant(Lead inputLead, Opportunity inputOpp) {
        List<Tenant__c> listOfTenants = new List<Tenant__c>();
        if(inputLead.NUM_OF_TENANTS__C > 0){
            for(Integer i = 1; i < inputLead.NUM_OF_TENANTS__C; i++) {
                listOfTenants.add(new Tenant__c(Name = 'Tenant ' + i, Opportunity__c = inputOpp.Id));
            }
            insert listOfTenants;
        }
        return listOfTenants;
    }

    private static Account formAndInsAcc(String accName) {
        Account accToInsert = new Account(
                                        Name = accName,
                                        Client_Status__c = 'Pre-Contact',
                                        Type = 'Bank'
                                        );
        insert accToInsert;
        return accToInsert;
    }

    private static Contact searchContactDupesPartner(String email, String firstName, String lastName) {
        List<Contact> contactToCheck = new List<Contact>([SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE Email = :email AND FirstName = :firstName AND LastName = :lastName]);
        if(contactToCheck.size() > 0) {
            return contactToCheck[0];
        } else {
            return null;
        }
    }
    
    private static Contact searchContactDupesSimple(String email, String firstName, String lastName) {
        List<Contact> contactToCheck = new List<Contact>([SELECT Id, AccountId, Account.Name, FirstName, LastName, Email, Phone FROM Contact WHERE Email = :email AND FirstName = :firstName AND LastName = :lastName]);
        if(contactToCheck.size() > 0) {
            return contactToCheck[0];
        } else {
            return null;
        }
    }
    
    private static void attachmentReaasign(String leadId, String oppId) {
        List<Attachment> listOfAttachToReassign = new List<Attachment>();
        List<Attachment> listOfAttachToDelete = new List<Attachment>();
        for(Attachment itemAtt : [SELECT Id, Body, Name, ContentType, Description, OwnerId, ParentId FROM Attachment WHERE ParentID = :leadId]) {
               Attachment attToInsert = itemAtt.clone(false, false, false, false);
               attToInsert.ParentId = oppId;
               attToInsert.IsPrivate = true;
               listOfAttachToReassign.add(attToInsert);
               listOfAttachToDelete.add(itemAtt);
        }
        delete listOfAttachToDelete;
        upsert listOfAttachToReassign;
    }

    private static String concatComments(List<String> listOfComments) {
        String concatedComments = '';
        for(String itemString : listOfComments) {
            if(!String.isEmpty(itemString)) {
                concatedComments =+ itemString + ' ';
            }
        }
        if(!String.isEmpty(concatedComments)){
            concatedComments = concatedComments.substring(0, concatedComments.length() - 1);
        }
        return concatedComments;
    }
    
    private static void updateProspectRecord(Id leadId, Id oppId) {
        List<Prospect__c> listOfRecordsToUpdate = new List<Prospect__c>();
        for(Prospect__c item : [SELECT Id, Opportunity__c  FROM Prospect__c WHERE Lead_ID__c = :leadId]) {
            item.Opportunity__c = oppId;
            listOfRecordsToUpdate.add(item);
        }
        if(!listOfRecordsToUpdate.isEmpty()) {
            update listOfRecordsToUpdate;
        }
    }

    @future(callout=true)
    private static void moveFilesFromLeadToOpp(String projectName, String oppProjectName) {
        if(Test.isRunningTest()) {
            projectName = 'Test';
        }
        String authCode = EgnyteGeneral__c.getOrgDefaults().Value__c;
        String endpoint = 'https://cleanfund.egnyte.com/pubapi/v1/fs/Shared/Projects/Active/' + EncodingUtil.urlEncode(projectName, 'UTF-8').replace('+','%20');
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        System.debug(endpoint);
        req.setHeader('Authorization', 'Bearer '+ authCode);
        req.setHeader('content-type', 'application/json');
        req.setMethod('POST');
        String body = '{"action" : "move", "destination" : "/Shared/Projects/Active/'+oppProjectName+'"}';
        System.debug(body);
        req.setbody(body);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug(response.getBody());
       // EgnyteAPIHandler.copyFolderTemplate(projectName);
    }

    public static void assignFeedItemFromLeadToopp(String itemLeadId, String itemOppId) {
        List<FeedItem> listToInsert = new List<FeedItem>();
        List<FeedItem> listOfFeedItems = new List<FeedItem>([SELECT BestCommentId, Body, CommentCount, CreatedById, CreatedDate, CreatedBy.IsActive, CreatedBy.Name, 
                                        HasContent, HasLink, Id, IsDeleted, LastEditById, LastEditDate, LastModifiedDate, LikeCount, 
                                        LinkUrl, ParentId, RelatedRecordId, Revision, SystemModstamp, Title, Type,
                                        (SELECT CommentBody, CommentType, CreatedById, CreatedDate, FeedItemId,
                                                IsDeleted, LastEditById, LastEditDate, ParentId, RelatedRecordId, Revision 
                                         FROM FeedComments)
                                 FROM FeedItem
                                 WHERE ParentId = :itemLeadId AND Type != 'TrackedChange']);
        for(FeedItem itemFeed : listOfFeedItems) {
            FeedItem clone = itemFeed.clone(false, false, true, true);
            clone.ParentId = itemOppId;
            listToInsert.add(clone);
        }
        if(listToInsert.size() > 0) {
            insert listToInsert;
            delete listOfFeedItems;
        }
    }
}