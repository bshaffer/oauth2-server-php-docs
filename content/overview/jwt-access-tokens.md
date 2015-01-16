---
title: JWT Access Tokens | OAuth2 Server PHP
---

# JWT Access Tokens

## Overview

JWT Access Tokens provide a way to create and validate access tokens without requiring a central
storage such as a database. This *decreases the latency* of the OAuth2 service when validating
Access Tokens.

JWT Access Tokens use [JSON Web Signatures](http://tools.ietf.org/html/draft-jones-json-web-signature-04)
([Chapter 6.2](http://tools.ietf.org/html/draft-jones-json-web-signature-04#section-6.2)) and
[Public Key Cryptography](http://en.wikipedia.org/wiki/Public-key_cryptography)
to establish their validity.  The OAuth2.0 Server signs the tokens using a `private key`, and other
parties can verify the token using the Server's `public key`.

## Format

A JWT Access Token has the following format:

```text
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

* `id` - the internal id of the token
* `token_type` - the kind of token (bearer)
* `expires` - UNIX timestamp when the token expires
* `user_id` - the id of the user for which the token was released
* `client_id` - the id of the client who requested the token
* `scope` - comma separated list of scopes for which the token is issued

## Using JWT Access Tokens With This Library

### Creating a Public and Private Key Pair

To get started, you'll need a public/private key pair.  These can be generated
on any Unix-based operating system with the following commands:

```text
# private key
openssl genrsa -out privkey.pem 2048

# public key
openssl rsa -in privkey.pem -pubout -out pubkey.pem
```

### Basic Usage

The easiest way to configure your server is to supply the `use_jwt_access_tokens`
option to your OAuth Server's configuration:

```php
$server = new OAuth2\Server($storage, array(
    'use_jwt_access_tokens' => true,
));
```

This will require you to create a `PublicKey` storage object. You can use the
built in `Memory` storage for this:

```php
// your public key strings can be passed in however you like
$publicKey  = file_get_contents('/path/to/pubkey.pem');
$privateKey = file_get_contents('/path/to/privkey.pem');

// create storage
$storage = new OAuth2\Storage\Memory(array('keys' => array(
    'public_key'  => $publicKey,
    'private_key' => $privateKey,
)));

$server = new OAuth2\Server($storage, array(
    'use_jwt_access_tokens' => true,
));
```

This is the minimal configuration when using JWT Access Tokens, and will be valid
for the `ResourceController` only. For a full server configuration, you must supply
a `Client` storage and some Grant Types.

Here is an example of a full server configuration:
```php
// token.php

// error reporting (this is a demo, after all!)
ini_set('display_errors',1);error_reporting(E_ALL);

// Autoloading (composer is preferred, but for this example let's just do this)
require_once('oauth2-server-php/src/OAuth2/Autoloader.php');
OAuth2\Autoloader::register();

// your public key strings can be passed in however you like
// (there is a public/private key pair for testing already in the oauth library)
$publicKey  = file_get_contents('oauth2-server-php/test/config/keys/id_rsa.pub');
$privateKey = file_get_contents('oauth2-server-php/test/config/keys/id_rsa');

// create storage
$storage = new OAuth2\Storage\Memory(array(
    'keys' => array(
        'public_key'  => $publicKey,
        'private_key' => $privateKey,
    ),
    // add a Client ID for testing
    'client_credentials' => array(
        'CLIENT_ID' => array('client_secret' => 'CLIENT_SECRET')
    ),
));

$server = new OAuth2\Server($storage, array(
    'use_jwt_access_tokens' => true,
));
$server->addGrantType(new OAuth2\GrantType\ClientCredentials($storage)); // minimum config

// send the response
$server->handleTokenRequest(OAuth2\Request::createFromGlobals())->send();
```

Now you can call your server and receive a JWT Access Token:

```text
# start the PHP built-in web server
$ php -S localhost:3000 &
$ curl -i -v http://localhost:3000/token.php -u 'CLIENT_ID:CLIENT_SECRET' -d "grant_type=client_credentials"
```
And the server will return a response containing the JWT Access Token:
```json
{
    "access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpZCI6IjYzMjIwNzg0YzUzODA3ZjVmZTc2Yjg4ZjZkNjdlMmExZTIxODlhZTEiLCJjbGllbnRfaWQiOiJUZXN0IENsaWVudCBJRCIsInVzZXJfaWQiOm51bGwsImV4cGlyZXMiOjEzODAwNDQ1NDIsInRva2VuX3R5cGUiOiJiZWFyZXIiLCJzY29wZSI6bnVsbH0.PcC4k8Q_etpU-J4yGFEuBUdeyMJhtpZFkVQ__sXpe78eSi7xTniqOOtgfWa62Y4sj5Npta8xPuDglH8Fueh_APZX4wGCiRE1P4nT4APQCOTbgcuCNXwjmP8znk9F76ID2WxThaMbmpsTTEkuyyUYQKCCdxlIcSbVvcLZUGKZ6-g",
    "client_id":"CLIENT_ID",
    "user_id":null,
    "expires":1382630473,
    "scope":null
}

```

### Resource Server Configuration

If your Resource Server is separate from your Authorization server, you can configure
your server without the Authorization Server's private key:

```php
/* for a Resource Server (minimum config) */
$publicKey = file_get_contents('/path/to/pubkey.pem');

// no private key necessary
$keyStorage = new OAuth2\Storage\Memory(array('keys' => array(
    'public_key'  => $publicKey,
)));

$server = new OAuth2\Server($keyStorage, array(
    'use_jwt_access_tokens' => true,
));
```

This allows your server to verify access tokens without making any requests to the
Authorization Server or any other shared resource.

```php
// verify the JWT Access Token in the request
if (!$server->verifyResourceRequest(OAuth2\Request::createFromGlobals())) {
    exit("Failed");
}
echo "Success!";
```

Now you can request this and experiment with sending in the token you generated above!

```text
# start the PHP built-in web server
$ php -S localhost:3000 &
$ curl "http://localhost:3000/resource.php?access_token=eyJ0eXAi..."
Success!
```

### Using Secondary Storage

This library allows you to back up the access tokens to secondary storage.  Just pass
an object implementing `OAuth2\Storage\AccessTokenInterface` to the `JwtAccessToken` object
to have access tokens stored in an additional location:

```php
$pdoStorage = new OAuth2\Storage\Pdo($pdo); // access token will also be saved to PDO
$keyStorage = new OAuth2\Storage\Memory(array('keys' => array(
    'public_key'  => $publicKey,
    'private_key' => $privateKey,
)));
```

This example pulls the public/private keys from `Memory` storage, and saves the
granted access tokens to `Pdo` storage once they are signed.

### Client-Specific Encryption Keys

It is a good idea to make the keys Client-Specific.  That way, if a key pair is
compromised, only a single client is affected.  Both `Memory` and `Pdo` support
this kind of storage.  Here is an example using `Memory` storage:

```php
$keyStorage = new OAuth2\Storage\Memory(array('keys' => array(
    'ClientID_One' => array(
        'public_key'  => file_get_contents('/path/to/client_1_rsa.pub'),
        'private_key' => file_get_contents('/path/to/client_1_rsa'),
    ),
    'ClientID_Two' => array(
        'public_key'  => file_get_contents('/path/to/client_2_rsa.pub'),
        'private_key' => file_get_contents('/path/to/client_2_rsa'),
    ),
    // declare global keys as well
    'public_key'  => file_get_contents('/path/to/global_rsa.pub'),
    'private_key' => file_get_contents('/path/to/global_rsa'),
)));

```

For `Pdo`, run the following query:

```sql
/* create the database table */
CREATE TABLE oauth_public_keys (client_id VARCHAR(80), public_key VARCHAR(8000), private_key VARCHAR(8000), encryption_algorithm VARCHAR(80) DEFAULT "RS256")
```

Insert sample data using something like this:

```sql
/* insert global keys into the database */
INSERT INTO oauth_public_keys (client_id, public_key, private_key, encryption_algorithm) VALUES (NULL, "...", "...", "RS256");
/* add client-specific key pairs */
INSERT INTO oauth_public_keys (client_id, public_key, private_key, encryption_algorithm) VALUES ("ClientID_One", "...", "...", "RS256");
INSERT INTO oauth_public_keys (client_id, public_key, private_key, encryption_algorithm) VALUES ("ClientID_Two", "...", "...", "RS256");
```

And instantiate the PDO Storage object:

```php
$dsn      = 'mysql:dbname=my_oauth2_db;host=localhost';
$username = 'root';
$password = '';
$pdoStorage = new OAuth2\Storage\Pdo(array('dsn' => $dsn, 'username' => $username, 'password' => $password));
```
### Configure a Different Algorithms

The following algorithms are supported for JwtAccessTokens:

* "HS256" - uses `hash_hmac` / sha256
* "HS384" - uses `hash_hmac` / sha384
* "HS512" - uses `hash_hmac` / sha512
* "RS256" - uses `openssl_sign` / sha256
* "RS384" - uses `openssl_sign` / sha384
* "RS512" - uses `openssl_sign` / sha512

Configure this in your `OAuth2\Storage\PublicKeyInterface` instance.  When using
the `Memory` storage, this would look like this:

```php
$storage = new OAuth2\Storage\Memory(array('keys' => array(
    'public_key'            => $publicKey,
    'private_key'           => $privateKey,
    'encryption_algorithm'  => 'HS256', // "RS256" is the default
)));
```

## Client Verification

The signature can be verified in *any* programming language.  Use standard
`Public Key` encryption methods to validate the access token signatures.  Here
is an example of this in PHP:

```php
$token = json_decode($curlResponse);

$jwt_access_token = $token['access_token'];

$separator = '.';

if (2 !== substr_count($jwt_access_token, $separator)) {
    throw new Exception("Incorrect access token format");
}

list($header, $payload, $signature) = explode($separator, $jwt_access_token);

$decoded_signature = base64_decode($signature);

// The header and payload are signed together
$payload_to_verify = utf8_decode($header . $separator . $payload);

// however you want to load your public key
$public_key = file_get_contents('/path/to/pubkey.pem');

// default is SHA256
$verified = openssl_verify($payload_to_verify, $decoded_signature, $public_key, OPENSSL_ALGO_SHA256);

if ($verified !== 1) {
    throw new Exception("Cannot verify signature");
}

// output the JWT Access Token payload
var_dump(base64_decode($payload));

```