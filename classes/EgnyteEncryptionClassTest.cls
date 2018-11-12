@isTest
public class EgnyteEncryptionClassTest  {

    public static testmethod void testEncryption() {
        Test.startTest();
            EgnyteEncryptionClass.cryptPassword('Test');
        Test.stopTest();
    }
}