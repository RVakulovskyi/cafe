@isTest
public class ContactTriggerHandlerTest {


    @isTest 
    public static void Create(){
        Account testAccount = new Account(Name='TestAccount1',AccTypeNew__c = 'Unknown',Client_Status__c='N/A',CF_Lead_Source__c='Other');
        Contact testContact = new Contact(FirstName ='test',LastName='TestContact1',Email = 'test@example.com',CF_Lead_Source__c='Other',Sub_Lead_Source__c='test',Can_contact_with_marketing_materials__c='Yes');
        Test.startTest();
        insert testAccount;
        testContact.AccountId = testAccount.id;
        insert testContact;
        Test.stopTest();
        
        //System.assert(testLead.IsConverted);   
    }
    
    @isTest
    public static void taskListTest(){
        Account testAccount = new Account(Name='TestAccount1',AccTypeNew__c = 'Unknown',Client_Status__c='N/A',CF_Lead_Source__c='Other');
        Contact testContact = new Contact(FirstName ='test', LastName='TestContact1', Email = 'test@example.com',CF_Lead_Source__c='Other',Sub_Lead_Source__c='test',Can_contact_with_marketing_materials__c='Yes');
        Contact testContact2 = new Contact(FirstName ='test', LastName='TestContact1',Email = 'test@example.com',CF_Lead_Source__c='Other',Sub_Lead_Source__c='test',Can_contact_with_marketing_materials__c='Yes');
        List<Task> duplicatedTask = new List<Task>();
        test.startTest();
        insert testAccount;
        testContact.AccountId = testAccount.id;
        insert testContact;
        testContact2.AccountId = testAccount.id;
        insert testContact2;
        
        Contact testInsert1 = new Contact();
        testInsert1 = [Select id from Contact where id = :testContact.id];
       // System.debug('testLead1 - '+testInsert1);
        
        Contact testInsert2 = new Contact();
        testInsert2 = [Select id from Contact where id = :testContact2.id];
        //System.debug('testLead2 - '+testInsert2);
        
            delete testInsert1;
       test.stopTest();
    }
}