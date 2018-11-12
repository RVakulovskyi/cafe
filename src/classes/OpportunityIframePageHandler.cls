public class OpportunityIframePageHandler {
    public  Opportunity oppToView{get;set;}
    public String urlIFrame{get;set;}
    public String loginStr{get;set;}
    public String passwordStr{get;set;}
    public String authToken{get;set;}
    public Boolean iframeRenderer{get;set;}
    
    public OpportunityIframePageHandler(ApexPages.StandardController stdController) {
        iframeRenderer = true;
        stdController.addFields(new List<String>{'StageName', 'Name', 'Id'});
        this.oppToView = (Opportunity)stdController.getRecord();
    }
    
    public void formEgnyteRequest() {   
        String endpoint = 'https://cleanfund.egnyte.com/puboauth/token';
        String body='client_id=bx2w8aanyr8f8rsk29kkmvvm&username='+loginStr+'&password='+passwordStr+'&grant_type=password&scope=Egnyte.filesystem%20Egnyte.launchwebsession';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setBody(body);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        Map<String, Object> authCodeMap = (Map<String, Object>)Json.deserializeUntyped(response.getBody());
        System.debug(authCodeMap);
        authToken = String.valueOf(authCodeMap.get('access_token'));
        System.debug(authToken);
        urlIFrame = navigateToFolder(formFolderString(oppToView));
    }
    
    public String navigateToFolder(String folderPath) {
        HttpRequest req = new HttpRequest(); 
        String endpoint = 'https://cleanfund.egnyte.com/pubapi/v2/navigate';
        req.setEndpoint(endpoint); 
        req.setHeader('Authorization', 'Bearer '+ authToken);
        req.setHeader('content-type', 'application/json');
        req.setMethod('POST');
        String body = '{ "embedded": true, "path": "/Shared/Projects/'+folderPath+'"}';
        req.setBody(body);
        System.debug(req);
        System.debug(req.getBody());
        System.debug(req.toString());
        Http http=new Http();         
        HttpResponse res=http.send(req); 
        String redirectUrl = '';
        Map<String, Object> urlToReturnMap = (Map<String, Object>)Json.deserializeUntyped(res.getBody());
        if(!urlToReturnMap.containsKey('redirect')) {
            redirectUrl = 'false';
            iframeRenderer = false;
         } else {
            iframeRenderer = true;
            redirectUrl = String.valueOf(urlToReturnMap.get('redirect'));
        }
        return (String)urlToReturnMap.get('redirect');
    }
    
    private String formFolderString(Opportunity inputOpp) {
        String pathToReturn = '';
        Map<String, String> mapOfAvailableStages = new Map<String, String>{'Dead'=>'Dead-Lost','Dormant'=>'Dormant','Closed'=>'Closed'};
        if(mapOfAvailableStages.containsKey(inputOpp.StageName)) {
            pathToReturn+=mapOfAvailableStages.get(inputOpp.StageName)+'/'+inputOpp.Name;
        } else {
            pathToReturn+='Active/'+inputOpp.Name;
        }
        return pathToReturn;
    }
}