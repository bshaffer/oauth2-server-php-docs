
---
title: Restler
---

# download the latest copy from [features\html](https://github.com/Luracast/Restler.git)
```bash
$ git clone -b features/html https://github.com/Luracast/Restler.git
```
# run `composer.phar install` to make sure you have:
** twig template library
** bshaffer's oauth2 libaray
# make sure `public/examples/_014_oauth2_client/cache` and `public/examples/_015_oauth2_server/cache` have write permissions to create the compiled template files
# make sure `public/examples/_015_oauth2_server/OAuth2/db` has write permission, this is where oauth.sqlite file be created at run time
# Set up a virtual host for Restler/public
# point your browser to `examples/_014_oauth2_client` to play around