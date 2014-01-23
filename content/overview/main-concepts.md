# Main Concepts

The library involves several main concepts:

  * [**Grant Types**](overview/grant-types): the OAuth2 Grant Types your server supports
  * **Storage Objects**: How the server interacts with your data layer. The following storages are included:
    * [PDO](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/Pdo.php)
    * [Redis](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/Redis.php)
    * [Mongo](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/Mongo.php)
    * [Cassandra](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/Cassandra.php)
    * [Doctrine Storage](../../cookbook/doctrine)
    * Custom Storage using the [Storage Interfaces](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Storage/AccessTokenInterface.php)
  * [**Controllers**](../controllers): The functions which take a `Request` object and return a `Response` object
    * [Token Controller](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Controller/TokenController.php)
    * [Authorize Controller](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Controller/AuthorizeController.php)
    * [Resource Controller](https://github.com/bshaffer/oauth2-server-php/blob/develop/src/OAuth2/Controller/ResourceController.php)
  * **Miscellaneous Concepts**
    * [Response Object](../response)
    * [Scope](../scope)
    * [User IDs](../userid)
    * [Crypto Tokens](../crypto-tokens)
