# Cassandra

## Overview

Uses the [Cassandra](http://cassandra.apache.org/) Database Management System
for storing/retrieving objects in OAuth.

## Installation

First, install the [Cassandra client library](https://github.com/thobbs/phpcassa) for PHP

```text
$ composer require thobbs/phpcassa:dev-master
```

## Get Started

Once this is done, [instantiate a connection pool](http://thobbs.github.io/phpcassa/tutorial.html)
instance to connect to the cassandra server.

```php
$servers = array('127.0.0.1:9160');
$cassandra = new \phpcassa\Connection\ConnectionPool('oauth2_server', $servers);
```

Then, create the storage object using the `Cassandra` storage class:

```php
$storage = new OAuth2\Storage\Cassandra($cassandra);

// now you can perform storage functions, such as the one below
$storage->setClientDetails($client_id, $client_secret, $redirect_uri);
```

## Usage

The Cassandra storage engine implements all the standard Storage Interfaces supported
in this library.  See [interfaces](../interfaces) for more information.