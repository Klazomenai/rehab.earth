#!/usr/bin/env bash
#
# Script called by Terraform to do all the things (for Bootstrapping)
# just like we used to in the 90s. Things must go in Chef!
#

set -e -o

#
# Temporary test for mounting external volume for Geth
#
mkdir /tmp/ethereum

#
# Docker
#
yum install -y docker
systemctl start docker
sudo systemctl enable docker
curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod u+x /usr/local/bin/docker-compose
docker network create rehab.earth --ip-range=172.100.0.0/24 --gateway=172.100.0.1 --subnet=172.100.0.0/16

#
# Geth Node
#
pushd ~/rehab.earth/docker/geth-node
docker-compose build
docker-compose up -d
popd
