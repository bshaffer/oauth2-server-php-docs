# Crypto Tokens

## Overview

Crypto tokens provide a way to create and validate access tokens without requiring a central
storage such as a database. This *decreases the latency* of the OAuth2 service when validating
Access Tokens.

Crypto Tokens use [Public Key Cryptography](http://en.wikipedia.org/wiki/Public-key_cryptography)
to establish their validity.  The OAuth2.0 Server signs the tokens using a `private key`, and other
parties can verify the token using the Server's `public key`.

## Token Payload

The following fields can be extracted from the token:

* `id` - the internal id of the token
* `token_type` - the kind of token (bearer)
* `expires` - number of *seconds* until the token expires
* `user_id` - the id of the user for which the token was released
* `client_id` - the id of the client who requested the token
* `scope` - comma separated list, the list of scopes for which the token was issued

## Details

The OAuth2 Server will use a public/private key based algorithm. Details of this method can be found in the spec
for [JSON Web Signatures](http://tools.ietf.org/html/draft-jones-json-web-signature-04) ([Chapter 6.2](http://tools.ietf.org/html/draft-jones-json-web-signature-04#section-6.2))

With the OAuth2 Server's `public key`, Resource Servers will have the ability to verify the authenticity of the crypto token.

## Format

A crypto token has the following format:

```bash
HEADER.PAYLOAD.SIGNATURE
```

The `HEADER` is a Base64 URL Safe encoding of the following JSON:

```json
{"typ": "JWT", "alg":"RS256"}
```

The `PAYLOAD` is a Base64 URL Safe encoding of a json object with the following fields:

```json
{
    "id":"b08e1069f585ccc124ec1e694b2a609f1153caf8",
    "token_type":"bearer",
    "expires":"1379982305",
    "user_id":"THE_USER_ID",
    "client_id":"THE_CLIENT_ID",
    "scope": "onescope,twoscope"
}
```

## Verification

The signature can be verified in any language using standard `Public Key` encryption methods:

```php
/**
 * @requires PHP 5.4.8+
 *
 * @throws Exception on failure
 *
 * @param string $access_token       the Crypto Token from an OAuth2 Server
 * @param string $public_key         the public key
 *
 * @return array
 */
function decodeAccessToken($access_token, $public_key)
{
    $separator = '.';

    if (2 !== substr_count($access_token, $separator)) {
        throw new Exception("Incorrect access token format");
    }

    list($header, $payload, $signature) = explode($separator, $access_token);

    $decoded_signature = base64_decode($signature);

    // The header and payload are signed together
    $payload_to_verify = utf8_decode($header . $separator . $payload);

    // see http://www.php.net/manual/en/function.openssl-verify.php
    $verified = openssl_verify($payload_to_verify, $decoded_signature, $public_key, OPENSSL_ALGO_SHA256);

    if ($verified !== 1) {
        throw new Exception("Cannot verify signature");
    }

    return json_decode(base64_decode($payload));
}
```
