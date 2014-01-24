# Controllers

> ...an end-user (resource owner) can grant a printing
> service (client) access to her protected photos stored at a photo
> sharing service (resource server), without sharing her username and
> password with the printing service.  Instead, she authenticates
> directly with a server trusted by the photo sharing service
> (authorization server), which issues the printing service delegation-
> specific credentials (access token).
>
>   ~ OAuth2 ([draft #31](http://tools.ietf.org/html/rfc6749#section-1))

Most OAuth2 APIs will have endpoints for `Authorize Requests`, `Token Requests`, and `Resource Requests`.  The `OAuth2\Server` object has methods to handle each of these requests.

Each controller below corresponds to the endpoint by the same name.

 * [Authorize Controller](../../controllers/authorize/)
 * [Resource Controller](../../controllers/resource/)
 * [Token Controller](../../controllers/token/)