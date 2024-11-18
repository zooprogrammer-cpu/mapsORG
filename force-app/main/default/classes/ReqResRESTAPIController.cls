/**
 *
 */

public with sharing class ReqResRESTAPIController {
    public  static String body {get; set;}
    public static List<Friend> friends {get; set;}

    public  HttpResponse processRequest() {
        //1. instantiate the HTTP Class - HTTP
        Http http = new Http();

        //2. Frame the request - HTTP Request
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://reqres.in/api/users?page=2');
        req.setMethod('GET');

        //3. Send the request and handle the response - HTTPResponse
        HttpResponse response = http.send(req);
        body = response.getBody();

        fromJSON d = (fromJSON) JSON.deserialize(body, fromJSON.class);
//        System.debug(d);
//        System.debug(d.data);
        friends = new List<Friend>();
        for ( cls_data data : d.data) {
            friends.add(new Friend(data.first_name, data.last_name, data.avatar, data.email));
        }

        System.debug(friends);

        return response; 

    }


    public class fromJSON{
        public Integer page;	//2
        public Integer per_page;	//6
        public Integer total;	//12
        public Integer total_pages;	//2
        public cls_data[] data;
        public cls_support support;
    }

    class cls_data {
        public Integer id;	//7
        public String email;	//michael.lawson@reqres.in
        public String first_name;	//Michael
        public String last_name;	//Lawson
        public String avatar;	//https://reqres.in/img/faces/7-image.jpg
    }
    class cls_support {
        public String url;	//https://reqres.in/#support-heading
        public String text;	//To keep ReqRes free, contributions towards server costs are appreciated!
    }

    public  class Friend {
        public String firstName;
        public String lastName;
        public String avatar;
        public String email;

        public  Friend(String firstName, String lastName, String avatar, String email ) {
            this.firstName = firstName;
            this.lastName = lastName;
            this.avatar = avatar;
            this.email = email;
        }
    }

}