---
title: Custom Storage | OAuth2 Server PHP
---

# Custom Storage

## Overview

A great advantage to using this library is the ease of customizing your
own storage. If one of the built-in storage objects does not fit your needs,
you can implement one or more of the interfaces below to obtain custom storage
functionality.

## How to Customize Storage

First, find out which storage interfaces you want to implement. As a minimum, every
OAuth2 server requires storage objects implementing `AccessTokenInterface` and
`ClientCredentialsInterface`, so if you cannot store these using one of the built-in
storage classes, your custom storage can start with these. After that, you'll want to
implement additional interfaces based on your [Grant Types](../../overview/grant-types/).
For instance, if you want your server to support the `authorization_code` grant type
(most common), and you want your custom storage to do it, you'll need to implement
`AuthorizationCodeInterface` on your storage object(s) as well.

The term "implement" refers to the class declaration in your custom storage
PHP class. For instance, to use custom storage for access tokens, clients, and the
authorization code grant type, your class will look something like this:

```php
class MyCustomStorage implements OAuth2\Storage\AccessTokenInterface,
OAuth2\Storage\ClientCredentialsInterface, OAuth2\Storage\AuthorizationCodeInterface
{
    // method implementation here...
}
```

Once this is done, you will need to write all the methods that those interfaces require.
For instance, `ClientCredentialsInterface` specifies the method `getClientDetails`,
which accepts a `$client_id` parameter and returns an array of client data.

From there, you'll pass this new storage object into the server class:

```php
$customStorage = new MyCustomStorage();
$server = new OAuth2\Server($customStorage);
```

Don't know what methods you need? No problem, just pop open the interface classes and [take
a look](https://github.com/bshaffer/oauth2-server-php/tree/develop/src/OAuth2/Storage)! If
this isn't your style, PHP throws a helpful error message to let you know the
methods your class still needs to implement, if it's missing them.

All of the storage objects included in this library are no different from a "Custom Storage"
object.  The only real difference is that they're included in the library by default, and
they implement **all** the interfaces (yours doesn't have to implement all the storage
interfaces, just the ones you want to customize).

See the list of interfaces below for all possible storage interfaces, and check out the
[Cassandra Storage](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/Cassandra.php)
class for an example of a storage object implemented for a "custom" purpose - to interface
with the Cassandra storage engine.

## Interfaces

**[Access Token Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/AccessTokenInterface.php)**

For implementing basic Access Tokens. This is required for the
[Token Controller](../../controllers/token/), unless
[Crypto Tokens](../../overview/crypto-tokens) are used instead.

*id: "access_token"*

**[Client Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/ClientInterface.php)**

Required for the [Token Controller](../../controllers/token/)
and [Authorize Controller](../../controllers/authorize/), and
is used to gather information about the client making the request.

*id: "client"*

**[Client Credentials Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/ClientCredentialsInterface.php)**

For validating a client's credentials. This is required for all requests
to the [Token Controller](../../controllers/token/), in order to validate
the client making the request.

*id: "client_credentials"*

**[Authorization Code Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/AuthorizationCodeInterface.php)**

For implementing the [Authorization Code Grant Type](../../grant-type/authorization-code)

*id: "authorization_code"*

**[Refresh Token Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/RefreshTokenInterface.php)**

For implementing the [Refresh Token Grant Type](../../grant-type/refresh-token/).

*id: "refresh_token"*

**[User Credentials Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/UserCredentialsInterface.php)**

For implementing the [User Credentials Grant Type](../../grant-type/user-credentials).

*id: "user_credentials"*

**[JWT Bearer Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/JwtBearerInterface.php)**

Required for the [JWT Bearer Grant Type](../../grant-type/jwt-bearer).

*id: "jwt_bearer"*

**[Scope Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/ScopeInterface.php)**

For implementing scopes using the [Scope Util](../../overview/scope).

*id: "scope"*

**[Public Key Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/PublicKeyInterface.php)**

For implementing [Crypto Token](../../overview/crypto-tokens).

*id: "public_key"*

**[Crypto Token Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/CryptoTokenInterface.php)**

An interface for using [Crypto Tokens](../../overview/crypto-tokens).
This requires the Public Key interface (below), and is used for validating
access tokens without the use of a database system.

*id: NONE*
