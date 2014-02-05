---
title: Using Multiple Storages | OAuth2 Server PHP
---

# Using Multiple Storages

Each storage object that comes with this library can be used for almost
every type of storage. However, you may want to use different kinds of
stores for different things. For instance, what if you want to store
your clients in `MySQL`, your access tokens in `MongoDB`, and your scopes
in `Memory`?

```text
  clients       --->   ||MySQL Database||

  access tokens --->   {{   MongoDB    }}

  scopes        --->   ((   Memory     ))
```

This is no problem! You just need to specify each storage individually
when you create your OAuth2 server object.  First create your storage
objects:

```php
// instantiate all your storage objects
$clientStorage = new OAuth2\Storage\PDO(array(
    'dsn' => 'mysql:host=localhost;dbname=test',
    'username' => $user,
    'password' => $pass
));

$tokenStorage  = new OAuth2\Storage\Mongo(array(
    'host' => 'localhost',
    'port' => 27017
));

$scopeStorage = new OAuth2\Storage\Memory(array(
    'supported_scopes' => array(
        'one-scope',
        'two-scope',
        'red-scope',
        'blue-scope',
    );
));
```

Once you've done this, create the OAuth server and pass the
storage objects in as an associative array, with their ids as
the key:

```php
// add your storage objects to the OAuth server
$server = new OAuth2\Server(array(
    'client_credentials' => $clientStorage,
    'access_token'       => $tokenStorage,
    'scope'              => $scopeStorage,
));
```

You can also add them after creation, if you so prefer:

```php
$server->addStorage($clientStorage, 'client_credentials');
$server->addStorage($tokenStorage, 'access_token');
$server->addStorage($scopeStorage, 'scope');
```

Because you specified the storage ids, the library
will only use these storages for the functions specified.

For a list of storages and their ids, scroll down to **Interfaces**
on [Custom Storage](../custom/).
