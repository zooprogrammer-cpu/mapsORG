@RestResource(UrlMapping='/Account/contacts/*')
global class ExploreRestAccountController {
    //https://instance.salesforce.com/services/apexrest/Account/contacts/001xxxxx

    // When a callout is made to the endpoint above, if the method is GET, invoke this method
    @HttpGet
    global static Account doGet() {
        // In order to get the Id that the request is going to have from external platform,
        // let's use RestContext class. req is the actual request sent by nodeJs or PHP.
        // We are trying to grab the request. It will have headers, content type and everything else.
        RestRequest req = RestContext.request;
        // get the accId send in the request.
        String accId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        return [SELECT Id, Name, (SELECT Id, Name FROM Contacts) FROM Account WHERE Id =: accId];
    }

    // When a callout is made to the endpoint above, if the method is POST, invoke this method
    @HttpPost
    global static Account doPost() {
        return null;
    }


}