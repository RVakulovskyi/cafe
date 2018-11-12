@isTest
private class addContactRoleTest{
    static Account acc;
    static list<contact> contacts;
    static Opportunity op1;
    
    static void dataSetup() {
       acc = TestHelperUtility.createAccount(null, null, 'TestAccounts', 'Pre-Contact', 'Channel Partner');     
       contacts = new list<Contact>();
       // Create two contacts
       Contact ct1 = TestHelperUtility.createContact(acc.Id, 'Larrys', 'Page');
       Contact ct2 = TestHelperUtility.createContact(acc.Id, 'Marc', 'Buymeoff');
       contacts.add(ct1);
       contacts.add(ct2);
       insert contacts;
       op1 = TestHelperUtility.createOpportunityForBonds(acc.Id, contacts[0].Id, null, 'Opportunity Contact Insertion Test', 7.5);
    }
    
    static testmethod void TestOpportunityTrgr1() { 
        dataSetup();
        Test.startTest();          
        	Database.SaveResult sr1 = Database.insert(op1, true);
        Test.stopTest();
        System.assert(sr1.isSuccess());
        System.assert([SELECT id FROM OpportunityContactRole WHERE ContactId=:contacts[0].Id AND OpportunityId=:op1.Id AND Isprimary=true].size() > 0 ,
                      'Making sure new OpportunityContactRole has been inserted for this oppty.');
     }        
     
     static testmethod void TestOpportunityTrgr2() {  
         dataSetup();
         insert op1;
         op1.Channel_Partner_Main_Contact__c = contacts[1].Id;
         Test.startTest();          
         	Database.SaveResult sr1 = Database.update(op1, true);
         Test.stopTest();
         System.assert([SELECT id FROM OpportunityContactRole WHERE ContactId=:contacts[0].Id AND OpportunityId=:op1.Id AND Isprimary=false].size()>0
         ,'Making sure non-primary OpportunityContactRole has been updated for this oppty.');
         
         System.assert([SELECT id FROM OpportunityContactRole WHERE ContactId=:contacts[1].Id AND OpportunityId=:op1.Id AND Isprimary=true].size()>0
         ,'Making sure new OpportunityContactRole has been inserted for this oppty.');
         
         System.assert(sr1.isSuccess());
         system.debug('Opportunity updated');
     }         
     
     static testmethod void TestOpportunityTrgr3() {  
         dataSetup();
         insert op1;         
         Test.startTest();          
         	Database.SaveResult sr1 = Database.update(op1, true);
         Test.stopTest();
         System.assert(sr1.isSuccess()); 
         System.assert([SELECT id FROM OpportunityContactRole WHERE ContactId=:contacts[0].Id AND OpportunityId=:op1.Id AND Isprimary=true].size()>0
         ,'Making sure new OpportunityContactRole has been inserted for this oppty.');
         system.debug('Opportunity updated');
     }  
     
     static testmethod void TestOpportunityTrgr4() {  
         dataSetup();
         insert op1;
         delete [SELECT id FROM OpportunityContactRole WHERE ContactId=:contacts[0].Id AND OpportunityId=:op1.Id AND Isprimary=true];
         Test.startTest();          
         	Database.SaveResult sr1 = Database.update(op1, true);
         Test.stopTest();
         System.assert(sr1.isSuccess());
         System.assert([SELECT id FROM OpportunityContactRole WHERE ContactId=:contacts[0].Id AND OpportunityId=:op1.Id AND Isprimary=true].size()>0
         ,'Making sure new OpportunityContactRole has been inserted for this oppty.');
         system.debug('Opportunity updated');
     }  
}