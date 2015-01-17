---
title: Redis Storage | OAuth2 Server PHP
---

# Redis

## Overview

Uses the [Redis](http://redis.io/) Key-Value Storage System
for storing and retrieving objects in OAuth.

## Installation

First, install the [Redis client library](https://github.com/nrk/predis) for PHP

```text
$ composer require predis/predis:dev-master
```

>

## Get Started

Once this is done, [create a connection instance](https://github.com/nrk/predis#connecting-to-redis)
to connect to the redis server.

```php
$predis = new \Predis\Client();
```

Then, create the storage object using the `Redis` storage class:

```php
$storage = new OAuth2\Storage\Redis($predis);

// now you can perform storage functions, such as the one below
$storage->setClientDetails($client_id, $client_secret, $redirect_uri);
```

>

## Usage

The Redis storage engine implements all the standard Storage Interfaces supported
in this library.  See [interfaces](../custom) for more information.