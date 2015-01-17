---
title: Client Credentials Grant Type | OAuth2 Server PHP
---

# Client Credentials

## Overview

The `Client Credentials` grant type is used when the
client is requesting access to protected resources under its
control (i.e. there is no third party).

[Read more about client credentials](http://tools.ietf.org/html/rfc6749#section-4.4)

## Use Cases

  * service calls
  * calls on behalf of the user who created the client.

## Implementation

Create an instance of `OAuth2\GrantType\ClientCredentials` and add it to
your server

```php
// create test clients in memory
$clients = array('TestClient' => array('client_secret' => 'TestSecret'));

// create a storage object
$storage = new OAuth2\Storage\Memory(array('client_credentials' => $clients));

// create the grant type
$grantType = new OAuth2\GrantType\ClientCredentials($storage);

// add the grant type to your OAuth server
$server->addGrantType($grantType);
```

>

## Configuration

The Client Credentials grant type has the following configuration:

  * `allow_credentials_in_request_body`
    * whether to look for credentials in the POST body in addition to the Authorize HTTP Header
    * **Default**: true

For example:

```php
// this request will only allow authorization via the Authorize HTTP Header (Http Basic)
$grantType = new OAuth2\GrantType\ClientCredentials($storage, array(
    'allow_credentials_in_request_body => false'
));
```

>

## Example Request

```text
# using HTTP Basic Authentication
$ curl -u TestClient:TestSecret https://api.mysite.com/token -d 'grant_type=client_credentials'

# using POST Body
$ curl https://api.mysite.com/token -d 'grant_type=client_credentials&client_id=TestClient&client_secret=TestSecret'
```

A successful token request will return a standard access token in JSON format:

```json
{"access_token":"03807cb390319329bdf6c777d4dfae9c0d3b3c35","expires_in":3600,"token_type":"bearer","scope":null}
```
