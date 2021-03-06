#!/usr/bin/env bash

set -e -o errexit

PROJECT_BRANCH=$1

# Until there is a chef-client --local provisioner for terraform, need to do things
# the bash way.

# Because 'activesupport requires Ruby version >= 2.2.2.'
# Apparently there is a better way than installing all the things on the node,
# investiage tarring up post 'berks vendor' and use Terraform to transfer the tar.
yum -y install gcc-c++ patch readline readline-devel zlib zlib-devel
yum -y install libyaml-devel libffi-devel openssl-devel make
yum -y install bzip2 autoconf automake libtool bison iconv-devel sqlite-devel
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm reload
rvm requirements run
rvm install ruby-2.3.3
rvm use 2.3.3 --default
gem install bundler

# Chef + Dependencies
curl -L https://omnitruck.chef.io/install.sh | sudo bash
pushd ~
git clone --depth 1 --branch $PROJECT_BRANCH https://github.com/Klazomenai/rehab.earth.git
pushd ~/rehab.earth
bundle install
berks vendor cookbooks/
popd
popd
