#!/usr/bin/env bash

set -e -o -x errexit

# Script called by Terraform to do all the things just like we used to in the 90s.
# Things must go in Chef!

#
# Pre reqs
#
yum install -y unzip

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
chmod u+x /usr/local/bin/docker-compose
docker network create rehab.earth

#
# Consul
#
pushd ~/rehab.earth/docker/consul
docker-compose up -d
popd
# Give consul a bit of time to wake, better poll could be used here
sleep 10

#
# Vault
#
pushd ~/rehab.earth/docker/vault
docker-compose build
docker-compose up -d
popd
# Initialise and unseal the Vault in a way we don't care for at the moment. Keys will be lost!
# Potential for version drift between binary in Vault container and this
pushd /tmp/
curl -s -L "https://releases.hashicorp.com/vault/0.6.5/vault_0.6.5_linux_amd64.zip" -o vault.zip
unzip vault.zip
mv vault /usr/local/bin/vault
chmod u+x /usr/local/bin/vault
export VAULT_ADDR=http://127.0.0.1:8200
vault init -key-shares=5 -key-threshold=3 | while read line
do
  grep "Unseal Key" | head -n3 |
    awk '{
      command = "for i in $(xargs); do vault unseal $i; done"
      print $4 | command }'
done
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
