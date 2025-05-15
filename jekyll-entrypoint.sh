#!/bin/bash
set -e

cd /var/www/html/

git clone $GIT_REPO .

chown -R jekyll: .

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
  bundle install --jobs 8
  bundle exec jekyll build --trace
else
  jekyll build --trace
fi

if [ -e /var/www/html/_site/.git ]
then
  rm -rf /var/www/html/_site/.git
fi

envsubst \$av_logging < /tmp/nginx.conf.ini > /etc/nginx/nginx.conf

exec "$@"

