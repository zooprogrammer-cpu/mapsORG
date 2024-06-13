public with sharing class BoxAuthController {
    public static String body {get; set;}

    public List<SuperItemList> dataList {get;set;} // dataList is going to hold collection of SuperItemList instances

    public static API_Tokens__mdt token = API_Tokens__mdt.getInstance('Box');
    public static String clientId = token.Client_Id__c;
    public static String clientSecret = token.Client_Secret__c;

    // Need to use PageReference to redirect to Box.com url to enter username and password
    public PageReference authenticate() {
        String boxAuthUrl = 'https://account.box.com/api/oauth2/authorize?response_type=code&client_id='+clientId;
        return new PageReference(boxAuthUrl);

    }

    public void getAccessToken() {
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

        // Deserialize the body which is the JSON file list
        dataList = new SuperItemList[]{};
        parseFolderContent p = (parseFolderContent) JSON.deserialize(body, parseFolderContent.class);
        // push the file infos to the constructor if SuperItemList
        for (Integer i = 0; i <p.entries.size() ; i++){
            dataList.add(new SuperItemList(p.entries[i].type, p.entries[i].id, p.entries[i].name));
        }

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
    //
    // Wrapper Class for Folder content
    //

    public class parseFolderContent{
        public Integer total_count;	//2
        public cls_entries[] entries;
        public Integer offset;	//0
        public Integer limit_x;	//100
        public cls_order[] order;
    }

    class cls_entries {
        public String type;	//file
        public String id;	//1558544351957
        public cls_file_version file_version;
        public String sequence_id;	//0
        public String etag;	//0
        public String sha1;	//476d415c523a740801f00c28c1c060154233448c
        public String name;	//Salesforce Days_ Enablement Sessions.pdf
    }
    class cls_file_version {
        public String type;	//file_version
        public String id;	//1712489371157
        public String sha1;	//476d415c523a740801f00c28c1c060154233448c
    }
    class cls_order {
        public String by_x;	//type
        public String direction;	//ASC
    }

    // Wrapper class to use in Visual Force UI
    public class SuperItemList {
        //local variables
        public String type{get;set;}
        public String id{get;set;}
        public String name{get;set;}

        SuperItemList(String type_x, String id_x, String name_x) {
            this.type = type_x; // assign the type passed in SuperItemList Constructor to the local variables in public String type
            this.id = id_x;
            this.name = name_x;
        }

    }

}