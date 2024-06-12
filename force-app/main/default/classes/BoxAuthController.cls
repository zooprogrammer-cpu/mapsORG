
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
        body = response.getBody();
        // Step 3 - Receive the Response

    }

}