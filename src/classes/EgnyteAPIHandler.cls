global class EgnyteAPIHandler {

    public static void formEgnyteRequest() {   
        String decryptedString='';
        if(!Test.isRunningTest()){
            Blob base64 =  EncodingUtil.base64decode(Egnyte__c.getOrgDefaults().Value__c);
            Blob key = Blob.valueOf('egnytekeyforSFDC');
            Blob decryptedValue = Crypto.decryptWithManagedIV('AES128', key, base64);
            decryptedString = decryptedValue.toString();
        }
        String endpoint = 'https://cleanfund.egnyte.com/puboauth/token';
        String body='client_id=bx2w8aanyr8f8rsk29kkmvvm&username=utility@cleanfund.com&password='+decryptedString+'&grant_type=password&scope=Egnyte.filesystem%20Egnyte.launchwebsession';
        System.debug(body);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setBody(body);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug(response.getBody());
        Map<String, Object> authCodeMap = new Map<String, Object>();
        System.debug(response.getBody());
        if(!Test.isRunningTest()){
            authCodeMap = (Map<String, Object>)Json.deserializeUntyped(response.getBody());
        }
        if(authCodeMap.containsKey('access_token')) {
             String authCode = String.valueOf(authCodeMap.get('access_token'));
             EgnyteGeneral__c egnyteCS = EgnyteGeneral__c.getOrgDefaults();
             egnyteCS.Value__c = authCode;
             upsert egnyteCS;

        }
    }

    @future(callout=true)
    public static void createFolder(String folderPath) {
        
        String decryptedString = EgnyteGeneral__c.getOrgDefaults().Value__c;
        System.debug(decryptedString);
        String endpoint = 'https://cleanfund.egnyte.com/pubapi/v1/fs/Shared/Projects/'+folderPath;
        System.debug(endpoint);
        String body ='{"action":"add_folder"}';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setHeader('Authorization', 'Bearer '+ decryptedString);
        req.setHeader('content-type', 'application/json');
        req.setMethod('POST');
        req.setBody(body);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug(response);
        copyFolderTemplate(folderPath.replace('%20',' '));
    }

    @future(callout=true)
    public static void createFolderLead(String folderPath) {
        
        String decryptedString = EgnyteGeneral__c.getOrgDefaults().Value__c;
        System.debug(decryptedString);
        String endpoint = 'https://cleanfund.egnyte.com/pubapi/v1/fs/Shared/Projects/Active/'+folderPath;
        System.debug(endpoint);
        String body ='{"action":"add_folder"}';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setHeader('Authorization', 'Bearer '+ decryptedString);
        req.setHeader('content-type', 'application/json');
        req.setMethod('POST');
        req.setBody(body);
        Http http = new Http();
        if(!Test.isRunningTest()){
            HTTPResponse response = http.send(req);
            System.debug(response.getStatus());
        }
        copyFolderTemplate('Active/' + folderPath.replace('%20',' '));
    }

    @future(callout=true)
    public static void createFolderChild(String folderPath) {
        
        String decryptedString = EgnyteGeneral__c.getOrgDefaults().Value__c;
        System.debug(decryptedString);
        String endpoint = 'https://cleanfund.egnyte.com/pubapi/v1/fs/Shared/Projects/Active/'+folderPath;
        System.debug(endpoint);
        String body ='{"action":"add_folder"}';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setHeader('Authorization', 'Bearer '+ decryptedString);
        req.setHeader('content-type', 'application/json');
        req.setMethod('POST');
        req.setBody(body);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug(response.getBody());
    }
       
    @future(callout=true)
    public static void moveFile(String pathToFolder, String folderToMove) {
        
        String decryptedString = EgnyteGeneral__c.getOrgDefaults().Value__c;
        String endpoint = 'https://cleanfund.egnyte.com/pubapi/v1/fs/Shared/Projects/' + pathToFolder;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        System.debug(endpoint);
        req.setHeader('Authorization', 'Bearer '+ decryptedString);
        req.setHeader('content-type', 'application/json');
        req.setMethod('POST');
        String body = '{"action" : "move", "destination" : "/Shared/Projects/'+folderToMove+'"}';
        System.debug(body);
        req.setbody(body);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug(response.getBody());
    }

    @future(callout=true)
    public static void deleteFileOrFolder(String folderOrFilePath) {
        
        String decryptedString = EgnyteGeneral__c.getOrgDefaults().Value__c;
        String endpoint = 'https://cleanfund.egnyte.com/pubapi/v1/fs/Shared/Projects/' + folderOrFilePath;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setHeader('Authorization', 'Bearer '+ decryptedString);
        req.setHeader('content-type', 'application/json');
        req.setMethod('DELETE');
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug(response.getBody());
    }

    @future(callout=true)
    public static void changeFolderNameLead(String startFolderPath, String finishFolderPath){
        
        String decryptedString = EgnyteGeneral__c.getOrgDefaults().Value__c;
        String endpoint = 'https://cleanfund.egnyte.com/pubapi/v1/fs/Shared/Projects/Active/' + startFolderPath;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        System.debug(endpoint);
        req.setHeader('Authorization', 'Bearer '+ decryptedString);
        req.setHeader('content-type', 'application/json');
        req.setMethod('POST');
        String body = '{"action" : "move", "destination" : "/Shared/Projects/Active/'+finishFolderPath+'"}';
        System.debug(body);
        req.setbody(body);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug(response.getBody());
    }

    @future(callout=true)
    public static void changeFolderNameOpp(String startFolderPath, String finishFolderPath){
        
        String decryptedString = EgnyteGeneral__c.getOrgDefaults().Value__c;
        String endpoint = 'https://cleanfund.egnyte.com/pubapi/v1/fs/Shared/Projects/' + startFolderPath;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        System.debug(endpoint);
        req.setHeader('Authorization', 'Bearer '+ decryptedString);
        req.setHeader('content-type', 'application/json');
        req.setMethod('POST');
        String body = '{"action" : "move", "destination" : "/Shared/Projects/'+finishFolderPath+'"}';
        System.debug(body);
        req.setbody(body);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug(response.getBody());
    }

 //   @future(callout=true)
    public static void copyFolderTemplate(String folderToMove){
        
        String decryptedString = EgnyteGeneral__c.getOrgDefaults().Value__c;
        String endpoint = 'https://cleanfund.egnyte.com/pubapi/v1/fs/Shared/Projects/Templates/Folder%20Structure';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        System.debug(endpoint);
        req.setHeader('Authorization', 'Bearer '+ decryptedString);
        req.setHeader('content-type', 'application/json');
        req.setMethod('POST');
        String body = '{"action" : "copy", "destination" : "/Shared/Projects/'+folderToMove+'"}';
        System.debug(body);
        req.setbody(body);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug(response.getBody());
    }

    @future(callout=true)
    public static void uploadFile(String folderPath, Blob body, String title) {
        
        String decryptedString = EgnyteGeneral__c.getOrgDefaults().Value__c;
        HttpRequest req = new HttpRequest(); 
        String endpoint = 'https://cleanfund.egnyte.com/pubapi/v1/fs-content/Shared/Projects/Active/'+folderPath+'/'+title;
        req.setEndpoint(endpoint); 
        req.setHeader('Authorization', 'Bearer '+ decryptedString); 
        req.setHeader('Content-Type', 'application/octet-stream');    
        req.setMethod('POST');
        req.setBodyAsBlob(body);
        Http http=new Http();         
        HttpResponse res=http.send(req); 
        System.debug(res.getBody());
    }


    public static  String navigateToFolder(String folderPath, String inputEmail, String generalPath) {
       /* */
        String decryptedString = EgnyteGeneral__c.getOrgDefaults().Value__c;
        System.debug(decryptedString);
        HttpRequest req = new HttpRequest(); 
        String endpoint = 'https://cleanfund.egnyte.com/pubapi/v2/navigate';
        req.setEndpoint(endpoint); 
        req.setHeader('Authorization', 'Bearer '+ decryptedString);
        req.setHeader('X-Egnyte-Act-As-Email',inputEmail);
        req.setHeader('content-type', 'application/json');
        req.setMethod('POST');
        String body = '{ "embedded": true, "path": "/Shared/'+generalPath+folderPath+'"}';
        req.setBody(body);
        System.debug(req);
        System.debug(req.getBody());
        System.debug(req.toString());
        Http http=new Http();         
        HttpResponse res=http.send(req); 
        System.debug(res.getBody());
        return res.getBody();
    }
    
}