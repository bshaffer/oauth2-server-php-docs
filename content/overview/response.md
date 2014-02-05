---
title: Request and Response | OAuth2 Server PHP
---

# Request and Response

## The Request Object

Every server call begins with a request. This library uses its own simple object to
validate calls to the server. You will almost always create this like so:

```php
$request = OAuth2\Request::createFromGlobals();

// call the OAuth server with it
$server->handleTokenRequest($request);
```

Because this uses PHP Interfaces, we can easily extend it for the framework we are using:

```php
// use HttpFoundation Requests instead, for Symfony / Twig / Laravel 4 / Drupal 8 / etc!
$symfony_request = Symfony\Component\HttpFoundation\Request::createFromGlobals();
$request = OAuth2\HttpFoundationBridge\Request::createFromRequest($symfony_request)

// call the OAuth server with it
$server->handleTokenRequest($request);
```

## The Response Object

The response object serves the purpose of making your server OAuth2 compliant.  It will set the appropriate status codes, headers,
and response body for a valid or invalid oauth request.  To use it as it's simplest level, just send the output and exit:

```php
$request = OAuth2\Request::createFromGlobals();
$response = new OAuth2\Response();

// will set headers, status code, and json response appropriately for success or failure
$server->grantAccessToken($request, $response);
$response->send();
```

The response object can also be used to customize output. Below, if the request is NOT valid, the error is sent to the browser:

```php
if (!$token = $server->grantAccessToken($request, $response)) {
    $response->send();
    die();
}
echo sprintf('Your token is %s!!', $token);
```

This will populate the appropriate error headers, and return a json error response.  If you do not want to send a JSON response,
the response object can be used to display the information in any other format:

```php
if (!$token = $server->grantAccessToken($request, $response)) {
    $parameters = $response->getParameters();
    // format as XML
    header("HTTP/1.1 " . $response->getStatusCode());
    header("Content-Type: text/xml");
    echo "<error><name>".$parameters['error']."</name><message>".$parameters['error_description']."</message></error>";
}
```

This is very useful when working in a framework or existing codebase, where this library will not have full control of the response.

See the [HttpFoundation Bridge](https://github.com/bshaffer/oauth2-server-httpfoundation-bridge) library for plugging your request/response
into frameworks using the [HttpFoundation](https://github.com/symfony/HttpFoundation) library.