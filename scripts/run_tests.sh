#!/usr/bin/env bash

set -e -o -x errexit

pushd cookbooks/mailcow
bundle install
bundle exec kitchen test
popd

echo "Testing env vars: " $VAULT_ADDR
