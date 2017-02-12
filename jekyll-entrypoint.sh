#!/bin/bash
set -e

cd /var/www/html/

echo ">>>>>> " $GIT_REPO
git clone $GIT_REPO .

ls -l

if [ -e /var/www/html/Gemfile ]
then
  bundle install
  bundle exec jekyll build
else
  jekyll build
fi
exec "$@"

