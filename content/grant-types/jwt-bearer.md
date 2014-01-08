# JWT Bearer

## Overview

The `JWT Bearer` grant type is used when the client wants to
receive access tokens without transmitting sensitive information
such as the client secret. This can also be used with trusted
clients to gain access to user resources without user authorization.

[Read more about jwt bearer](http://tools.ietf.org/html/draft-ietf-oauth-jwt-bearer-07#section-1)

## Use Cases

  * same benefits as the Client Credentials grant type
  * allows for secure calls to be made without transmitting credentials
  * for trusted clients, allows access of user resources without authorization

## Implementation

Create an instance of `OAuth2\GrantType\JwtBearer` and add it to
your server:

```php
// load public key from keystore
$public_key = file_get_contents('id_rsa.pub');

// assign the public key to a client and user
$clientKeys = array('TestClient' => array('User1' => $public_key));

// create a storage object
$storage = new OAuth2\Storage\Memory(array('jwt' => $clientKeys));

// specify your audience (typically, the URI of the oauth server)
$audience = 'https://api.mysite.com';

// create the grant type
$grantType = new OAuth2\GrantType\JwtBearer($storage, $audience);

// add the grant type to your OAuth server
$server->addGrantType($grantType);
```

## Example Request

JWT requests require the signing of the JWT assertion using
[public key cryptography](http://en.wikipedia.org/wiki/Public-key_cryptography).
The code snippet below provides an example of how this might be done.

```php
/**
 * Generate a JWT
 *
 * @param $privateKey The private key to use to sign the token
 * @param $iss The issuer, usually the client_id
 * @param $sub The subject, usually a user_id
 * @param $aud The audience, usually the URI for the oauth server
 * @param $exp The expiration date. If the current time is greater than the exp, the JWT is invalid
 * @param $nbf The "not before" time. If the current time is less than the nbf, the JWT is invalid
 * @param $jti The "jwt token identifier", or nonce for this JWT
 *
 * @return string
 */
function generateJWT($privateKey, $iss, $sub, $aud, $exp = null, $nbf = null, $jti = null)
{
    if (!$exp) {
        $exp = time() + 1000;
    }

    $params = array(
        'iss' => $iss,
        'sub' => $sub,
        'aud' => $aud,
        'exp' => $exp,
        'iat' => time(),
    );

    if ($nbf) {
        $params['nbf'] = $nbf;
    }

    if ($jti) {
        $params['jti'] = $jti;
    }

    $jwtUtil = new OAuth2\Encryption\Jwt();

    return $jwtUtil->encode($params, $privateKey, 'RS256');
}
```

> Note: This example uses the `OAuth2\Encryption\Jwt` class provided in this library. This is
> not necessary for JWT authentication, but it is convenient.

This function can then be called to generate the payload for the request. Write a script to
generate the jwt and request a token:

```php
$private_key = file_get_contents('id_rsa');
$client_id   = 'TestClient';
$user_id     = 'User1';
$grant_type  = 'urn:ietf:params:oauth:grant-type:jwt-bearer';

$jwt = generateJWT($private_key, $client_id, $user_id, 'https://api.mysite.com');

passthru("curl https://api.mysite.com/token -d 'grant_type=$grant_type&assertion=$jwt'");
```

A successful token request will return a standard access token in JSON format:

```json
{"access_token":"03807cb390319329bdf6c777d4dfae9c0d3b3c35","expires_in":3600,"token_type":"bearer","scope":null}
```
