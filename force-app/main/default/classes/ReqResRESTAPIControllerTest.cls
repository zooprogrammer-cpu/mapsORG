/**
 * 
 */
@IsTest
public with sharing class ReqResRESTAPIControllerTest {
    @IsTest
    public static void processRequestTest() {
        Test.setMock(HttpCalloutMock.class, new MockHttpReqResGenerator());

        ReqResRESTAPIController reqres = new ReqResRESTAPIController();
        HttpResponse res = reqres.processRequest();

        System.assert(res.getStatusCode() == 200, 'Response is not 200, please check');
        System.assert(res.getHeader('Content-Type') == 'application/json', 'Response is not application/json, please check');


    }
}