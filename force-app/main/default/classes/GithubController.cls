/**
 * 
 */

public with sharing class GithubController {

    public String body{get;set;}

    public GithubController() {
        Http http = new Http();

        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:GitHubRepos');
        request.setMethod('GET');

        HttpResponse response = http.send(request);
        body = response.getBody();

        System.debug('📡 body:' + body);

    }


}