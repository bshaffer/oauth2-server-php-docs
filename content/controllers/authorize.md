---
title: Authorize Controller | OAuth2 Server PHP
---

# Authorize Controller

## Overview

For the Authorize Endpoint, which requires the user to authenticate and redirects back to the client with an `authorization code` ([Authorization Code](../../grant-types/authorization-code) grant type)
or `access token` ([Implicit](../../grant-types/implicit) grant type).

## Methods

`handleAuthorizeRequest`

  * Receives a request object for an authorize request, returns a response object with the appropriate response

`validateAuthorizeRequest`

  * Receives a request object, returns false if the incoming request is not a valid Authorize Request. If the request
is valid, returns an array of retrieved client details together with input.
Applications should call this before displaying a login or authorization form to the user
