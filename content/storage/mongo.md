---
title: Mongo Storage | OAuth2 Server PHP
---

# Mongo

## Overview

Uses the [Mongo](http://www.mongodb.org/) Document Database
for storing/retrieving objects in OAuth.

## Installation

First, install the [Mongo Extension](http://www.php.net/manual/en/book.mongo.php) for PHP
You can use PECL:

```text
$ sudo pecl install mongo
```

Or install manually. [Download the latest version](https://github.com/mongodb/mongo-php-driver)
of the code from github.

```text
$ tar zxvf mongodb-mongodb-php-driver-<commit_id>.tar.gz
$ cd mongodb-mongodb-php-driver-<commit_id>
$ phpize
$ ./configure
$ make all
$ sudo make install
```

Next, enable the `mongo.so` extension in your `php.ini` file:

```text
extension=mongo.so
```

## Get Started

Once this is done, [create a mongo client](http://www.php.net/manual/en/class.mongoclient.php)
to connect to the mongo server.

```php
$mongo = new \MongoClient();
```

Now, create the storage object using the `Mongo` storage class:

```php
$storage = new OAuth2\Storage\Mongo($mongo);

// now you can perform storage functions, such as the one below
$storage->setClientDetails($client_id, $client_secret, $redirect_uri);
```

## Usage

The Mongo storage engine implements all the standard Storage Interfaces supported
in this library.  See [interfaces](../interfaces) for more information.