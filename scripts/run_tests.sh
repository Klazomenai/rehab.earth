#!/usr/bin/env bash

set -e -o errexit

pushd cookbooks/mailcow
bundle install
bundle exec kitchen test
popd
