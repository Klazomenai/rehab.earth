#!/usr/bin/env bash

set -e -o -x errexit

echo "Testing env vars: " $VAULT_ADDR

pushd cookbooks/mailcow
bundle install
bundle exec kitchen test
popd

