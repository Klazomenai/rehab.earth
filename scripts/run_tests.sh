#!/usr/bin/env bash

set -e -o -x errexit

echo "Running on host: " `hostname`
pushd cookbooks/mailcow
bundle install
bundle exec kitchen test
popd
