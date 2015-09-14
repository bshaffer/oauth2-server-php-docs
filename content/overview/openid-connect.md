---
title: OpenID Connect | OAuth2 Server PHP
---

# OpenID Connect

## Examples

You can see an example of OpenID Connect running on
[the demo site](http://brentertainment.com/oauth2/), and examples of how
this was set up using the [`use_openid_connect`](https://github.com/bshaffer/oauth2-demo-php/blob/master/src/OAuth2Demo/Server/Server.php#L43) configuration
option and setting the [key storage](https://github.com/bshaffer/oauth2-demo-php/blob/master/src/OAuth2Demo/Server/Server.php#L83) object.

## Overview

Using [OpenID Connect](http://openid.net/connect/) consists of two main components:

1\. Set the `use_openid_connect` configuration parameter when you create your server:

```php
$config['use_openid_connect'] = true;
$server = new OAuth2\Server($config);
```

>

2\. Create your key storage and add it to the server:

```php
$publicKey  = file_get_contents('/path/to/pubkey.pem');
$privateKey = file_get_contents('/path/to/privkey.pem');
// create storage
$keyStorage = new Memory(array('keys' => array(
    'public_key'  => $publicKey,
    'private_key' => $privateKey,
)));

$server->setKeyStorage($keyStorage);
```

The specifics of creating the public and private key `pem` files are out of the
scope of this documentation, but instructions can be found
[online](https://www.digicert.com/ssl-support/pem-ssl-creation.htm).
