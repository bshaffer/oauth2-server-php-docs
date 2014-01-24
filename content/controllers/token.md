---
title: Token Controller | OAuth2 Server PHP
---

# Token Controller

## Overview

For the Token Endpoint, which uses the configured [Grant Types](../../overview/grant-types) to return  an `access token`
to the client.

## Methods

`grantAccessToken`

  * Receives a request object for a token request, returns a token if the request is valid.

`handleTokenRequest`

  * Receives a request object for a token request, returns a response object for the appropriate response.
