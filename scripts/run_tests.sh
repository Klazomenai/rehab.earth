#!/usr/bin/env bash

set -e -o errexit

pushd cookbooks/mailcow
bundle install

# Adding temporary debug diagnostics.
kitchen diagnose --all

bundle exec kitchen test
popd
