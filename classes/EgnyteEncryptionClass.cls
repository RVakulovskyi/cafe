public class EgnyteEncryptionClass  {

    public static void cryptPassword(String password) {
        String val = password;
        Blob key = Blob.valueOf('egnytekeyforSFDC');
        Blob encryptedValue = Crypto.encryptWithManagedIV('AES128', key, Blob.valueOf(val));
        String encryptedString = EncodingUtil.base64encode(encryptedValue);
        Egnyte__c egnyteCS = Egnyte__c.getOrgDefaults();
        egnyteCS.Value__c = encryptedString;
        upsert egnyteCS;
    }
}