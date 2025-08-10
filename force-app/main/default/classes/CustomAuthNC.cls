/**
 * Created by ashbas on 8/9/25.
 */

public with sharing class CustomAuthNC {

//    public static void callPublicAPI() {
//        HttpRequest req = new HttpRequest();
//        req.setEndpoint('https://2df6de339c6b.ngrok-free.app/my-api');
//        req.setMethod('GET');
//        req.setHeader('Content-Type', 'application/json');
//        req.setHeader('x-api-key', 'sfdc2nodejs');
//        Http http = new Http();
//        try {
//            HttpResponse res = http.send(req);
//            System.debug('Status Code: ' + res.getStatusCode());
//            System.debug('Response Body: ' + res.getBody());
//        } catch (Exception e) {
//            System.debug('Callout error: ' + e.getMessage());
//        }
//    }
    public static void callPublicAPI() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:CustomAuthNC/my-api');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
//        req.setHeader('x-api-key', 'sfdc2nodejs');
        Http http = new Http();
        try {
            HttpResponse res = http.send(req);
            System.debug('Status Code: ' + res.getStatusCode());
            System.debug('Response Body: ' + res.getBody());
        } catch (Exception e) {
            System.debug('Callout error: ' + e.getMessage());
        }
    }

}