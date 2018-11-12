global class EgnyteHttpCalloutImpl implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HTTPResponse resp = new HTTPResponse();
        resp.setBody('{"redirect" : "true", "access_token" : "true"}');
        return new HTTPResponse();
    }
}