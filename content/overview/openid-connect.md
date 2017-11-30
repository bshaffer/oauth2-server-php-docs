---
title: OpenID Connect | OAuth2 Server PHP
---

# OpenID Connect

## Examples

You can see an example of OpenID Connect running on
[the demo site][demo site] (select the `OpenID Connect` tab), and
[the code used][use_openid_connect] to set this up using the
`use_openid_connect` configuration option the [key storage] object.

## Overview

Using [OpenID Connect](http://openid.net/connect/) consists of two main
components:

### 1\. Generate a public and private key

The specifics of creating the public and private key `pem` files are out of the
scope of this documentation, but instructions can be found
[online](https://www.digicert.com/ssl-support/pem-ssl-creation.htm).

### 2\. Ensure the `id_token` column exists for Authorization Code storage.

If using PDO, for example, run this query:

```sql
ALTER TABLE oauth_authorization_codes ADD id_token VARCHAR(1000)  NULL  DEFAULT NULL;
```

>

### 3\. Set the `use_openid_connect` and `issuer` configuration parameters

```php
// create storage object
$storage = new OAuth2\Storage\Pdo(array('dsn' => $dsn, 'username' => $username, 'password' => $password));

// configure the server for OpenID Connect
$config['use_openid_connect'] = true;
$config['issuer'] = 'brentertainment.com';

// create the server
$server = new OAuth2\Server($storage, $config);
```

>

### 4\. Create your key storage and add it to the server:

```php
$publicKey  = file_get_contents('/path/to/pubkey.pem');
$privateKey = file_get_contents('/path/to/privkey.pem');
// create storage
$keyStorage = new OAuth2\Storage\Memory(array('keys' => array(
    'public_key'  => $publicKey,
    'private_key' => $privateKey,
)));

$server->addStorage($keyStorage, 'public_key');
```

> Note: Keys could also be stored in your PDO database by creating the public
> key table:
>
```sql
CREATE TABLE oauth_public_keys (
  client_id            VARCHAR(80),
  public_key           VARCHAR(2000),
  private_key          VARCHAR(2000),
  encryption_algorithm VARCHAR(100) DEFAULT 'RS256'
)
```

>

### 5\. Create OpenID grant type and add it to the server:

```php
$server->addGrantType ( new OAuth2\OpenID\GrantType\AuthorizationCode ( $storage ) );
```

>

## Verify OpenID Connect

If your server is properly configured for OpenID Connect, when you request an
access token and include `openid` as one of your requested scopes, the access
token response will contain an `id_token`.

```php
// create a request object to mimic an authorization code request
$request = new OAuth2\Request(array(
    'client_id'     => 'SOME_CLIENT_ID',
    'redirect_uri'  => 'http://brentertainment.com',
    'response_type' => 'code',
    'scope'         => 'openid',
    'state'         => 'xyz',
));
$response = new OAuth2\Response();
$server->handleAuthorizeRequest($request, $response, true);

// parse the returned URL to get the authorization code
$parts = parse_url($response->getHttpHeader('Location'));
parse_str($parts['query'], $query);

// pull the code from storage and verify an "id_token" was added
$code = $server->getStorage('authorization_code')
	->getAuthorizationCode($query['code']);
var_export($code);
```

If your application is configured for OpenID correctly, your output should look
something like this:

```php
array (
  'code' => '3288362b828be2cf9eb2327bb30773a45c3fc151',
  'client_id' => 'SOME_CLIENT_ID',
  'user_id' => NULL,
  'redirect_uri' => 'http://brentertainment.com',
  'expires' => 1442944611,
  'scope' => 'openid',
  'id_token' => 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJvY
  XV0aDItc2VydmVyLWJ1bmRsZSIsInN1YiI6bnVsbCwiYXVkIjoidGVzdC1jbGllbn
  QtNTM4MDM0ODkyIiwiaWF0IjoxNDQyOTQ0NTgxLCJleHAiOjE0NDI5NDgxODEsImF
  1dGhfdGltZSI6MTQ0Mjk0NDU4MX0.Ev-vPTeL1CxmSRpvV0l1nyeogpeKO2uQDuVt
  YbVCphfA8sLBWAVFixnCqsZ2BSLf30KzDCSzQCvSh8jgKOTQAsznE69ODSXurj3NZ
  0IBufgOfLjGi0E4JvI_KksAVewy53mcN2DBSRmtJjwZ8BKjzQnOIJ77LGpQKvpW4S
  kmZE4',
)

```

Where the property `"id_token"` indicates that OpenID Connect is functioning. If
you run into problems, make sure you replace `SOME_CLIENT_ID` with a valid
client id.

[use_openid_connect]: https://github.com/bshaffer/oauth2-demo-php/blob/master/src/OAuth2Demo/Server/Server.php#L43
[key storage]: https://github.com/bshaffer/oauth2-demo-php/blob/master/src/OAuth2Demo/Server/Server.php#L83
[demo site]: http://brentertainment.com/oauth2/
