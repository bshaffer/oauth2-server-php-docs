---
title: OAuth2 Server PHP
---

# An OAuth2 Server Library for PHP

Implement OAuth2.0 cleanly into your PHP application.  [Download the Code](https://github.com/bshaffer/oauth2-server-php) from GitHub to get started.

## Requirements

**PHP 5.3.9+** is required for this library.  However, there is a [stable release](https://github.com/bshaffer/oauth2-server-php/tree/v0.9) and [development branch](https://github.com/bshaffer/oauth2-server-php/tree/php5.2-develop) for **PHP 5.2.x-5.3.8** as well.

## Installation

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
        "bshaffer/oauth2-server-php": "v1.6",
        ...
    },
    ...
}
```

And then run `composer.phar install`

> It is highly recommended you check out the [`v1.6`](https://github.com/bshaffer/oauth2-server-php/tree/v1.6) tag to
> ensure your application doesn't break from backwards-compatibility issues. However, if you'd like to stay on the
> bleeding edge of development, you can set this to `dev-develop` instead.

## Get Started With This Library

Looking through the [cookbook](cookbook) examples is the best way to get started.  For those who just skim the docs for
code samples, here is an example of a bare-bones OAuth2 Server implementation:

```php
$storage = new OAuth2\Storage\Pdo(array('dsn' => $dsn, 'username' => $username, 'password' => $password));
$server = new OAuth2\Server($storage);
$server->addGrantType(new OAuth2\GrantType\AuthorizationCode($storage)); // or any grant type you like!
$server->handleTokenRequest(OAuth2\Request::createFromGlobals())->send();
```

See [Main Concepts](overview/main-concepts) for more information on how this library works.

## <a class="anchor" name="learning-the-oauth-standard" href="#learning-the-oauth-standard"></a>Learning the OAuth2.0 Standard

1.  If you are new to OAuth2, I highly recommend the **<a href="https://knpuniversity.com/screencast/oauth" onClick="trackOutboundLink(this, 'Outbound Links', this.href)">OAuth in 8 Steps</a>** screencast
from Knp University:
![OAuth in 8 Steps](https://pbs.twimg.com/media/BemcRQ6CEAA1DxF.png)

2. Additionally, take some time to click around on the [**OAuth2 Demo Application**](http://brentertainment.com/oauth2)
and view the [source code](https://github.com/bshaffer/oauth2-demo-php) for examples using a variety of
[grant types](overview/grant-types).
![OAuth Demo Application](http://brentertainment.com/other/screenshots/demoapp-authorize.png)

3. Also, [Auth0](https://auth0.com/) provides a very nice layer for implementing OAuth2.0 for [PHP applications](https://docs.auth0.com/server-platforms/php).

4. Finally, consult the [official OAuth2.0 documentation](http://tools.ietf.org/html/rfc6749) for the down-and-dirty
technical specifications.

Contact
-------

The best way to get help and ask questions is to [file an issue](https://github.com/bshaffer/oauth2-server-php/issues/new).  This will
help answer questions for others as well.

If for whatever reason filing an issue does not make sense, contact Brent Shaffer (bshafs <at> gmail <dot> com)
