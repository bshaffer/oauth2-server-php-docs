#!/bin/bash
set -e # exit with nonzero exit code if anything fails

# COMPILE SCRIPT

if [ "$TRAVIS_REPO_SLUG" = "bshaffer/oauth2-server-php-docs" ]; then
    # generate the html
    bundle exec nanoc compile
    cd output

    # Publish the changes
    if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
        # create a *new* Git repo
        git init
        # inside this git repo we'll pretend to be a new user
        git config user.name "Travis CI"
        git config user.email "bshafs@gmail.com"

        # The first and only commit to this new Git repo contains all the
        # files present with the commit message "Deploy to GitHub Pages".
        git add .
        git commit -m "Deploy to GitHub Pages"

        # Force push from the current repo's master branch to the remote
        # repo's gh-pages branch. (All previous history on the gh-pages branch
        # will be lost, since we are overwriting it.) We redirect any output to
        # /dev/null to hide any sensitive credential data that might otherwise be exposed.
        git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:gh-pages > /dev/null 2>&1
    # Stage the changes
    elif [ "$TRAVIS_PULL_REQUEST_SLUG" = "bshaffer/oauth2-server-php-docs" ]; then
        # push the staging data to our staging bucket
        gsutil -m rm -r gs://$GOOGLE_CLOUD_BUCKET/oauth2-server-php-docs-staging || true
        gsutil -m cp -r . gs://$GOOGLE_CLOUD_BUCKET/oauth2-server-php-docs-staging
        gsutil -m acl -r ch -u AllUsers:R gs://$GOOGLE_CLOUD_BUCKET/oauth2-server-php-docs-staging
        echo ""
        echo "Build successful! These changes are available at"
        echo ""
        echo "  https://storage.googleapis.com/$GOOGLE_CLOUD_BUCKET/oauth2-server-php-docs-staging/index.html"
    else
        echo "Staging is not possible for outside repositories."
    fi
fi