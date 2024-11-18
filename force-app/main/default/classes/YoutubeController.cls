/**
 * 
 */

public with sharing class YoutubeController {
    public String body {get; set;}
    public String searchQuery {get;set;}
    // ex: public Account[] accountList{get;set;} // [a1, a2, a3] //accountList is going to hold a collection of accounts instances
    public List<SuperItemList> dataList {get;set;} // dataList is going to hold collection of SuperItemList instances

    public void search() {

        // business logic
        dataList = new List<SuperItemList>();
        String sanitizedQuery = searchQuery.replaceAll(' ', '+' );
        // String apiKey = API_TokenController.API_KEY;

        API_Tokens__mdt token = API_Tokens__mdt.getInstance('YouTube_Token');
        String apiKey = token.Key__c;

        String endPoint = 'callout:YouTube?part=snippet&q='+ sanitizedQuery + '&key='+ apiKey;

        // Step 1: Instantiate HTTP Class
        Http http = new Http();

        // Step 2: Instantiate HTTP Request Class and frame the request
        HttpRequest request = new HttpRequest();
        request.setHeader('Accept', 'application/json');
        request.setEndpoint(endPoint);
        request.setMethod('GET'); // frame the request

        // Step 3: Send the request and handle the response
        HttpResponse response = http.send(request);
        // from the response, strip the body
        body = response.getBody();
        System.debug('body:' + body);

        // Deserialize-
        fromJSON d = (fromJSON) JSON.deserialize(body,fromJSON.class); // can instantiate the fromJSON class by typing .class. Need to typeCast as fromJSON
        System.debug('🚀 deserialized' + d);
        // can use deserialized.kind, etc. after this
        System.debug('🚀' + d.kind);
        System.debug('🚀' + d.etag);
        System.debug('🚀' + d.items[2].id.kind);
        System.debug('🚀' + d.items[2].id.videoId);


        //Loop over the 5 search results and push into the wrapper object variable, dataList
        for ( Integer i = 0; i < d.items.size() ; i++) {
            dataList.add(new SuperItemList(d.items[i].snippet.title, d.items[i].snippet.description,d.items[i].snippet.thumbnails.medium.url, d.items[i].snippet.publishTime));
        }

        System.debug('dataList' + dataList);

    }

    public class fromJSON{
        public String kind;	//youtube#searchListResponse
        public String etag;	//JGEWWwCg7228Q1MgpAfS6RRNDq0
        public String nextPageToken;	//CAUQAA
        public String regionCode;	//US
        public cls_pageInfo pageInfo;
        public cls_items[] items;
    }

    class cls_pageInfo {
        public Integer totalResults;	//1000000
        public Integer resultsPerPage;	//5
    }
    class cls_items {
        public String kind;	//youtube#searchResult
        public String etag;	//XNV53oTOCM_4fR1cMC_xE3DPEsA
        public cls_id id;
        public cls_snippet snippet;
    }
    class cls_id {
        public String kind;	//youtube#channel
        public String channelId;	//UCUpquzY878NEaZm5bc7m2sQ
        public String videoId;
    }
    class cls_snippet {
        public String publishedAt;	//2006-08-03T21:52:39Z
        public String channelId;	//UCUpquzY878NEaZm5bc7m2sQ
        public String title;	//Salesforce
        public String description;	//Salesforce is the #1 AI CRM, helping companies connect with customers in a whole new way since 1999. Our product portfolio ...
        public cls_thumbnails thumbnails;
        public String channelTitle;	//Salesforce
        public String liveBroadcastContent;	//none
        public String publishTime;	//2006-08-03T21:52:39Z
    }
    class cls_thumbnails {
        public cls_default default_x;
        public cls_medium medium;
        public cls_high high;
    }
    class cls_default {
        public String url;	//https://yt3.ggpht.com/ZIPvInnj50dYnGYvkanm_IYcoYaofSY47e_4iah-EoCduSdhxYOC_-TCatm9XR3HAp1HJeomAa0=s88-c-k-c0xffffffff-no-rj-mo
    }
    class cls_medium {
        public String url;	//https://yt3.ggpht.com/ZIPvInnj50dYnGYvkanm_IYcoYaofSY47e_4iah-EoCduSdhxYOC_-TCatm9XR3HAp1HJeomAa0=s240-c-k-c0xffffffff-no-rj-mo
    }
    class cls_high {
        public String url;	//https://yt3.ggpht.com/ZIPvInnj50dYnGYvkanm_IYcoYaofSY47e_4iah-EoCduSdhxYOC_-TCatm9XR3HAp1HJeomAa0=s800-c-k-c0xffffffff-no-rj-mo
    }
    public static fromJSON parse(String json){
        return (fromJSON) System.JSON.deserialize(json, fromJSON.class);
    }

    // Wrapper Class
    public class SuperItemList {
        public String title {get; set;}
        public String description {get; set;}
        public String url {get;set;}
        public String publishTime {get;set;}

        //constructor to push the deserialized values into the constructor and assign the values to the variables above
        public SuperItemList(String title, String description, String url, String publishTime){
            this.title = title; //push the title from constructor params to title in the public String title {get; set;}
            this.description = description;
            this.url = url;
            this.publishTime = publishTime;

        }
    }

}