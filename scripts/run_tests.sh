#!/usr/bin/env bash

set -e -o -x errexit

# Determine who what why where
echo "Running on host: " `hostname`
ip a
whoami

pushd cookbooks/mailcow
bundle install
bundle exec kitchen test
popd
