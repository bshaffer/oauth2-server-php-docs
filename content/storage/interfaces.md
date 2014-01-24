# Interfaces

## Overview

This library supports adapters for several different storage engines.
Among them is [PDO](../pdo) (for MySQL, SQLite, PostgreSQL, etc),
[MongoDB](../mongo), [Redis](../redis), and [Cassandra](../cassandra).

This is done through multiple PHP Interfaces which dictate how different
objects are stored. Interfaces allow the library to be extended and
customized for multiple platforms.

**[Access Token Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/AccessTokenInterface.php)**

For implementing basic Access Tokens. This is required for the
[Token Controller](../../controllers/token/), unless
[Crypto Tokens](../../overview/crypto-tokens) are used instead.

**[Authorization Token Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/AuthorizationCodeInterface.php)**

For implementing the [Authorization Code Grant Type](../../grant-type/authorization-code)

**[Client Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/ClientInterface.php)**

Required for the [Token Controller](../../controllers/token/)
and [Authorize Controller](../../controllers/authorize/), and
is used to gather information about the client making the request.

**[Client Credentials Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/ClientCredentialsInterface.php)**

For validating a client's credentials. This is required for all requests
to the [Token Controller](../../controllers/token/), in order to validate
the client making the request.

**[Crypto Token Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/CryptoTokenInterface.php)**

An interface for using [Crypto Tokens](../../overview/crypto-tokens).
This requires the Public Key interface (below), and is used for validating
access tokens without the use of a database system.

**[JWT Bearer Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/JwtBearerInterface.php)**

Required for the [JWT Bearer Grant Type](../../grant-type/jwt-bearer).

**[Public Key Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/PublicKeyInterface.php)**

For implementing [Crypto Token](../../overview/crypto-tokens).

**[Refresh Token Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/RefreshTokenInterface.php)**

For implementing the [Refresh Token Grant Type](../../grant-type/refresh-token/).

**[Scope Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/ScopeInterface.php)**

For implementing scopes using the [Scope Util](../../overview/scope).

**[User Credentials Interface](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/UserCredentialsInterface.php)**

For implementing the [User Credentials Grant Type](../../grant-type/user-credentials).
