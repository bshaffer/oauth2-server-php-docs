---
title: Grant Types | OAuth2 Server PHP
---

# Grant Types

There are many supported grant types in the OAuth2 specification, and this library allows for the addition of custom grant types as well.
Supported grant types are as follows:

### [Authorization Code](../../grant-types/authorization-code/)

The `Authorization Code` grant type is the most common OAuth2.0 flow.  It implements **3-Legged OAuth** and involves the user granting the
client an authorization code, which can be exchanged for an Access Token. Click the [Live Demo](http://brentertainment.com/oauth2/) to see
this grant type in action.

### [Resource Owner Password Credentials](../../grant-types/user-credentials/)

A Resource Owner's username and password are submitted as part of the request, and a token is issued upon successful authentication.

```json
$ curl -u testclient:testpass "http://localhost/token.php" -d 'grant_type=password&username=someuser&password=somepassword'
{"access_token":"206c80413b9a96c1312cc346b7d2517b84463edd","expires_in":3600,"token_type":"bearer","scope":null}
```

>

### [Client Credentials](../../grant-types/client-credentials/)

The client uses their credentials to retrieve an access token directly, which allows access to resources under the client's control

```json
$ curl -u testclient:testpass "http://localhost/token.php" -d 'grant_type=client_credentials'
{"access_token":"6f05ad622a3d32a5a81aee5d73a5826adb8cbf63","expires_in":3600,"token_type":"bearer","scope":null}
```

>

### [Refresh Token](../../grant-types/refresh-token/)

The client can submit a refresh token and receive a new access token if the access token had expired.

```json
$ curl -u testclient:testpass "http://localhost/token.php" -d 'grant_type=refresh_token&refresh_token=c54adcfdb1d99d10be3be3b77ec32a2e402ef7e3'
{"access_token":"0e9d02499fe06762ecaafb9cfbb506676631dcfd","expires_in":3600,"token_type":"bearer","scope":null}
```

>

### [Implicit](../../grant-types/implicit/)

This is similar to the `Authorization Code` Grant Type above, but rather than an Authorization Code being returned from the authorization
request, a token is retured to the client.  This is most common for client-side devices (i.e. mobile) where the Client Credentials cannot
be stored securely.

Use the `Implicit` Grant Type by setting the `allow_implicit` option to true for the `authorize` endpoint:

```php
$storage = new OAuth2\Storage\Pdo(array('dsn' => $dsn, 'username' => $username, 'password' => $password));
$server = new OAuth2\Server($storage, array('allow_implicit' => true));

$server->handleAuthorizeRequest(OAuth2\Request::createFromGlobals())->send();
```

> It is important to note this is not added as a `Grant Type` class because the implicit grant type is requested using the `authorize` endpoint rather than the `token` endpoint.

### [JWT Bearer](../../grant-types/jwt-bearer/)

The client can submit a JWT (JSON Web Token) in a request to the token endpoint. An access token (without a refresh token) is then returned directly.

### [Extension Grant](http://tools.ietf.org/html/rfc6749#section-4.5)

Create your own grant type by implementing the `OAuth2\GrantType\GrantTypeInterface` and adding it to the OAuth2 Server object.  The `JWT Bearer`
Grant Type above is an example of this.

## Multiple Grant Types

If you want to support more than one grant type it is possible to add more when the Server object is created:

```php
$server->addGrantType(new OAuth2\GrantType\UserCredentials($storage));
$server->addGrantType(new OAuth2\GrantType\RefreshToken($storage));
$server->addGrantType(new OAuth2\GrantType\AuthorizationCode($storage));
```
## Restricting Grant Types to Clients

The grant type(s) available to a client are controlled by a combination of the `grant_type` field in the client storage, and the grant types made available within the authorization server.

When the client has a list of grant types configured alongside it, the client is restricted to using only those grant types. When there are no grant types configured, the client is not restricted in what grant types it may use, it is able to use all grant types available within the authorization server.
