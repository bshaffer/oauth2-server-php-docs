---
title: Dynamo DB | OAuth2 Server PHP
---

# DynamoDB

## Overview

Uses the [DynamoDB](http://aws.amazon.com/dynamodb/) NoSQL Database Service for storing and retrieving objects in OAuth.

## Installation

First, you will need to install the [Amazon Web Services PHP SDK](https://github.com/aws/aws-sdk-php)

```text
$ composer require aws/aws-sdk-php:dev-master
```

>

## Get Started

If you haven't already created an `~/.aws/credentials` file, this is the easiest way to get up and running with DynamoDB.


```php
// @see http://docs.aws.amazon.com/aws-sdk-php/guide/latest/credentials.html#credential-profiles
$config = array(
	'profile' => 'default',
	'region'  =>  Aws\Common\Enum\Region::US_EAST_1, // Your region may differ
);
```

Alternatively, you can configure your client to run directly with your credentials

```php
// These credentials are found in your AWS management console
$config = array(
	'key'	 => 'my-aws-key',
	'secret' => 'my-aws-secret',
	'region' => Aws\Common\Enum\Region::US_EAST_1, // Your region may differ
);
```

Next, instantiate the AWS client by creating your configuration array and using the `factory` method:

```php
$dynamo = Aws\DynamoDb\DynamoDbClient::factory($config);

```

Finally, create the storage object using the `DynamoDB` storage class:

```php
$storage = new OAuth2\Storage\DynamoDB($dynamo);

// now you can perform storage functions, such as the one below
$storage->setClientDetails($client_id, $client_secret, $redirect_uri);
```

> To see an example of the default table structure, check out the [`Bootstrap::createDynamoDB`](https://github.com/bshaffer/oauth2-server-php/blob/develop/test/lib/OAuth2/Storage/Bootstrap.php#L519) function in this library, or just create the tables yourself using DynamoDB's management UI.

## Usage

The DynamoDB storage engine implements all the standard Storage Interfaces supported
in this library.  See [interfaces](../custom) for more information.