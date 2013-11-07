---
title: OAuth2 Server PHP
---

# An OAuth2 Server Library for PHP

Implement OAuth2.0 cleanly into your PHP application.  [Download the Code](https://github.com/bshaffer/oauth2-server-php) from GitHub to get started.

Requirements
------------

**PHP 5.3.9+** is required for this library.  However, there is a [stable release](https://github.com/bshaffer/oauth2-server-php/tree/v0.9) and [developerment branch](https://github.com/bshaffer/oauth2-server-php/tree/php5.2-develop) for **PHP 5.2.x-5.3.8** as well.

Installation
------------

This library follows the zend [PSR-0](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md) standards.  A number of
autoloaders exist which can autoload this library for that reason, but if you are not using one, you can register the `OAuth2\Autoloader`:

```php
require_once('/path/to/oauth2-server-php/src/OAuth2/Autoloader.php');
OAuth2\Autoloader::register();
```

Using [Composer](http://getcomposer.org)? Add the following to `composer.json`:

```json
{
    "require": {
        "bshaffer/oauth2-server-php": "dev-develop",
        ...
    },
    ...
}
```

And then run `composer.phar install`

> It is highly recommended you check out the [`v1.0`](https://github.com/bshaffer/oauth2-server-php/tree/v1.0) tag to
> ensure your application doesn't break from backwards-compatibility issues, but also this means you
> will not receive the latest changes.

Learning the OAuth2.0 Standard
------------------------------

If you are new to OAuth2, take a little time first to look at the [OAuth2 Demo Application](http://brentertainment.com/oauth2) and the [source code](https://github.com/bshaffer/oauth2-demo-php), and read up on [OAuth2 Flows](http://drupal.org/node/1958718).  For everything else, consult the [OAuth2.0 Specification](http://tools.ietf.org/html/rfc6749)

Get Started With This Library
-----------------------------

Looking through the [cookbook](cookbook) examples is the best way to get started.  For those who just skim the docs for
code samples, here is an example of a bare-bones OAuth2 Server implementation:

```php
$storage = new OAuth2\Storage\Pdo(array('dsn' => $dsn, 'username' => $username, 'password' => $password));
$server = new OAuth2\Server($storage);
$server->addGrantType(new OAuth2\GrantType\AuthorizationCode($storage)); // or any grant type you like!
$server->handleTokenRequest(OAuth2\Request::createFromGlobals())->send();
```

All implementations require a `Storage` object.  This allows the server to interact with data in your storage
layer such as [OAuth Clients](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/ClientInterface.php) and
[Authorization Codes](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/AuthorizationCodeInterface.php).
Built-in storage classes include [PDO](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/Pdo.php),
[Redis](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/Redis.php), and
[Mongo](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/Mongo.php).  The interfaces allow (and encourage)
the use of your own Storage objects to fit your application's implementation (see the [Doctrine Storage](cookbook/doctrine) example).

Once you've created a storage object, pass it to the server object and define which Grant Types your server is to support.  See
the list of supported [Grant Types](overview/grant_types).

The final step, once the Server object is set up, is to handle the incoming request.  Consult the [Server Methods](overview/methods), or
see the Step-by-Step walkthrough below to familiarize yourself with the types of requests involved in OAuth2.0 workflows.

You might also want to learn about the [Scope](overview/scope), how to integrate [User IDs](overview/userid), or read more about
the [Response Object](overview/response)

### Walkthrough Example

To get started quickly with some real code try out the [Step-by-Step Walkthrough](cookbook).

Contact
-------

The best way to get help and ask questions is to [file an issue](https://github.com/bshaffer/oauth2-server-php/issues/new).  This will
help answer questions for others as well.

If for whatever reason filing an issue does not make sense, contact Brent Shaffer (bshafs <at> gmail <dot> com)
