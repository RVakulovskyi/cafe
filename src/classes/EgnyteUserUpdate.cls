public class EgnyteUserUpdate {
	
    @AuraEnabled
    public static void updateEgnyteCreds(String userLogin, String userPassword) {
        User userForUpdate = [SELECT Id,Egnyte_Login__c, Egnyte_Password__c FROM User WHERE Id = :UserInfo.getUSerId()];
        	userForUpdate.Egnyte_Login__c = userLogin;
        	userForUpdate.Egnyte_Password__c = userPassword;
        update userForUpdate; 
    }
    
    @AuraEnabled
    public static Boolean findEgnyteCreds() {
        Boolean flagToShow = false;
        User userForUpdate = [SELECT Id,Egnyte_Login__c, Egnyte_Password__c FROM User WHERE Id = :UserInfo.getUSerId()];
        if(String.isEmpty(userForUpdate.Egnyte_Login__c) && String.isEmpty(userForUpdate.Egnyte_Password__c)) {
            flagToShow = true;
        }
        return flagToShow;
    }
}