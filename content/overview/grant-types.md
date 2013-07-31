# Grant Types

There are many supported grant types in the OAuth2 specification, and this library allows for the addition of custom grant types as well.
Supported grant types are as follows:

### [Authorization Code](http://tools.ietf.org/html/rfc6749#section-4.1)

An authorization code obtained by user authorization is exchanged for a token.  This is the most common OAuth2.0 flow, as it implements
**3-Legged OAuth**. Click the [Live Demo](http://brentertainment.com/oauth2/) to see this grant type in action.

### [Implicit](http://tools.ietf.org/html/rfc6749#section-4.2)

This is similar to the `Authorization Code` Grant Type above, but rather than an Authorization Code being returned from the authorization
request, a token is retured to the client.  This is most common for client-side devices (i.e. mobile) where the Client Credentials cannot
be stored securely.

### [Resource Owner Password Credentials](http://tools.ietf.org/html/rfc6749#section-4.3)

A Resource Owner's username and password are submitted as part of the request, and a token is issued upon successful authentication.

```json
$ curl -u testclient:testpass "http://localhost/token.php" -d 'grant_type=password&username=someuser&password=somepassword'
{"access_token":"206c80413b9a96c1312cc346b7d2517b84463edd","expires_in":3600,"token_type":"bearer","scope":null}
```

### [Client Credentials](http://tools.ietf.org/html/rfc6749#section-4.4)

The client uses their credentials to retrieve an access token directly, which allows access to resources under the client's control

```json
$ curl -u testclient:testpass "http://localhost/token.php" -d 'grant_type=client_credentials'
{"access_token":"6f05ad622a3d32a5a81aee5d73a5826adb8cbf63","expires_in":3600,"token_type":"bearer","scope":null}
```

### [JWT Authorization Grant](http://tools.ietf.org/html/draft-ietf-oauth-jwt-bearer-04#section-4)

The client can submit a JWT (JSON Web Token) in a request to the token endpoint. An access token (without a refresh token) is then returned directly.

### [Refresh Token](http://tools.ietf.org/html/rfc6749#section-6)

The client can submit refresh token and recieve a new access token e.g. it may be necessary to do this if the access_token had expired.

### [Extension Grant](http://tools.ietf.org/html/rfc6749#section-4.5)

Create your own grant type by implementing the `OAuth2\GrantType\GrantTypeInterface` and adding it to the OAuth2 Server object.

## Multiple Grant Types

If you want to support more than one grant type it is possible to add more when the Server object is created:

```php
$server->addGrantType(new OAuth2\GrantType\UserCredentials($storage));
$server->addGrantType(new OAuth2\GrantType\RefreshToken($storage));
$server->addGrantType(new OAuth2\GrantType\AuthorizationCode($storage));
```
