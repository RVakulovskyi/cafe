@isTest
public class AccountTriggerHandlerTest  {

    @isTest
    public static void testAccTriggerMethods(){
        Account testAccount = new Account(Name='TestAccount1',AccTypeNew__c = 'Unknown',Client_Status__c='N/A',CF_Lead_Source__c='Other');
        Account testAccountMaster = new Account(Name='TestAccount2',AccTypeNew__c = 'Unknown',Client_Status__c='N/A',CF_Lead_Source__c='Other');
        Contact testContact = new Contact(FirstName ='test', LastName='TestContact1', Email = 'test@example.com',CF_Lead_Source__c='Other',Sub_Lead_Source__c='test',Can_contact_with_marketing_materials__c='Yes');
        Contact testContact2 = new Contact(FirstName ='test', LastName='TestContact1',Email = 'test@example.com',CF_Lead_Source__c='Other',Sub_Lead_Source__c='test',Can_contact_with_marketing_materials__c='Yes');
        test.startTest();
        insert new List<Account>{testAccount, testAccountMaster};
        testContact.AccountId = testAccount.id;
        insert testContact;
        testContact2.AccountId = testAccount.id;
        insert testContact2;
        testAccount.Name = 'TestAccount3';
        //testAccount.MasterRecordId = testAccountMaster.Id;
        update testAccount;
        testAccount = [SELECT Id, MasterRecordId FROM Account WHERE Id = :testAccount.Id];
        Task testTask = new Task(WhatId = testAccount.Id, Description = testAccountMaster.Id);
        insert testTask;
        Contact testInsert1 = new Contact();
        testInsert1 = [Select id from Contact where id = :testContact.id];
       // System.debug('testLead1 - '+testInsert1);
        
        Contact testInsert2 = new Contact();
        testInsert2 = [Select id from Contact where id = :testContact2.id];
        //System.debug('testLead2 - '+testInsert2);
        
            delete testInsert1;
        merge testAccountMaster testAccount;
        System.assertEquals(true, [SELECT ID FROM Task].size() > 0, 'There should be tasks');
       test.stopTest();
    }

        @isTest
    public static void testAccTriggerMethods2(){
        Account testAccount = new Account(Name='TestAccount1',AccTypeNew__c = 'Unknown',Client_Status__c='N/A',CF_Lead_Source__c='Other');
        Account testAccountMaster = new Account(Name='TestAccount2',AccTypeNew__c = 'Unknown',Client_Status__c='N/A',CF_Lead_Source__c='Other');
        Contact testContact = new Contact(FirstName ='test', LastName='TestContact1', Email = 'test@example.com',CF_Lead_Source__c='Other',Sub_Lead_Source__c='test',Can_contact_with_marketing_materials__c='Yes');
        Contact testContact2 = new Contact(FirstName ='test', LastName='TestContact1',Email = 'test@example.com',CF_Lead_Source__c='Other',Sub_Lead_Source__c='test',Can_contact_with_marketing_materials__c='Yes');
        test.startTest();
        insert new List<Account>{testAccount, testAccountMaster};
        testContact.AccountId = testAccount.id;
        insert testContact;
        testContact2.AccountId = testAccount.id;
        insert testContact2;
        testAccount.Name = 'TestAccount3';
        //testAccount.MasterRecordId = testAccountMaster.Id;
        update testAccount;
        testAccount = [SELECT Id, MasterRecordId FROM Account WHERE Id = :testAccount.Id];
        Task testTask = new Task(WhatId = testAccount.Id, Description = 'Test');
        insert testTask;
        Contact testInsert1 = new Contact();
        testInsert1 = [Select id from Contact where id = :testContact.id];
       // System.debug('testLead1 - '+testInsert1);
        
        Contact testInsert2 = new Contact();
        testInsert2 = [Select id from Contact where id = :testContact2.id];
        //System.debug('testLead2 - '+testInsert2);
        
            delete testInsert1;
        merge testAccountMaster testAccount;
        System.assertEquals(true, [SELECT ID FROM Task].size() > 0, 'There should be tasks');
       test.stopTest();
    }
}