#!/bin/bash
set -e

cd /var/www/html/

git clone $GIT_REPO .

if [ -n "$GIT_BRANCH" ]
then
  git checkout $GIT_BRANCH
fi

if [ -n "$GIT_TAG" ]
then
  git checkout tags/$GIT_TAG
fi

if [ -e /var/www/html/Gemfile ]
then
  bundle install
  bundle exec jekyll build
else
  jekyll build
fi
exec "$@"

