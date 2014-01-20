# Implicit

## Overview

The `Implicit` grant type is similar to the Authoirzation Code
grant type in that it is used to request access to protected
resources on behalf of another user (i.e. a 3rd party). It is
optimized for **public** clients, such as those implemented in
javascript or on mobile devices, where client credentials cannot
be stored.

[Read more about implicit](http://tools.ietf.org/html/rfc6749#section-4.2)

## Use Cases

  * calls on behalf of a third party
  * for browser-based applications (javscript)
  * for native applications (desktop and mobile devices)
  * for any application where client credentials cannot be safely stored

## Implementation

When your server is created, simply configure the server to allow the implicit
grant type

```php
// create a storage object for your server
$storage = new OAuth2\Storage\Pdo(array('dsn' => 'mysql:dbname=my_oauth2_db;host=localhost', 'username' => 'root', 'password' => ''));

// create the server, and configure it to allow implicit
$server = new OAuth2\Server($storage, array(
    'allow_implicit' => true,
));
```

This allows the `Authorize Controller` to return an access token directly from
a request to the server's `authorize` endpoint.

## Example Request

When using the Implicit grant type, tokens are retrieved using the
`Authorize Controller`. The client specifies the grant type by setting
the querystring parameter `response_type=token` in the OAuth server's
`authorize' endpoint.

First, redirect the user to the following URL:

```text
https://api.mysite.com/authorize?response_type=token&client_id=TestClient&redirect_uri=https://myredirecturi.com/cb
```

A successful token request will be returned in the fragment of the URL:

```text
https://myredirecturi.com/cb#access_token=2YotnFZFEjr1zCsicMWpAA&state=xyz&token_type=bearer&expires_in=3600
```

## Demo

[See the implicit grant type demo](http://brentertainment.com/oauth2/)

