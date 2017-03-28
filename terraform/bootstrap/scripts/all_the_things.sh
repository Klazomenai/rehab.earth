#!/usr/bin/env bash
#
# Script called by Terraform to do all the things (for Bootstrapping)
# just like we used to in the 90s. Things must go in Chef!
#

set -e -o -x

#
# Env definitions
#
PROJECT_BRANCH=$1

#
# Pull off git, take branch as input for Terraform variables
#
pushd ~
git clone --depth 1 --branch $PROJECT_BRANCH https://github.com/Klazomenai/rehab.earth.git
popd

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
# Consul
#
pushd ~/rehab.earth/docker/consul
docker-compose up -d
popd
# Give consul a bit of time to wake, better poll could be used here
sleep 30
# Load some useful things into Consul KV Store
consul kv put env/bootstrap/branch $PROJECT_BRANCH

#
# Vault
#
pushd ~/rehab.earth/docker/vault
docker-compose build
docker-compose up -d
popd
# Potential for version drift between binary in Vault container and this
pushd /tmp/
curl -s -L "https://releases.hashicorp.com/vault/0.6.5/vault_0.6.5_linux_amd64.zip" -o vault.zip
unzip vault.zip
mv vault /usr/local/bin/vault
popd
chmod u+x /usr/local/bin/vault
sh /root/export_root_token.sh

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
