/**
 * 
 */

public with sharing class UsernamePasswordFlowController {
    public String body{get;set;}

    public void getAuthenticated() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        // Endpoint to get the access token from-
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        req.setMethod('POST');
        String userName ='XXXXXXX';
        String passWord = 'XXXXXXX';
        String clientId = 'XXXXXXX';
        String clientSecret ='XXXXXXXX';
        req.setBody('grant_type=password&username='+userName+'&password='+passWord+'&client_id='+clientId+'&client_secret='+clientSecret);


        HttpResponse response = http.send(req);
        body = response.getBody();
    }

}