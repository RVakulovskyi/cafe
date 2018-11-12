global class IntegrationServiceMock implements HttpCalloutMock {
    private String leadId{get;set;}
    public IntegrationServiceMock(String leadId) {
        this.leadId = leadId;
    }
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"leadId":"'+leadId+'"}');
        res.setStatusCode(200);
        return res;
    }
}