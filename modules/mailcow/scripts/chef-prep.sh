#!/bin/bash

# Until there is a chef-client --local provisioner for terraform, need to do things
# the bash way.

# Because 'activesupport requires Ruby version >= 2.2.2.'
echo Prepping env...
yum -y install gcc-c++ patch readline readline-devel zlib zlib-devel
yum -y install libyaml-devel libffi-devel openssl-devel make
yum -y install bzip2 autoconf automake libtool bison iconv-devel sqlite-devel
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
echo DDDEBUG
echo $rvm_path
rvm reload
rvm requirements run
rvm install ruby-2.3.3
rvm use 2.3.3 --default
gem install bundler

# Chef + Dependencies
curl -L https://omnitruck.chef.io/install.sh | sudo bash
yum install -y git
cd && git clone https://github.com/Klazomenai/rehab.earth.git
cd ~/rehab.earth
bundle install
berks vendor cookbooks/
chef-client --local --override-runlist recipe['mailcow']
