---
title: Restler
---

# Restler

1. Download the latest copy from [features\html](https://github.com/Luracast/Restler.git)

        $ git clone -b features/html https://github.com/Luracast/Restler.git

2. Run `composer.phar install` to make sure you have:
    * twig template library
    * bshaffer's oauth2 libaray

3. Make sure the following directories have write permissions to create the compiled template files:
    * `public/examples/_014_oauth2_client/cache`
    * `public/examples/_015_oauth2_server/cache`

4. Make sure the following directory has write permissions. This is where `oauth.sqlite` file be created at run time:
    * `public/examples/_015_oauth2_server/OAuth2/db`

5. Set up a virtual host for `/path/to/Restler/public`.

6. Point your browser to `http://yourhost/examples/_014_oauth2_client` to play around.