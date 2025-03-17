/**
 * Created by ashbas on 3/16/25.
 */

public with sharing class JWTListViewsController {
    public void getDestOrgListViewDetails(JWT jwt) {
        // 1. Get the assertion
        String assertion = jwt.assertion();
        System.debug('🚀' + assertion);
        // 2. Make a callout and get the access token
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String grantType = 'urn:ietf:params:oauth:grant-type:jwt-bearer';
        String body = 'grant_type=' + EncodingUtil.urlEncode(grantType, 'UTF-8');
        body += '&assertion=' + assertion;
        req.setBody(body);
        HttpResponse response = http.send(req);
        System.debug('🎉' + response.getBody());
        // 3. Use that access token to get list view details
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        String aToken = (String)responseMap.get('access_token');

        getAccountListViews(aToken);

    }

    public void getAccountListViews(String aToken) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('https://ashbaslwc-dev-ed.my.salesforce.com/services/data/v62.0/sobjects/Account/listviews');
        req.setHeader('Authorization', 'Bearer ' + aToken);

        HttpResponse res = http.send(req);

        System.debug('❤️ Listviews response: ' + res.getBody());

    }

}