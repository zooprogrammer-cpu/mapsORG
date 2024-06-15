public with sharing class BoxAuthControllerPKCE {
    public static API_Tokens__mdt token = API_Tokens__mdt.getInstance('Box');
    public static String clientId = token.Client_Id__c;
    public static String clientSecret = token.Client_Secret__c;

    public PageReference authenticate() {
        String endPoint = 'https://account.box.com/api/oauth2/authorize/?client_id='+clientId+'&response_type=code&code_challenge_method=S256&code_challenge=';

        // Step 1: Create code verifier (43-128 characters)
        String codeVerifier = '234234jhjkhsdjfhksjdhfTTTdjfskldjfksdjflsdkfkdsjflskdjfkdfjlskdlfksjdlfksjdlfkjsldkjflskdjflskjdlkfjsdlkTTegeg';
        // Step 2: Encrypt the code verifier
        Blob codeVerifierBlob = Blob.valueOf(codeVerifier);
        Blob cryptoDigest = Crypto.generateDigest('SHA3-256',codeVerifierBlob);
        // Step 3: Encode the code verifier
        String afterCryptoDigest = EncodingUtil.base64Encode(cryptoDigest);
        // add the encoded code verifier to the endPoint
        endPoint = endPoint + afterCryptoDigest;
        // Need to use PageReference to redirect to Box.com url to enter username and password
        return new PageReference(endPoint);


    }


}