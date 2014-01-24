---
title: User Credentials Grant Type | OAuth2 Server PHP
---

# User Credentials

## Overview

The `User Credentials` grant type (a.k.a. Resource Owner Password Credentials)
is used when the user has a trusted relationship with the client, and so can
supply credentials directly.

[Read more about user credentials](http://tools.ietf.org/html/rfc6749#section-4.3)

## Use Cases

  * when the client wishes to display a login form
  * for applications owned and operated by the resource server (such as a mobile or desktop application)
  * for applications migrating away from using direct authentication and stored credentials

## Implementation

Create an instance of `OAuth2\GrantType\UserCredentials` and add it to
your server

```php
// create some users in memory
$users = array('bshaffer' => array('password' => 'brent123', 'first_name' => 'Brent', 'last_name' => 'Shaffer'));

// create a storage object
$storage = new OAuth2\Storage\Memory(array('user_credentials' => $users));

// create the grant type
$grantType = new OAuth2\GrantType\UserCredentials($storage);

// add the grant type to your OAuth server
$server->addGrantType($grantType);
```

> Note: User storage is highly customized for each application, so it is highly recommended
> you implement your own storage using `OAuth2\Storage\UserCredentialsInterface`

## Example Request

Send in the user credentials directly to receive an access token:

```text
$ curl -u TestClient:TestSecret https://api.mysite.com/token -d 'grant_type=password&username=bshaffer&password=brent123'
```

If your client is `public` (by default, this is true when no secret is associated with the client), you
can omit the `client_secret` value in the request:

```text
$ curl https://api.mysite.com/token -d 'grant_type=password&client_id=TestClient&username=bshaffer&password=brent123'
```

A successful token request will return a standard access token in JSON format:

```json
{"access_token":"03807cb390319329bdf6c777d4dfae9c0d3b3c35","expires_in":3600,"token_type":"bearer","scope":null}
```
