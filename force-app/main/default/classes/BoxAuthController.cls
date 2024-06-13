public with sharing class BoxAuthController {
    public static String body {get; set;}

    public static API_Tokens__mdt token = API_Tokens__mdt.getInstance('Box');
    public static String clientId = token.Client_Id__c;
    public static String clientSecret = token.Client_Secret__c;

    // Need to use PageReference to redirect to Box.com url to enter username and password
    public PageReference authenticate() {
        String boxAuthUrl = 'https://account.box.com/api/oauth2/authorize?response_type=code&client_id='+clientId;
        return new PageReference(boxAuthUrl);

    }

    public static void getAccessToken() {
        String authCode = ApexPages.currentPage().getParameters().get('code');
        System.debug('Auth code:🙌' + authCode);
        // Step 1 - Instantiate the HTTP Request
        Http http = new Http();

        // Step 2 - Frame the HTTP Request
        HttpRequest req = new HttpRequest();
        String endpoint =  'https://api.box.com/oauth2/token/';   // Request token endpoint from Box.com
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Accept', 'application/json'); // request is going to send is only going to accept the response in format of JSON
        req.setBody('grant_type=authorization_code&code='+ authCode + '&client_id='+ clientId + '&client_secret='+ clientSecret);
        HttpResponse response = http.send(req);

        // Step 3 - Receive the Response for access_toke and refresh_token
        fromJSON d = (fromJSON) JSON.deserialize(response.getBody(), fromJSON.class);
        // Finally Make a new callout to get the list of items in the folder
        body = getFolders(d.access_token); // pass the access token to getFolders method

    }

    public static String getFolders(String access_token) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.box.com/2.0/folders/269617849874/items');
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + access_token);

        //send the request and handle the response
        HttpResponse resp = http.send(req);
        return resp.getBody();

    }

    //
    // Inner Class

    public class fromJSON{
        public String access_token;	//pUTWslEhkeYemX657k3VoYta4tdIMaDS
        public Integer expires_in;	//3723
        public cls_restricted_to[] restricted_to;
        public String refresh_token;	//E0zTL7y9kv0V7poNWg6vP3Xj3AqGhgROWcgL98zRN0fKAneYNtVutUKi2ZM4dPAj
        public String token_type;	//bearer


    }

    public class cls_restricted_to {

    }

}