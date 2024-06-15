/**
 * 
 */

public with sharing class ImplicitFlowController {

    public PageReference authenticate() {
        String endPoint = 'https://login.salesforce.com/services/oauth2/authorize?response_type=token&client_id=3MVG9kBt168mda_.IbQKEBB2XQUsUFBztgel7_P0bXH2WTb_sWe.ZAxRtbdP9iAjLqgxRmp0FMm2Ot0ynJlSG&scope=full&redirect_uri=https://ashconsulting2-dev-ed--c.develop.vf.force.com/apex/ImplicitFlowSFDCSuccess';
        // PagerReference returns the user back to Org1.
        return new PageReference(endPoint);
    }

}