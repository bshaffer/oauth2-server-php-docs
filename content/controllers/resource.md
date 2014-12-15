---
title: Resource Controller | OAuth2 Server PHP
---

# Resource Controller

## Overview

For any resource request (i.e. API Call) requiring oauth2 authentication.  The controller will validate the
incomming request, and then allow the application to serve back the protected resource.

## Methods

`verifyResourceRequest`

  * Receives a request object for a resource request, finds the token if it exists, and returns a Boolean for whether
the incomming request is valid

`getAccessTokenData`

  * Takes a request object as an argument and returns the token data if applicable, or null if the token is invalid