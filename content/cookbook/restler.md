
---
title: Restler
---

# Download the latest copy from [features\html](https://github.com/Luracast/Restler.git)
```bash
$ git clone -b features/html https://github.com/Luracast/Restler.git
```
# Run `composer.phar install` to make sure you have:
** twig template library
** bshaffer's oauth2 libaray
# Make sure `public/examples/_014_oauth2_client/cache` and `public/examples/_015_oauth2_server/cache` have write permissions to create the compiled template files.
# Make sure `public/examples/_015_oauth2_server/OAuth2/db` has write permission, this is where `oauth.sqlite` file be created at run time.
# Set up a virtual host for `/path/to/Restler/public`.
# Point your browser to `examples/_014_oauth2_client` to play around.