#!/usr/bin/env bash

set -o -x errexit

pushd ../cookbooks/mailcow
bundle install
bundle exec kitchen test
popd
