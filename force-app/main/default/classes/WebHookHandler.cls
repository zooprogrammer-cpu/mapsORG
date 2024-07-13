/**
 * 
 */
@RestResource(UrlMapping='/api/invokeWebhook/*')
global with sharing class WebHookHandler {
    @HttpPost
    global static void handlePost() {
        RestRequest requestContext = RestContext.request;
        RestResponse responseContext = RestContext.response;
        System.debug('##Post');
        Account acc = new Account(Name = 'Webhook Account Test');
        insert acc;

    }
    
}