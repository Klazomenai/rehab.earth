#!/usr/bin/env bash

set -e -o -x errexit

# Script called by Terraform to do all the things just like we used to in the 90s.
# Things must go in Chef!

#
# Pre-reqs
#
yum install -y git

#
# Pull off git
#
pushd ~
git clone --depth 1 https://github.com/Klazomenai/rehab.earth.git
popd

#
# Docker
#
yum install -y docker
systemctl start docker
sudo systemctl enable docker
curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#
# Vault
#
pushd ~/rehab.earth/docker/vault
docker-compose build
docker-compose up -d
popd

#
# Consul
#
pushd ~/rehab.earth/docker/consul
docker-compose up -d
popd

#
# Concourse
#
pushd ~/rehab.earth/docker/concourse
mkdir -p keys/web keys/worker
ssh-keygen -t rsa -f ./keys/web/tsa_host_key -N ''
ssh-keygen -t rsa -f ./keys/web/session_signing_key -N ''
ssh-keygen -t rsa -f ./keys/worker/worker_key -N ''
cp ./keys/worker/worker_key.pub ./keys/web/authorized_worker_keys
cp ./keys/web/tsa_host_key.pub ./keys/worker
docker-compose up -d
popd
# Fly for Concourse
wget -O fly -q https://github.com/concourse/concourse/releases/download/v2.7.0/fly_linux_amd64
mv fly /usr/local/bin/fly
chmod u+x /usr/local/bin/fly
# Looks like concourse needs a little sleep before it wakes up, this sleep needs sorting properly
sleep 20
# The start of the beginning and the end of bootstrap
# Starting to really need Vault!
fly --target lite login --concourse-url http://bootstrap:8080 --username=concourse --password=changeme
fly --target lite set-pipeline --non-interactive --pipeline infra --config ~/rehab.earth/ci/pipeline.yml
fly --target lite unpause-pipeline --pipeline infra
