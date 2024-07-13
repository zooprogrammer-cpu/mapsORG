@RestResource(UrlMapping='/api/invokeZoomWebhook/*')
global with sharing class ZoomWebHookHandler {
    @HttpPost
    global static void registerWebhook() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String ZOOM_WEBHOOK_SECRET_TOKEN = 'c09GuCB-RfWYI8M92ajsmQ';

        // Get request body
        String requestBody = req.requestBody.toString();

        // Parse JSON
        Map<String, Object> requestMap = (Map<String, Object>) JSON.deserializeUntyped(requestBody);

        // Check for endpoint.url_validation event
        if (requestMap.get('event') == 'endpoint.url_validation') {
            Map<String, Object> payload = (Map<String, Object>) requestMap.get('payload');
            String plainToken = (String) payload.get('plainToken');

            // Create HMAC SHA-256 hash
            Blob mac = Crypto.generateMac('HmacSHA256', Blob.valueOf(plainToken), Blob.valueOf(ZOOM_WEBHOOK_SECRET_TOKEN));
            String encryptedToken = EncodingUtil.convertToHex(mac);

            // Prepare response
            Map<String, String> responseMap = new Map<String, String>{
                    'plainToken' => plainToken,
                    'encryptedToken' => encryptedToken
            };
            String jsonResponse = JSON.serialize(responseMap);

            // Set response
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(jsonResponse);
        } else {
            // Handle other events as necessary
            res.statusCode = 200;
        }
    }
}