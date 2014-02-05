---
title: Main Concepts | OAuth2 Server PHP
---

# Main Concepts

> To better understand the OAuth specification, please see
> [Learning the OAuth Standard](../../#learning-the-oauth-standard).

The library involves several main concepts:

`Grant Types`

[Grant Types](../../grant-types/) allow you to expose multiple ways for a client to receives an
Access Token.

`Controllers`

An OAuth Server has 3 endpoints, each of which can be fielded by a [Controller](../controllers). Each endpoint
performs a distinct function in the OAuth process.

  * [Authorize Endpoint](../../controllers/authorize/) - The user is redirected here by the client to authorize the request
  * [Token Endpoint](../../controllers/token/) - The client makes a request to this endpoint in order to obtain an Access Token
  * [Resource Endpoint(s)](../../controllers/resource/) - The client requests resources, providing an Access Token for authenticationken. This library supports many different grant types, including all of those defined by the official OAuth Specification.

`Storage Objects`

This library uses [Storage Interfaces](../../storage/interfaces/) to allow interaction with multiple data layers.
The following storage classes come with the library, but interfaces allow for your own customization:

  * [PDO](../../storage/pdo/)
  * [Redis](../../storage/redis/)
  * [Mongo](../../storage/mongo/)
  * [Cassandra](../../storage/cassandra/)
  * [Doctrine Storage](../../cookbook/doctrine)

`Other Concepts`

  * [Response Object](../response)
  * [Scope](../scope)
  * [User IDs](../userid)
  * [Crypto Tokens](../crypto-tokens)
