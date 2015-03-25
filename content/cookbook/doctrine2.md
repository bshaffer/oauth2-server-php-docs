---
title: Doctrine 2
---

# Doctrine 2

Create Client and Access Token Storage
---------------------------------------

To integrate doctrine into your project, first set up your entities. Let's start with just the Client, User and Access Token models:

```yaml

YourNamespace\Entity\OauthClient:
  type:             entity
  table:            oauth_clients
  repositoryClass:  YourNamespace\Repository\OauthClientRepository
  id:
    id:
      type:   integer
      generator:
        strategy: AUTO
  fields:
    client_identifier:
      type:       string
      max_length: 50
      unique:     true
    client_secret:
      type:       string
      max_length: 20
    redirect_uri:
      type:       string
      max_length: 255
      default:    ""

YourNamespace\Entity\OauthUser:
  type: entity
  table: oauth_users
  repositoryClass:  YourNamespace\Repository\OauthUserRepository
  id:
    id:
      type:   integer
      generator:
        strategy: AUTO
  fields:
    email:
      type:   string
      unique: true
    password:
      type:   string
  indexes:
    email_index:
      columns: [ email ]

YourNamespace\Entity\OauthAccessToken:
  type:             entity
  table:            oauth_access_tokens
  repositoryClass:  YourNamespace\Repository\OauthAccessTokenRepository
  id:
    id:
      type:   integer
      generator:
        strategy: AUTO
  fields:
    token:
      type:       string
      max_length: 40
      unique:     true
    client_id:
      type:       integer
    user_id:
      type:       integer
      nullable:   true
    expires:
      type:       datetime
    scope:
      type:       string
      max_length: 50
      nullable:   true
  manyToOne:
    client:
      targetEntity: YourNamespace\Entity\OauthClient
      joinColumn:
        name:                 client_id
        referencedColumnName: id
    user:
      targetEntity: YourNamespace\Entity\OauthUser
      joinColumn:
        name:                 user_id
        referencedColumnName: id
```

Once you've generated the entities from this schema, you will have an `OauthClient` and `OauthClientRepository`, `OauthUser` and `OauthUserRepository`, as well as an `OauthAccessToken` and `OauthAccessTokenRepository` files.

Just for the reference, here's are how the entities should look:

```php
namespace YourNamespace\Entity;

/**
 * OauthClient
 * @entity(repositoryClass="YourNamespace\Repository\OauthClientRepository")
 */
class OauthClient extends EncryptableFieldEntity
{
    /**
     * @var integer
     */
    private $id;

    /**
     * @var string
     */
    private $client_identifier;

    /**
     * @var string
     */
    private $client_secret;

    /**
     * @var string
     */
    private $redirect_uri = '';

    /**
     * Get id
     *
     * @return integer 
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set client_identifier
     *
     * @param string $clientIdentifier
     * @return OauthClient
     */
    public function setClientIdentifier($clientIdentifier)
    {
        $this->client_identifier = $clientIdentifier;
        return $this;
    }

    /**
     * Get client_identifier
     *
     * @return string 
     */
    public function getClientIdentifier()
    {
        return $this->client_identifier;
    }

    /**
     * Set client_secret
     *
     * @param string $clientSecret
     * @return OauthClient
     */
    public function setClientSecret($clientSecret)
    {
        $this->client_secret = $this->encryptField($clientSecret);
        return $this;
    }

    /**
     * Get client_secret
     *
     * @return string 
     */
    public function getClientSecret()
    {
        return $this->client_secret;
    }

    /**
     * Verify client's secret
     *
     * @param string $password
     * @return Boolean
     */
    public function verifyClientSecret($clientSecret)
    {
        return $this->verifyEncryptedFieldValue($this->getClientSecret(), $clientSecret);
    }

    /**
     * Set redirect_uri
     *
     * @param string $redirectUri
     * @return OauthClient
     */
    public function setRedirectUri($redirectUri)
    {
        $this->redirect_uri = $redirectUri;
        return $this;
    }

    /**
     * Get redirect_uri
     *
     * @return string 
     */
    public function getRedirectUri()
    {
        return $this->redirect_uri;
    }

    public function toArray()
    {
        return [
            'client_id' => $this->client_identifier,
            'client_secret' => $this->client_secret,
            'redirect_uri' => $this->redirect_uri,
        ];
    }
}
```

```php
namespace YourNamespace\Entity;

/**
 * OauthUser
 * @entity(repositoryClass="YourNamespace\Repository\OauthUserRepository")
 */
class OauthUser extends EncryptableFieldEntity
{
    /**
     * @var integer
     */
    private $id;

    /**
     * @var string
     */
    private $email;

    /**
     * @var string
     */
    private $password;

    /**
     * Get id
     *
     * @return integer 
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set email
     *
     * @param string $email
     * @return User
     */
    public function setEmail($email)
    {
        $this->email = $email;
        return $this;
    }

    /**
     * Get email
     *
     * @return string 
     */
    public function getEmail()
    {
        return $this->email;
    }

    /**
     * Set password
     *
     * @param string $password
     * @return User
     */
    public function setPassword($password)
    {
        $this->password = $this->encryptField($password);
        return $this;
    }

    /**
     * Get password
     *
     * @return string 
     */
    public function getPassword()
    {
        return $this->password;
    }

    /**
     * Verify user's password
     *
     * @param string $password
     * @return Boolean
     */
    public function verifyPassword($password)
    {
        return $this->verifyEncryptedFieldValue($this->getPassword(), $password);
    }

    public function toArray()
    {
        return [
            'user_id' => $this->id,
            'scope' => null,
        ];
    }
}
```

```php
namespace YourNamespace\Entity;

/**
 * OauthAccessToken
 */
class OauthAccessToken
{
    /**
     * @var integer
     */
    private $id;

    /**
     * @var string
     */
    private $token;

    /**
     * @var string
     */
    private $client_id;

    /**
     * @var string
     */
    private $user_id;

    /**
     * @var \DateTime
     */
    private $expires;

    /**
     * @var string
     */
    private $scope;

    /**
     * @var \YourNamespace\Entity\OauthClient
     */
    private $client;

    /**
     * @var \YourNamespace\Entity\OauthUser
     */
    private $user;

    /**
     * Get id
     *
     * @return integer 
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set token
     *
     * @param string $token
     * @return OauthAccessToken
     */
    public function setToken($token)
    {
        $this->token = $token;
        return $this;
    }

    /**
     * Get token
     *
     * @return string 
     */
    public function getToken()
    {
        return $this->token;
    }

    /**
     * Set client_id
     *
     * @param string $clientId
     * @return OauthAccessToken
     */
    public function setClientId($clientId)
    {
        $this->client_id = $clientId;
        return $this;
    }

    /**
     * Get client_id
     *
     * @return string 
     */
    public function getClientId()
    {
        return $this->client_id;
    }

    /**
     * Set user_id
     *
     * @param string $userIdentifier
     * @return OauthAccessToken
     */
    public function setUserId($userId)
    {
        $this->user_id = $userId;
        return $this;
    }

    /**
     * Get user_identifier
     *
     * @return string 
     */
    public function getUserId()
    {
        return $this->user_id;
    }

    /**
     * Set expires
     *
     * @param \DateTime $expires
     * @return OauthAccessToken
     */
    public function setExpires($expires)
    {
        $this->expires = $expires;
        return $this;
    }

    /**
     * Get expires
     *
     * @return \DateTime 
     */
    public function getExpires()
    {
        return $this->expires;
    }

    /**
     * Set scope
     *
     * @param string $scope
     * @return OauthAccessToken
     */
    public function setScope($scope)
    {
        $this->scope = $scope;
        return $this;
    }

    /**
     * Get scope
     *
     * @return string 
     */
    public function getScope()
    {
        return $this->scope;
    }

    /**
     * Set client
     *
     * @param \YourNamespace\Entity\OauthClient $client
     * @return OauthAccessToken
     */
    public function setClient(\YourNamespace\Entity\OauthClient $client = null)
    {
        $this->client = $client;
        return $this;
    }

    /**
     * Get client
     *
     * @return \YourNamespace\Entity\OauthClient 
     */
    public function getClient()
    {
        return $this->client;
    }

    public static function fromArray($params)
    {
        $token = new self();
        foreach ($params as $property => $value) {
            $token->$property = $value;
        }
        return $token;
    }

    /**
     * Set user
     *
     * @param \YourNamespace\Entity\OauthUser $user
     * @return OauthRefreshToken
     */
    public function setUser(\YourNamespace\Entity\OauthUser $user = null)
    {
        $this->user = $user;
        return $this;
    }

    /**
     * Get user
     *
     * @return \YourNamespace\Entity\OauthUser 
     */
    public function getUser()
    {
        return $this->client;
    }

    public function toArray()
    {
        return [
            'token' => $this->token,
            'client_id' => $this->client_id,
            'user_id' => $this->user_id,
            'expires' => $this->expires,
            'scope' => $this->scope,
        ];
    }
}
```

I have also created EncryptableEntity class which abstract encryption of sensitive data (client's secret and user's password):

```php
namespace YourNamespace\Entity;

class EncryptableFieldEntity
{
    protected $hashOptions = ['cost' => 11];

    protected function encryptField($value)
    {
        return password_hash(
            $value, PASSWORD_BCRYPT, $this->hashOptions);
    }

    protected function verifyEncryptedFieldValue($encryptedValue, $value)
    {
        return password_verify($value, $encryptedValue);
    }
}
```

Implement `OAuth2\Storage\ClientCredentialsInterface` on the `OAuthClientRepository` class:

```php
namespace YourNamespace\Repository;

use Doctrine\ORM\EntityRepository;
use OAuth2\Storage\ClientCredentialsInterface;

class OauthClientRepository extends EntityRepository implements ClientCredentialsInterface
{
    public function getClientDetails($clientIdentifier)
    {
        $client = $client = $this->findOneBy(['client_identifier' => $clientIdentifier]);
        if ($client) {
            $client = $client->toArray();
        }
        return $client;
    }

    public function checkClientCredentials($clientIdentifier, $clientSecret = NULL)
    {
        $client = $client = $this->findOneBy(['client_identifier' => $clientIdentifier]);
        if ($client) {
            return $client->verifyClientSecret($clientSecret);
        }
        return false;
    }

    public function checkRestrictedGrantType($clientId, $grantType)
    {
        // we do not support different grant types per client in this example
        return true;
    }

    public function isPublicClient($clientId)
    {
        return false;
    }

    public function getClientScope($clientId)
    {
        return null;
    }
}
```

Now implement `OAuth2\Storage\UserCredentialsInterface` on the `OauthUser` class:

```php

namespace YourNamespace\Repository;
use Doctrine\ORM\EntityRepository;
use OAuth2\Storage\UserCredentialsInterface;

class OauthUserRepository extends EntityRepository implements UserCredentialsInterface
{
    public function checkUserCredentials($email, $password)
    {
        $user = $this->findOneBy(['email' => $email]);
        if ($user) {
            return $user->verifyPassword($password);
        }
        return false;
    }

    /**
     * @return
     * ARRAY the associated "user_id" and optional "scope" values
     * This function MUST return FALSE if the requested user does not exist or is
     * invalid. "scope" is a space-separated list of restricted scopes.
     * @code
     * return array(
     *     "user_id"  => USER_ID,    // REQUIRED user_id to be stored with the authorization code or access token
     *     "scope"    => SCOPE       // OPTIONAL space-separated list of restricted scopes
     * );
     * @endcode
     */
    public function getUserDetails($email)
    {
        $user = $this->findOneBy(['email' => $email]);
        if ($user) {
            $user = $user->toArray();
        }
        return $user;
    }
}
```

Now implement `OAuth2\Storage\AccessTokenInterface` on the `OauthAccessTokenTable` class:

```php
namespace YourNamespace\Repository;

use Doctrine\ORM\EntityRepository;
use YourNamespace\Entity\OAuthAccessToken;
use OAuth2\Storage\AccessTokenInterface;

class OauthAccessTokenRepository extends EntityRepository implements AccessTokenInterface
{
    public function getAccessToken($oauthToken)
    {
        $token = $this->findOneBy(['token' => $oauthToken]);
        if ($token) {
            $token = $token->toArray();
            $token['expires'] = $token['expires']->getTimestamp();
        }
        return $token;
    }

    public function setAccessToken($oauthToken, $clientIdentifier, $userEmail, $expires, $scope = null)
    {
        $client = $this->_em->getRepository('YourNamespace\Entity\OauthClient')
                            ->findOneBy(['client_identifier' => $clientIdentifier]);
        $user = $this->_em->getRepository('YourNamespace\Entity\OauthUser')
                            ->findOneBy(['email' => $userEmail]);
        $token = OAuthAccessToken::fromArray([
            'token'     => $oauthToken,
            'client'    => $client,
            'user'      => $user,
            'expires'   => (new \DateTime())->setTimestamp($expires),
            'scope'     => $scope,
        ]);
        $this->_em->persist($token);
        $this->_em->flush();
    }
}
```

Good job!  Now, when you create your `OAuth\Server` object, pass these tables in:

```php
$clientStorage  = $entityManager->getRepository('YourNamespace\Entity\OauthClient');
$userStorage = $entityManager->getRepository('YourNamespace\Entity\OauthUser');
$accessTokenStorage = $entityManager->getRepository('YourNamespace\Entity\OauthAccessToken');

// Pass the doctrine storage objects to the OAuth2 server class
$server = new \OAuth2\Server([
	'client_credentials' => $clientStorage,
	'user_credentials'   => $userStorage,
    'access_token'       => $accessTokenStorage,
], [
	'auth_code_lifetime' => 30,
    'refresh_token_lifetime' => 30,
]);
```

You've done it!  You've integrated your server with Doctrine!  You can go to town using it, but
since you've only passed it a `client_credentials` and `access_token` storage object, you can only
use the `client_credentials` and `user_credentials` grant types:


```php
// will be able to handle token requests when "grant_type=client_credentials".
$server->addGrantType(new OAuth2\GrantType\ClientCredentials($clientStorage));

// will be able to handle token requests when "grant_type=password".
$server->addGrantType(new \OAuth2\GrantType\UserCredentials($userStorage));

// handle the request
$server->handleTokenRequest(OAuth2\Request::createFromGlobals())->send();
```

Add Authorization Code and Refresh Token Storage
------------------------------------------------

So lets make our application a little more exciting.  Add the following to your schema and
generate additional entities:

```yaml
YourNamespace\Entity\OauthAuthorizationCode:
  type:             entity
  table:            oauth_authorization_codes
  repositoryClass:  YourNamespace\Repository\OauthAuthorizationCodeRepository
  id:
    id:
      type:   integer
      generator:
        strategy: AUTO
  fields:
    code:
      type:       string
      max_length: 40
      unique:     true
    client_id:
      type:       integer
    user_id:
      type:       integer
      nullable:   true
    expires:
      type:       datetime
    redirect_uri:
      type:       string
      max_length: 200
    scope:
      type:       string
      max_length: 50
      nullable:   true
  manyToOne:
    client:
      targetEntity: YourNamespace\Entity\OauthClient
      joinColumn:
        name:                 client_id
        referencedColumnName: id
    user:
      targetEntity: YourNamespace\Entity\OauthUser
      joinColumn:
        name:                 user_id
        referencedColumnName: id

YourNamespace\Entity\OauthRefreshToken:
  type:             entity
  table:            oauth_refresh_tokens
  repositoryClass:  YourNamespace\Repository\OauthRefreshTokenRepository
  id:
    id:
      type:   integer
      generator:
        strategy: AUTO
  fields:
    refresh_token:
      refresh_token:  string
      max_length:     40
      unique:         true
    client_id:
      type:       integer
    user_id:
      type:       integer
      nullable:   true
    expires:
      type:       datetime
    scope:
      type:       string
      max_length: 50
      nullable:   true
  manyToOne:
    client:
      targetEntity: YourNamespace\Entity\OauthClient
      joinColumn:
        name:                 client_id
        referencedColumnName: id
    user:
      targetEntity: YourNamespace\Entity\OauthUser
      joinColumn:
        name:                 user_id
        referencedColumnName: id
```

Just for the reference, here's how the entities should look:

```php
namespace YourNamespace\Entity;

/**
 * OauthAuthorizationCode
 */
class OauthAuthorizationCode
{
    /**
     * @var integer
     */
    private $id;

    /**
     * @var string
     */
    private $code;

    /**
     * @var string
     */
    private $client_id;

    /**
     * @var string
     */
    private $user_id;

    /**
     * @var \DateTime
     */
    private $expires;

    /**
     * @var string
     */
    private $redirect_uri;

    /**
     * @var string
     */
    private $scope;

    /**
     * @var \YourNamespace\Entity\OauthClient
     */
    private $client;

    /**
     * @var \YourNamespace\Entity\OauthUser
     */
    private $user;

    /**
     * Get id
     *
     * @return integer 
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set code
     *
     * @param string $code
     * @return OauthAuthorizationCode
     */
    public function setCode($code)
    {
        $this->code = $code;

        return $this;
    }

    /**
     * Get code
     *
     * @return string 
     */
    public function getCode()
    {
        return $this->code;
    }

    /**
     * Set client_id
     *
     * @param string $clientId
     * @return OauthAuthorizationCode
     */
    public function setClientId($clientId)
    {
        $this->client_id = $clientId;

        return $this;
    }

    /**
     * Get client_id
     *
     * @return string 
     */
    public function getClientId()
    {
        return $this->client_id;
    }

    /**
     * Set user_id
     *
     * @param string $userIdentifier
     * @return OauthAuthorizationCode
     */
    public function setUserId($userId)
    {
        $this->user_id = $userId;

        return $this;
    }

    /**
     * Get user_identifier
     *
     * @return string 
     */
    public function getUserId()
    {
        return $this->user_id;
    }

    /**
     * Set expires
     *
     * @param \DateTime $expires
     * @return OauthAuthorizationCode
     */
    public function setExpires($expires)
    {
        $this->expires = $expires;

        return $this;
    }

    /**
     * Get expires
     *
     * @return \DateTime 
     */
    public function getExpires()
    {
        return $this->expires;
    }

    /**
     * Set redirect_uri
     *
     * @param string $redirectUri
     * @return OauthAuthorizationCode
     */
    public function setRedirectUri($redirectUri)
    {
        $this->redirect_uri = $redirectUri;

        return $this;
    }

    /**
     * Get redirect_uri
     *
     * @return string 
     */
    public function getRedirectUri()
    {
        return $this->redirect_uri;
    }

    /**
     * Set scope
     *
     * @param string $scope
     * @return OauthAuthorizationCode
     */
    public function setScope($scope)
    {
        $this->scope = $scope;

        return $this;
    }

    /**
     * Get scope
     *
     * @return string 
     */
    public function getScope()
    {
        return $this->scope;
    }

    /**
     * Set client
     *
     * @param \YourNamespace\Entity\OauthClient $client
     * @return OauthAuthorizationCode
     */
    public function setClient(\YourNamespace\Entity\OauthClient $client = null)
    {
        $this->client = $client;

        return $this;
    }

    /**
     * Get client
     *
     * @return \YourNamespace\Entity\OauthClient 
     */
    public function getClient()
    {
        return $this->client;
    }

    /**
     * Set user
     *
     * @param \YourNamespace\Entity\OauthUser $user
     * @return OauthRefreshToken
     */
    public function setUser(\YourNamespace\Entity\OauthUser $user = null)
    {
        $this->user = $user;

        return $this;
    }

    /**
     * Get user
     *
     * @return \YourNamespace\Entity\OauthUser 
     */
    public function getUser()
    {
        return $this->client;
    }

    public function toArray()
    {
        return [
            'code' => $this->code,
            'client_id' => $this->client_id,
            'user_id' => $this->user_id,
            'expires' => $this->expires,
            'scope' => $this->scope,
        ];
    }

    public static function fromArray($params)
    {
        $code = new self();
        foreach ($params as $property => $value) {
            $code->$property = $value;
        }
        return $code;
    }
}
```

```php
namespace YourNamespace\Entity;

/**
 * OauthRefreshToken
 * @entity(repositoryClass="YourNamespace\Repository\OauthRefreshTokenRepository")
 */
class OauthRefreshToken
{
    /**
     * @var integer
     */
    private $id;

    /**
     * @var string
     */
    private $refresh_token;

    /**
     * @var string
     */
    private $client_id;

    /**
     * @var string
     */
    private $user_id;

    /**
     * @var \DateTime
     */
    private $expires;

    /**
     * @var string
     */
    private $scope;

    /**
     * @var \YourNamespace\Entity\OauthClient
     */
    private $client;

    /**
     * @var \YourNamespace\Entity\OauthUser
     */
    private $user;

    /**
     * Get id
     *
     * @return integer 
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set refresh_token
     *
     * @param string $refresh_token
     * @return OauthRefreshToken
     */
    public function setRefreshToken($refresh_token)
    {
        $this->refresh_token = $refresh_token;

        return $this;
    }

    /**
     * Get refresh_token
     *
     * @return string 
     */
    public function getRefreshToken()
    {
        return $this->refresh_token;
    }

    /**
     * Set client_id
     *
     * @param string $clientId
     * @return OauthRefreshToken
     */
    public function setClientId($clientId)
    {
        $this->client_id = $clientId;

        return $this;
    }

    /**
     * Get client_id
     *
     * @return string 
     */
    public function getClientId()
    {
        return $this->client_id;
    }

    /**
     * Set user_id
     *
     * @param string $userIdentifier
     * @return OauthRefreshToken
     */
    public function setUserId($userId)
    {
        $this->user_id = $userId;

        return $this;
    }

    /**
     * Get user_identifier
     *
     * @return string 
     */
    public function getUserId()
    {
        return $this->user_id;
    }

    /**
     * Set expires
     *
     * @param \DateTime $expires
     * @return OauthRefreshToken
     */
    public function setExpires($expires)
    {
        $this->expires = $expires;

        return $this;
    }

    /**
     * Get expires
     *
     * @return \DateTime 
     */
    public function getExpires()
    {
        return $this->expires;
    }

    /**
     * Set scope
     *
     * @param string $scope
     * @return OauthRefreshToken
     */
    public function setScope($scope)
    {
        $this->scope = $scope;

        return $this;
    }

    /**
     * Get scope
     *
     * @return string 
     */
    public function getScope()
    {
        return $this->scope;
    }

    /**
     * Set client
     *
     * @param \YourNamespace\Entity\OauthClient $client
     * @return OauthRefreshToken
     */
    public function setClient(\YourNamespace\Entity\OauthClient $client = null)
    {
        $this->client = $client;

        return $this;
    }

    /**
     * Get client
     *
     * @return \YourNamespace\Entity\OauthClient 
     */
    public function getClient()
    {
        return $this->client;
    }

    /**
     * Set user
     *
     * @param \YourNamespace\Entity\OauthUser $user
     * @return OauthRefreshToken
     */
    public function setUser(\YourNamespace\Entity\OauthUser $user = null)
    {
        $this->user = $user;

        return $this;
    }

    /**
     * Get user
     *
     * @return \YourNamespace\Entity\OauthUser 
     */
    public function getUser()
    {
        return $this->client;
    }

    public function toArray()
    {
        return [
            'refresh_token' => $this->refresh_token,
            'client_id' => $this->client_id,
            'user_id' => $this->user_id,
            'expires' => $this->expires,
            'scope' => $this->scope,
        ];
    }

    public static function fromArray($params)
    {
        $token = new self();
        foreach ($params as $property => $value) {
            $token->$property = $value;
        }
        return $token;
    }
}
```

Now we can implement two more interfaces, `OAuth2\Storage\AuthorizationCodeInterface` and
`OAuth2\Storage\RefreshTokenInterface`.  This will allow us to use their correspoding grant
types as well.

Implement `OAuth2\Storage\AuthorizationCodeInterface` on the `OauthAuthorizationCodeRepository` class:


```php
namespace YourNamespace\Repository;

use Doctrine\ORM\EntityRepository;
use YourNamespace\Entity\OAuthAuthorizationCode;
use OAuth2\Storage\AuthorizationCodeInterface;

class OauthAuthorizationCodeRepository extends EntityRepository implements AuthorizationCodeInterface
{
    public function getAuthorizationCode($code)
    {
        $authCode = $this->findOneBy(['code' => $code]);
        if ($authCode) {
            $authCode = $authCode->toArray();
            $authCode['expires'] = $authCode['expires']->getTimestamp();
        }
        return $authCode;
    }

    public function setAuthorizationCode($code, $clientIdentifier, $userEmail, $redirectUri, $expires, $scope = null)
    {
        $client = $this->_em->getRepository('YourNamespace\Entity\OauthClient')
                            ->findOneBy(array('client_identifier' => $clientIdentifier));
        $user = $this->_em->getRepository('YourNamespace\Entity\OauthUser')
                            ->findOneBy(['email' => $userEmail]);
        $authCode = OAuthAuthorizationCode::fromArray([
           'code'           => $code,
           'client'         => $client,
           'user'           => $user,
           'redirect_uri'   => $redirectUri,
           'expires'        => (new \DateTime())->setTimestamp($expires),
           'scope'          => $scope,
        ]);
        $this->_em->persist($authCode);
        $this->_em->flush();
    }

    public function expireAuthorizationCode($code)
    {
        $authCode = $this->findOneBy(['code' => $code]);
        $this->_em->remove($authCode);
        $this->_em->flush();
    }
}
```

Implement `OAuth2\Storage\RefreshTokenInterface` on the `OauthRefreshTokenRepository` class:

```php
namespace YourNamespace\Repository;

use Doctrine\ORM\EntityRepository;
use YourNamespace\Entity\OAuthRefreshToken;
use OAuth2\Storage\RefreshTokenInterface;

class OauthRefreshTokenRepository extends EntityRepository implements RefreshTokenInterface
{
    public function getRefreshToken($refreshToken)
    {
        $refreshToken = $this->findOneBy(['refresh_token' => $refreshToken]);
        if ($refreshToken) {
            $refreshToken = $refreshToken->toArray();
            $refreshToken['expires'] = $refreshToken['expires']->getTimestamp();
        }
        return $refreshToken;
    }

    public function setRefreshToken($refreshToken, $clientIdentifier, $userEmail, $expires, $scope = null)
    {
        $client = $this->_em->getRepository('YourNamespace\Entity\OauthClient')
                            ->findOneBy(['client_identifier' => $clientIdentifier]);
        $user = $this->_em->getRepository('YourNamespace\Entity\OauthUser')
                            ->findOneBy(['email' => $userEmail]);
        $refreshToken = OAuthRefreshToken::fromArray([
           'refresh_token'  => $refreshToken,
           'client'         => $client,
           'user'           => $user,
           'expires'        => (new \DateTime())->setTimestamp($expires),
           'scope'          => $scope,
        ]);
        $this->_em->persist($refreshToken);
        $this->_em->flush();
    }

    public function unsetRefreshToken($refreshToken)
    {
        $refreshToken = $this->findOneBy(['refresh_token' => $refreshToken]);
        $this->_em->remove($refreshToken);
        $this->_em->flush();
    }
}
```

Now we can add two more grant types onto our server:

```php
$clientStorage  = $app['db.orm.em']->getRepository('YourNamespace\Entity\OauthClient');
$userStorage = $app['db.orm.em']->getRepository('YourNamespace\Entity\OauthUser');
$accessTokenStorage  = $app['db.orm.em']->getRepository('YourNamespace\Entity\OauthAccessToken');
$authorizationCodeStorage = $app['db.orm.em']->getRepository('YourNamespace\Entity\OauthAuthorizationCode');
$refreshTokenStorage = $app['db.orm.em']->getRepository('YourNamespace\Entity\OauthRefreshToken');

// Pass the doctrine storage objects to the OAuth2 server class
$server = new \OAuth2\Server([
	'client_credentials' => $clientStorage,
	'user_credentials'   => $userStorage,
    'access_token'       => $accessTokenStorage,
    'authorization_code' => $authorizationCodeStorage,
    'refresh_token'      => $refreshTokenStorage,
], [
	'auth_code_lifetime' => 30,
    'refresh_token_lifetime' => 30,
]);

$server->addGrantType(new OAuth2\GrantType\ClientCredentials($clientStorage));
$server->addGrantType(new OAuth2\GrantType\AuthorizationCode($codeStorage));
$server->addGrantType(new OAuth2\GrantType\RefreshToken($refreshStorage));

$server->addGrantType(new \OAuth2\GrantType\AuthorizationCode($authorizationCodeStorage));
$server->addGrantType(new \OAuth2\GrantType\RefreshToken($refreshTokenStorage, [
	// the refresh token grant request will have a "refresh_token" field
    // with a new refresh token on each request
    'always_issue_new_refresh_token' => true,
]));

// handle the request
$server->handleTokenRequest(OAuth2\Request::createFromGlobals())->send();
```

You've done it!!!

Few more things to consider:

- Although I have included the OauthUser entity and the user credentials grant is working, access tokens are not yet linked with users, you will have to implement this relationship based on your app.