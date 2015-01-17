---
title: Refresh Token Grant Type | OAuth2 Server PHP
---

# Refresh Token

## Overview

The `Refresh Token` grant type is used to obtain additional access tokens
in order to prolong the client's authorization of a user's resources.

[Read more about refresh tokens](http://tools.ietf.org/html/rfc6749#section-1.5)

## Use Cases

  * to allow clients prolonged access of a user's resources
  * to retrieve additional tokens of equal or lesser scope for separate resource calls

## Implementation

Create an instance of `OAuth2\GrantType\RefreshToken` and add it to
your server

```php
// create a storage object to hold refresh tokens
$storage = new OAuth2\Storage\Pdo(array('dsn' => 'sqlite:refreshtokens.sqlite'));

// create the grant type
$grantType = new OAuth2\GrantType\RefreshToken($storage);

// add the grant type to your OAuth server
$server->addGrantType($grantType);
```

> Note: Refresh tokens are only provided when retrieving a token using the
> `Authorization Code` or `User Credentials` grant types.

> Note: Refresh tokens will only be returned if a storage implementing
> `OAuth2\Storage\RefreshTokenInterface` is provided to your instance
> of `OAuth2\Server`.


## Configuration

The Refresh Token grant type has the following configuration:

  * `always_issue_new_refresh_token`
    * whether to issue a new refresh token upon successful token request
    * **Default**: false

For example:

```php
// the refresh token grant request will have a "refresh_token" field
// with a new refresh token on each request
$grantType = new OAuth2\GrantType\RefreshToken($storage, array(
    'always_issue_new_refresh_token' => true
));
```

The Access Token return type has the following configuration:

  * `refresh_token_lifetime`
    * time before refresh token expires
    * **Default**: 1209600 (14 days)

For example:

```php
// the refresh tokens now last 28 days
$accessToken = new OAuth2\ResponseType\AccessToken($accessStorage, $refreshStorage, array(
    'refresh_token_lifetime' => 2419200,
));

$server = new OAuth2\Server($storage, $config, $grantType, array($accessToken));
```

However, both of these configuration options can be sent in when the server is created
using the server's configuration array:

```php
$server = new OAuth2\Server($storage, array(
    'always_issue_new_refresh_token' => true,
    'refresh_token_lifetime'         => 2419200,
));
```

>

## Example Request

First, a refresh token must be retrieved using the Authorizaton Code or User Credentials grant types:

```text
$ curl -u TestClient:TestSecret https://api.mysite.com/token -d 'grant_type=password&username=bshaffer&password=brent123'
```

The access token will then contain a refresh token:

```json
{
    "access_token":"2YotnFZFEjr1zCsicMWpAA",
    "expires_in":3600,
    "token_type": "bearer",
    "scope":null,
    "refresh_token":"tGzv3JOkF0XG5Qx2TlKWIA",
}
```

This refresh token can then be used to generate a new access token of equal or
lesser scope:

```text
$ curl -u TestClient:TestSecret https://api.mysite.com/token -d 'grant_type=refresh_token&refresh_token=tGzv3JOkF0XG5Qx2TlKWIA'
```

A successful token request will return a standard access token in JSON format:

```json
{"access_token":"03807cb390319329bdf6c777d4dfae9c0d3b3c35","expires_in":3600,"token_type":"bearer","scope":null}
```

If the server is configured to always issue a new refresh token, then a refresh token
will be returned with this response as well:

```json
{"access_token":"03807cb390319329bdf6c777d4dfae9c0d3b3c35","expires_in":3600,"token_type":"bearer","scope":null,"refresh_token":"s6BhdRkqt303807bdf6c78"}
```

