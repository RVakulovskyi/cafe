@isTest
public class LeadTriggerHandlerTest {
    
    
    @isTest 
    public static void autoConvertOnCreate(){
        createCustomSetting();
        Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
        Account testAccount = new Account(Name='TestAccount1',AccTypeNew__c = 'Unknown',Client_Status__c='N/A',CF_Lead_Source__c='Other');
        Lead testlead = new Lead(LastName='TestLead1',Company='TestAccount1',AccountTypeNew__c = 'Unknown',Status='Open',CF_Sub_Lead_Source__c='test', Run_Duplicate_Rules__c = true);
        Test.startTest();
        insert testAccount;
        insert testLead;
        Test.stopTest();
        
        //System.assert(testLead.IsConverted);   
    }
    @isTest
    public static void autoConvertOnUpdate(){
        createCustomSetting();
        Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
        Account testAccount = new Account(Name='TestAccount1',AccTypeNew__c = 'Unknown',Client_Status__c='N/A',CF_Lead_Source__c='Other');
        Lead testlead = new Lead(LastName = 'testLead2',Company = 'test1',AccountTypeNew__c = 'Unknown',Status='Open',CF_Sub_Lead_Source__c='test',Run_Duplicate_Rules__c=true);
        Lead testlead3 = new Lead(LastName = 'testLead1',Company = 'test2',AccountTypeNew__c = 'Unknown',Status='Open',CF_Sub_Lead_Source__c='test',Run_Duplicate_Rules__c=true);
        List<Lead> toUpdate = new List<Lead>();
        test.startTest();
        insert testAccount;
        insert testLead3;
        insert testLead;
        List<Lead> testLead2 = new List<Lead>([Select id, LastName, Company from Lead where Company ='test' limit 1]);
        if (!testlead2.isEmpty()){
            for(Lead l :testLead2){
                l.Company = 'TestAccount1';
                toUpdate.add(l);
            }
        }else {System.debug('No lead with test company');}
        update toUpdate;
        Task testTask = new Task(Description = 'Test', WhoId = testLead3.Id);
        insert testTask;
        merge testLead3 testlead;
        test.stopTest();
        
        // System.assert(toUpdate[0].IsConverted);
        
    }
    @isTest
    public static void taskListTest(){
        createCustomSetting();
        Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
        Lead testLead = new Lead (FirstName ='t',LastName = 'testLead2', Email='test@example.com',Company = 'test1',AccountTypeNew__c = 'Unknown',Status='Open',CF_Sub_Lead_Source__c='test',Run_Duplicate_Rules__c=true);
        Lead testLead2 = new Lead (FirstName ='t',LastName = 'testLead2',Email='test@example.com',Company = 'test2',AccountTypeNew__c = 'Unknown',Status='Open',CF_Sub_Lead_Source__c='test',Run_Duplicate_Rules__c=true);
        List<Task> duplicatedTask = new List<Task>();
        test.startTest();
        insert testLead;
         
        insert testLead2;
        
        Lead testInsert1 = new Lead();
        testInsert1 = [Select id from Lead where id = :testLead.id];
       // System.debug('testLead1 - '+testInsert1);
        
        Lead testInsert2 = new Lead();
        testInsert2 = [Select id from Lead where id = :testLead2.id];
        //System.debug('testLead2 - '+testInsert2);
        
            delete testInsert1;
       test.stopTest();
    }

    @isTest
    public static void autoConvertOnUpdate2(){
        createCustomSetting();
        Test.setMock(HttpCalloutMock.class, new EgnyteHttpCalloutImpl());
        Account testAccount = new Account(Name='TestAccount1',AccTypeNew__c = 'Unknown',Client_Status__c='N/A',CF_Lead_Source__c='Other');
        Lead testlead1 = new Lead(LastName = 'testLead2',Company = 'test1',AccountTypeNew__c = 'Unknown',Status='Open',CF_Sub_Lead_Source__c='test',Run_Duplicate_Rules__c=true);
        Lead testlead3 = new Lead(LastName = 'testLead1',Company = 'test2',AccountTypeNew__c = 'Unknown',Status='Open',CF_Sub_Lead_Source__c='test',Run_Duplicate_Rules__c=true);
        List<Lead> toUpdate = new List<Lead>();
        test.startTest();
        insert testAccount;
        insert testLead1;
        insert testLead3;
        List<Lead> testLead2 = new List<Lead>([Select id, LastName, Company from Lead where Company ='test' limit 1]);
        if (!testlead2.isEmpty()){
            for(Lead l :testLead2){
                l.Company = 'TestAccount1';
                toUpdate.add(l);
            }
        }else {System.debug('No lead with test company');}
        update toUpdate;
        Task testTask = new Task(Description = testLead3.Id, WhoId = testLead3.Id);
        insert testTask;
        merge testLead3 testlead1;
        test.stopTest();
        
        // System.assert(toUpdate[0].IsConverted);
        
    }

    private static void createCustomSetting() {
        Egnyte__c egnCs = Egnyte__c.getOrgDefaults();
        egnCs.Value__c = '1111111111111111111111';
        upsert egnCs Egnyte__c.Id;
        EgnyteGeneral__c egnCsGent = EgnyteGeneral__c.getOrgDefaults();
        egnCsGent.Value__c = '1111111111111111111111';
        upsert egnCsGent EgnyteGeneral__c.Id;
    }
    
}