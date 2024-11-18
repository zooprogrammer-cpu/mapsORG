public with sharing class ClientCredsController {

    public static API_Tokens__mdt token = API_Tokens__mdt.getInstance('Box_Service_User');
    public static String clientId = token.Client_Id__c;
    public static String clientSecret = token.Client_Secret__c;

    public String body{set;get;}


    public void authenticate() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        // Endpoint to get the access token -
        req.setEndpoint('https://api.box.com/api/oauth2/token/');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

//            req.setHeader('Accept', 'application/json');
        System.debug('client id 🚗:  ' + clientId );
        System.debug('client secret 🚗:  ' + clientSecret );

        // Prepare the body for the POST request
        String requestBody = 'client_id=' + clientId +
                '&client_secret=' + clientSecret +
                'grant_type=client_credentials'+
                '&box_subject_type=user' +
                '&box_subject_id=34472339676';

        System.debug('request body 🚀: ' + requestBody);
        // Set the body of the request
        req.setBody(requestBody);

        // Send the request -
        HttpResponse response = http.send(req);
        System.debug('response 🚙: ' + response);

        // Strip the body from the response -

        if (response.getStatusCode() == 401) {
            System.debug('Authentication failed. Please check your client ID and client secret.');
        }

        //Deserialize
        fromJSON d = (fromJSON) JSON.deserialize(response.getBody(), fromJSON.class);
        
        // New callout 
        body = fetch_files(d.access_token);
        
    }

    public String fetch_files(String access_token) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://app.box.com/2.0/folders/270198748579/items/');
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + access_token );

        HttpResponse response = http.send(req);
        return response.getBody();

    }

    // Wrapper Class for access token

    public class fromJSON{
        public String access_token;	//
        public Integer expires_in;	//
        public cls_restricted_to[] restricted_to;
        public String refresh_token;	//
        public String token_type;	//bearer


    }

    public class cls_restricted_to {

    }

}