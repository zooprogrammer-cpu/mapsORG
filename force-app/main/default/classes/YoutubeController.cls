/**
 * 
 */

public with sharing class YoutubeController {
    public String body {get; set;}

    public void search() {

        // business logic
        String endPoint = 'https://youtube.googleapis.com/youtube/v3/search?part=snippet&q=salesforce&key=AIzaSyBvMLx4V0JY6YDeUYUGJ8snHZ1LsRMBzCs';

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

        // Deserialize-
        fromJSON deserialized = (fromJSON) JSON.deserialize(body,fromJSON.class); // can instantiate the fromJSON class by typing .class. Need to typeCast as fromJSON
        // can use deserialized.kind, etc. after this
        System.debug('🚀' + deserialized.etag);
        System.debug('🚀' + deserialized.items[0].id);



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

}