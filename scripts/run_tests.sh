#!/usr/bin/env bash

set -e -o errexit

echo "Hostname:" `hostname`

pushd cookbooks/mailcow
bundle install

# Adding temporary debug diagnostics.
kitchen diagnose --no-instances --loader

#bundle exec kitchen test
popd
