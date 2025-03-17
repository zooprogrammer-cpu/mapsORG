/**
 * Created by ashbas on 3/16/25.
 */

public with sharing class JWT {
    public String alg {set; get;}
    public String iss {set; get;}
    public String sub {set; get;}
    public String aud {set; get;}
    public String exp {set; get;}
    public String iat {set; get;}
    public String pk {set; get;}
    public Integer validFor {set; get;}

    public JWT(String algo) {
        this.alg = algo;
        this.validFor = 3600;
    }

    public String assertion() {
        // 1. Create JSON
        String jwt = '';

        JSONGenerator header = JSON.createGenerator(false);
        header.writeStartObject();
        header.writeStringField('alg', this.alg);
        header.writeEndObject();
        String encodedHeader = base64URLEncode(Blob.valueOf(header.getAsString())); // Convert header to Blob and pass to the encoder

        // 2. base64URLencode the JSON
        JSONGenerator body = JSON.createGenerator(false);
        body.writeStartObject();
        body.writeStringField('iss', this.iss);
        body.writeStringField('sub', this.sub);
        body.writeStringField('aud', this.aud);

        Long rightNow = (Datetime.now().getTime()/1000) + 1 ; // take current datetime and strip time; convert that to milliseconds

        body.writeNumberField('iat', rightNow);
        body.writeNumberField('exp', rightNow + validFor);
        body.writeEndObject();
        jwt = encodedHeader + '.' + base64URLEncode(Blob.valueOf(body.getAsString()));

        // 3. Sign it using the private key
        Blob privateKey = EncodingUtil.base64Decode(pk);
        Blob signature = Crypto.sign('rsa-sha256', Blob.valueOf(jwt), privateKey);

        jwt += '.' + base64URLEncode(signature);

        return jwt;
    }

    public String base64URLEncode(Blob input) {
        String output = EncodingUtil.base64Encode(input);

        // 1. replace + with -
        output = output.replace('+', '-');
        // 2. replace / with _
        output = output.replace('/', '_');
        // 3. remove any trailing = symbols if exists
        while(output.endsWith('=')) {
            output = output.substring(0, output.length() - 1);
        }
        return output;
    }


}