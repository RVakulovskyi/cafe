/**
* @author Conga
* @author Joseph Markey
* @Edited by Brendan Neal 5/15/2018
* @version 1.01
* @description describes the DocumentRequestListUtilities class
*/
public with sharing class DocumentRequestListUtilities {
    public Opportunity opp;

    // constructor
    public DocumentRequestListUtilities(ApexPages.StandardController stdController) {
        this.opp = (Opportunity)stdController.getRecord();
    }

    @RemoteAction
    public static void generateDocumentRequestList(Id pOppId) {
        // query this Opportunity record
        Opportunity thisOpp = [
            SELECT Id, Name, State_Prop__c, Solar_TPO_Structure__c, App_Executed_Date__c, Is_there_a_groundlease_in_place__c, CF_Due_Diligence_Deposit__c, Account.Entity_Type__c, Primary_Property_type__c, Account.Entity_Sub_Type__c, Project_Type__c
            FROM Opportunity
            WHERE Id = :pOppId
        ];
        // instantiate a new, empty Document_Request_List__c list
        List<Document_Request_List__c> documentRequestList = new List<Document_Request_List__c>();
        List<DRL_Template_Item__c> itemList = [SELECT Id, Name, Item__c, Document_Name__c, DRL_Template_Number_Map__c, Notes_and_Comments__c, Responsible_Party__c, Stage__c FROM DRL_Template_Item__c];
        for(DRL_Template_Item__c item : itemList) {
            // add standard documents
            if(item.DRL_Template_Number_Map__c=='DRL-0001' || item.DRL_Template_Number_Map__c=='DRL-0002' ||
               item.DRL_Template_Number_Map__c=='DRL-0003' || item.DRL_Template_Number_Map__c=='DRL-0004' || 
               item.DRL_Template_Number_Map__c=='DRL-0006' || item.DRL_Template_Number_Map__c=='DRL-0007' || 
               item.DRL_Template_Number_Map__c=='DRL-0008' || item.DRL_Template_Number_Map__c=='DRL-0010' || 
               item.DRL_Template_Number_Map__c=='DRL-0011' || item.DRL_Template_Number_Map__c=='DRL-0018' || 
               item.DRL_Template_Number_Map__c=='DRL-0019' || item.DRL_Template_Number_Map__c=='DRL-0020' || 
               item.DRL_Template_Number_Map__c=='DRL-0021' || item.DRL_Template_Number_Map__c=='DRL-0023' || 
               item.DRL_Template_Number_Map__c=='DRL-0024' || item.DRL_Template_Number_Map__c=='DRL-0028' || 
               item.DRL_Template_Number_Map__c=='DRL-0029' || item.DRL_Template_Number_Map__c=='DRL-0030' || 
               item.DRL_Template_Number_Map__c=='DRL-0031' || item.DRL_Template_Number_Map__c=='DRL-0032' || 
               item.DRL_Template_Number_Map__c=='DRL-0033' || item.DRL_Template_Number_Map__c=='DRL-0036' || 
               item.DRL_Template_Number_Map__c=='DRL-0037' || item.DRL_Template_Number_Map__c=='DRL-0042' || 
               item.DRL_Template_Number_Map__c=='DRL-0043' || item.DRL_Template_Number_Map__c=='DRL-0044' || 
               item.DRL_Template_Number_Map__c=='DRL-0045' || item.DRL_Template_Number_Map__c=='DRL-0046') {
                Document_Request_List__c documentRequestObjStandard = new Document_Request_List__c(
                    // assign the non-standard fields
                    DRL_Template_ItemID__c = item.Id,
                    Document_Name_Global__c = item.Document_Name__c,
                    Notes_and_Comments__c = item.Notes_and_Comments__c,
                    Responsible_Party__c = item.Responsible_Party__c,
                    Stage__c = item.Stage__c,
                    Item__c = item.Item__c,
                    // assign the standard fields
                    Opportunity__c = thisOpp.Id,
                    Status__c = 'Open'
                );
                documentRequestList.add(documentRequestObjStandard);
            }

            // add non-stadard documents
            //NewCon or Gut Rehab
            if(thisOpp.Project_Type__c=='New Construction' || thisOpp.Project_Type__c=='Gut Rehab') {
                if(item.DRL_Template_Number_Map__c=='DRL-0005' || item.DRL_Template_Number_Map__c=='DRL-0012' || item.DRL_Template_Number_Map__c=='DRL-0013' || item.DRL_Template_Number_Map__c=='DRL-0034') {
                    Document_Request_List__c documentRequestObjStandard2 = new Document_Request_List__c(
                        // assign the non-standard fields
                        DRL_Template_ItemID__c = item.Id,
                        Document_Name_Global__c = item.Document_Name__c,
                        Notes_and_Comments__c = item.Notes_and_Comments__c,
                        Responsible_Party__c = item.Responsible_Party__c,
                        Stage__c = item.Stage__c,
                        Item__c = item.Item__c,
                        // assign the standard fields
                        Opportunity__c = thisOpp.Id,
                        Status__c = 'Open'
                    );
                    documentRequestList.add(documentRequestObjStandard2);
                }
            }
            
             //Ground Lease
            if(thisOpp.Is_there_a_groundlease_in_place__c == 'Yes') {
                if(item.DRL_Template_Number_Map__c=='DRL-0009') {
                    Document_Request_List__c documentRequestObjStandard3 = new Document_Request_List__c(
                        // assign the non-standard fields
                        DRL_Template_ItemID__c = item.Id,
                        Document_Name_Global__c = item.Document_Name__c,
                        Notes_and_Comments__c = item.Notes_and_Comments__c,
                        Responsible_Party__c = item.Responsible_Party__c,
                        Stage__c = item.Stage__c,
                        Item__c = item.Item__c,
                        // assign the standard fields
                        Opportunity__c = thisOpp.Id,
                        Status__c = 'Open'
                    );
                    documentRequestList.add(documentRequestObjStandard3);
                }
            }
            
             //Hospitality shenanigans
            if(thisOpp.Primary_Property_Type__c == 'Hospitality') {
                if(item.DRL_Template_Number_Map__c=='DRL-0014' || item.DRL_Template_Number_Map__c=='DRL-0015' || item.DRL_Template_Number_Map__c=='DRL-0016') {
                    Document_Request_List__c documentRequestObjStandard4 = new Document_Request_List__c(
                        // assign the non-standard fields
                        DRL_Template_ItemID__c = item.Id,
                        Document_Name_Global__c = item.Document_Name__c,
                        Notes_and_Comments__c = item.Notes_and_Comments__c,
                        Responsible_Party__c = item.Responsible_Party__c,
                        Stage__c = item.Stage__c,
                        Item__c = item.Item__c,
                        // assign the standard fields
                        Opportunity__c = thisOpp.Id,
                        Status__c = 'Open'
                    );
                    documentRequestList.add(documentRequestObjStandard4);
                }
            }
            
            //More Hospitality shenanigans
            if(thisOpp.Primary_Property_Type__c == 'Hospitality' && thisOpp.Project_Type__c == 'Upgrade/Retrofit') {
                if(item.DRL_Template_Number_Map__c=='DRL-0017') {
                    Document_Request_List__c documentRequestObjStandard5 = new Document_Request_List__c(
                        // assign the non-standard fields
                        DRL_Template_ItemID__c = item.Id,
                        Document_Name_Global__c = item.Document_Name__c,
                        Notes_and_Comments__c = item.Notes_and_Comments__c,
                        Responsible_Party__c = item.Responsible_Party__c,
                        Stage__c = item.Stage__c,
                        Item__c = item.Item__c,
                        // assign the standard fields
                        Opportunity__c = thisOpp.Id,
                        Status__c = 'Open'
                    );
                    documentRequestList.add(documentRequestObjStandard5);
                }
            }
            
            //Entities that aren't Trusts
            if(thisOpp.Account.Entity_Type__c != 'Trust') {
                if(item.DRL_Template_Number_Map__c=='DRL-0022' || item.DRL_Template_Number_Map__c=='DRL-0025' || item.DRL_Template_Number_Map__c=='DRL-0026' || item.DRL_Template_Number_Map__c=='DRL-0027') {
                    Document_Request_List__c documentRequestObjStandard6 = new Document_Request_List__c(
                        // assign the non-standard fields
                        DRL_Template_ItemID__c = item.Id,
                        Document_Name_Global__c = item.Document_Name__c,
                        Notes_and_Comments__c = item.Notes_and_Comments__c,
                        Responsible_Party__c = item.Responsible_Party__c,
                        Stage__c = item.Stage__c,
                        Item__c = item.Item__c,
                        // assign the standard fields
                        Opportunity__c = thisOpp.Id,
                        Status__c = 'Open'
                    );
                    documentRequestList.add(documentRequestObjStandard6);
                }
            }
            
            //Entities that aren't Trusts
            if(thisOpp.Solar_TPO_Structure__c == 'PPA') {
                if(item.DRL_Template_Number_Map__c=='DRL-0038' || item.DRL_Template_Number_Map__c=='DRL-0039' || item.DRL_Template_Number_Map__c=='DRL-0040' || item.DRL_Template_Number_Map__c=='DRL-0041') {
                    Document_Request_List__c documentRequestObjStandard7 = new Document_Request_List__c(
                        // assign the non-standard fields
                        DRL_Template_ItemID__c = item.Id,
                        Document_Name_Global__c = item.Document_Name__c,
                        Notes_and_Comments__c = item.Notes_and_Comments__c,
                        Responsible_Party__c = item.Responsible_Party__c,
                        Stage__c = item.Stage__c,
                        Item__c = item.Item__c,
                        // assign the standard fields
                        Opportunity__c = thisOpp.Id,
                        Status__c = 'Open'
                    );
                    documentRequestList.add(documentRequestObjStandard7);
                }
            }

            
        }

        // first, delete all of this Opportunity Document_Request_List__c related list items
        delete [SELECT Id, Opportunity__c FROM Document_Request_List__c WHERE Opportunity__c = :pOppId];

        // finally, insert the new Opportunity Document_Request_List__c related list items
        insert documentRequestList; 
    }

}