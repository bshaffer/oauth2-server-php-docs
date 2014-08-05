---
title: Laravel
---

# Laravel

See this [Laravel demo application](https://github.com/julien-c/laravel-oauth2-server) for implementing this library in Laravel 4.

## Step-By-Step Walkthrough

1.  Create your Laravel project (e.g. `composer create-project laravel/laravel --prefer-dist`)
2.  Install the OAuth2 server and HTTPFoundation bridge dependencies using Composer: `composer require bshaffer/oauth2-server-php` and `composer require bshaffer/oauth2-server-httpfoundation-bridge`
3.  Setup your database and run the provided migration (see [https://github.com/julien-c/laravel-oauth2-server/commit/b290d4f699b9758696444e2d62dd82f0eeedcb7d](https://github.com/julien-c/laravel-oauth2-server/commit/b290d4f699b9758696444e2d62dd82f0eeedcb7d)): 
    
    `php artisan db:migrate`
    
4.  Seed your database using the provided script : [https://github.com/julien-c/laravel-oauth2-server/commit/8895c54cbf8ea8ba78aafab53a5a0409ce2f1ba2](https://github.com/julien-c/laravel-oauth2-server/commit/8895c54cbf8ea8ba78aafab53a5a0409ce2f1ba2)
    
    `php artisan db:seed`
    
5.  Setup your OAuth2 server. To be able to access the single instance anywhere in your Laravel app, you can attach it as a singleton:
        
```php
App::singleton('oauth2', function() {
    
    $storage = new OAuth2\Storage\Pdo(array('dsn' => 'mysql:dbname=oauth2;host=localhost', 'username' => 'root', 'password' => 'root'));
    $server = new OAuth2\Server($storage);
    
    $server->addGrantType(new OAuth2\GrantType\ClientCredentials($storage));
    $server->addGrantType(new OAuth2\GrantType\UserCredentials($storage));
    
    return $server;
});
```

6.  Implement the actual OAuth2 controllers you wish to implement. For example a token controller and a resource controller: see [`app/routes.php`](https://github.com/julien-c/laravel-oauth2-server/blob/master/app/routes.php)
    




You can even unit test your integration! Here's an example using Guzzle: [https://github.com/julien-c/laravel-oauth2-server/blob/master/app/tests/OAuthTest.php](https://github.com/julien-c/laravel-oauth2-server/blob/master/app/tests/OAuthTest.php)