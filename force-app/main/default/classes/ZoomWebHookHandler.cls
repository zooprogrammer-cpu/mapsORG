@RestResource(UrlMapping='/api/invokeZoomWebhook/*')
global with sharing class ZoomWebHookHandler {
    @HttpPost
    global static void registerWebhook() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String ZOOM_WEBHOOK_SECRET_TOKEN = 'zpakVJ2pR8eNvBb1gKVeQQ';

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
            // Handle other events
            System.debug('Other events');
            handleZoomEvent(requestMap);
            res.statusCode = 200;
        }
    }

    private static void handleZoomEvent(Map<String, Object> requestMap) {
        String eventType = (String) requestMap.get('event');
        System.debug('Event Type: ' + eventType);
        Map<String, Object> payload = (Map<String, Object>) requestMap.get('payload');

        if (eventType.startsWith('meeting.')) {
            handleMeetingEvent(eventType, payload);
        }
        // Add more event types here as needed
    }

    private static void handleMeetingEvent(String eventType, Map<String, Object> payload) {
        Map<String, Object> meetingObject = (Map<String, Object>) payload.get('object');
        String meetingId = (String) meetingObject.get('id');
        String meetingTopic = (String) meetingObject.get('topic');
        String startTime = (String) meetingObject.get('start_time');

        // Process the meeting data as needed
        // For example, you could log it or create a record in Salesforce
        System.debug('Meeting ID: ' + meetingId);
        System.debug('Meeting Topic: ' + meetingTopic);
        System.debug('Start Time: ' + startTime);

        // Example: Create a custom object record to store meeting details
        ZoomData__c meetingRecord = new ZoomData__c();
        meetingRecord.ZoomId__c = meetingId;
//        meetingRecord.Topic__c = meetingTopic;
//        meetingRecord.Start_Time__c = DateTime.valueOf(startTime);
        insert meetingRecord;
    }


}