#!/usr/bin/env bash

set -e -o errexit

/usr/local/bin/vault

#pushd cookbooks/mailcow
#bundle install

# Adding temporary debug diagnostics.
#kitchen diagnose --no-instances --loader

#bundle exec kitchen test
popd
