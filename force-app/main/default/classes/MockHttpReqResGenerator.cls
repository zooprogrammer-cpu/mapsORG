/**
 * 
 */
@IsTest
public with sharing class MockHttpReqResGenerator implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest request) {

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"page":2,"per_page":6,"total":12,"total_pages":2,"data":[{"id":7,"email":"michael.lawson@reqres.in","first_name":"Michael","last_name":"Lawson","avatar":"https://reqres.in/img/faces/7-image.jpg"}],"support":{"url":"https://reqres.in/#support-heading","text":"To keep ReqRes free, contributions towards server costs are appreciated!"}}');
        res.setStatusCode(200);

        return res;
    }
}