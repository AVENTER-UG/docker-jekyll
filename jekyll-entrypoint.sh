#!/bin/bash
set -e

if [ -e /target ]
then
  rm -r /target
fi

mkdir /target

cd /target

echo ">>>>>> " $GIT_REPO
git clone $GIT_REPO .

ls -l

if [ -e /target/Gemfile ]
then
  bundle install
  bundle exec $@
else
  exec "$@"
fi


