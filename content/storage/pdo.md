---
title: PDO Storage | OAuth2 Server PHP
---

# PDO

## Overview

The PDO Storage class uses the [PDO](http://www.php.net/manual/en/book.pdo.php)
extension for PHP. This allows connection to MySQL, SQLite, PostgreSQL, and
[many more](http://www.php.net/manual/en/pdo.drivers.php).

## Installation

PDO is installed by default in `php 5.1+`, which is already required for this library,
so you'll be good to go.

## Get Started

Once this is done, [instantiate a PDO client](http://www.php.net/manual/en/pdo.connections.php)
to connect to your database server of choice.

```php
// connection for MySQL
$pdo = new PDO('mysql:host=localhost;dbname=test', $user, $pass);

// connection for SQLite
$pdo = new PDO('sqlite:/opt/databases/mydb.sq3');

// connection for SQLite in memory
$pdo = new PDO('sqlite::memory:');

// connection for Oracle. With Oracle, you'll need some extra steps:
$options = [
    // without the following option, Oracle may convert some names to UPPERCASE,
    // which will break SQL code of the OAuth server library (having names written in lowercase)
    PDO::ATTR_CASE => PDO::CASE_LOWER,
];
$pdo = new PDO("oci:dbname=//$host:$port/$sid", $user, $pass, $options);
// without the following statement, Oracle may not understand the datetime format used by the OAuth server library
$pdo->exec("alter session set nls_timestamp_format = 'YYYY-MM-DD HH24:MI:SS'");
```

Then, create the storage object using the `Pdo` storage class:

```php
$storage = new OAuth2\Storage\Pdo($pdo);

// now you can perform storage functions, such as the one below
$storage->setClientDetails($client_id, $client_secret, $redirect_uri);
```

>

## Usage

The PDO storage engine implements all the standard Storage Interfaces supported
in this library.  See [interfaces](../custom) for more information.
