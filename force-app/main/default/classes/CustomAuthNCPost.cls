/**
 * Created by ashbas on 8/9/25.
 */

public with sharing class CustomAuthNCPost {
    public static void callPublicAPI() {
        HttpRequest req = new HttpRequest();
//        String body = '{"x-body-key" : "bodykeyforadmin"}';
        String body = '{"x-body=key" : "{!$Credential.CustomAuthEC.bodykey}"}';
        req.setEndpoint('callout:CustomAuthNC/my-api');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(body);
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