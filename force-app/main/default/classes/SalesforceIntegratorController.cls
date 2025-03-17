/**
 * Created by ashbas on 3/16/25.
 */

public with sharing class SalesforceIntegratorController {
    public static final String END_POINT = 'https://login.salesforce.com';
    public void startFetchingListViewInfo() {
        // 1. Create variables in JWT and assign values from SalesforceIntegratorController
        // Assign these values to the variables
        // invoke a method in the JWTListViewController
        // from JWTListViewController we will generate the access token and then make the final callout

        Security_Key__mdt securityKey = [SELECT Key__c FROM Security_Key__mdt WHERE DeveloperName = 'Private_Key'];
        JWT jwt = new JWT('RS256');
        jwt.iss = '3MVG9p1Q1BCe9GmAIfusDWVvBU3xb4g00d_Yohg9a41johqGtg8Z2Z_i5nL8rlIbL53znEx2iPbz0ByE9xNob'; // client id from destination org, lwcOrg
        jwt.sub = 'ashbaslwcdev@gmail.com'; // Username of the destination org, lwcOrg
        jwt.aud = END_POINT;
        jwt.exp = '3600';
        jwt.pk = securityKey.Key__c;

        JWTListViewsController listViewDetails = new JWTListViewsController();
        listViewDetails.getDestOrgListViewDetails(jwt);



    }

}