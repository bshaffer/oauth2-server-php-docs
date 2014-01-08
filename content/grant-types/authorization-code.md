# Authorization Code

## Overview

The `Authorization Code` grant type is used when the
client wants to request access to protected resources on
behalf of another user (i.e. a 3rd party).  This is the
grant type most often associated with OAuth.

[Read more about authorization code](http://tools.ietf.org/html/rfc6749#section-4.1)

## Use Cases

  * calls on behalf of a third party

## Implementation

Create an instance of `OAuth2\GrantType\AuthorizationCode` and add it to
your server

```php
// create a storage object to hold new authorization codes
$storage = new OAuth2\Storage\Pdo(array('dsn' => 'sqlite:authcodes.sqlite'));

// create the grant type
$grantType = new OAuth2\GrantType\AuthorizationCode($storage);

// add the grant type to your OAuth server
$server->addGrantType($grantType);
```

## Example Request

Authorization Codes are retrieved using the `Authorize Controller`. The client
must send the user to the OAuth server's `authorize` URL.

First, redirect the user to the following URL:

```text
https://api.mysite.com/authorize?response_type=code&client_id=TestClient&redirect_uri=https://myredirecturi.com/cb
```

A successful authorization will pass the client the authorization code in the URL
via the supplied redirect_uri:


```text
https://myredirecturi.com/cb?code=SplxlOBeZQQYbYS6WxSbIA&state=xyz
```

Once this is done, a token can be requested using the authorization code.

```text
$ curl -u TestClient:TestSecret https://api.mysite.com/token -d 'grant_type=authorization_code&code=xyz'
```

A successful token request will return a standard access token in JSON format:

```json
{"access_token":"03807cb390319329bdf6c777d4dfae9c0d3b3c35","expires_in":3600,"token_type":"bearer","scope":null}
```
