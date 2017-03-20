#!/usr/bin/env bash
#
# Script called by Terraform to do all the things (for the Base image)
# just like we used to in the 90s. Things must go in Chef!
#

set -e -o -x errexit

#
# Pre-reqs
#
yum install -y unzip

#
# Consul client
#
mkdir -p /etc/consul.d/client/
mv /tmp/consul_client_config.json /etc/consul.d/client/config.json
mkdir -p /var/consul/dist
mkdir -p /var/consul/dist

#
# Consul template
#
curl -L "https://releases.hashicorp.com/consul-template/0.18.1/consul-template_0.18.1_linux_amd64.zip" -o /tmp/consul-template_0.18.1_linux_amd64.zip
unzip /tmp/consul-template_0.18.1_linux_amd64.zip -d /usr/local/bin
chmod u+x /usr/local/bin/consul-template

pushd /tmp
curl -L "https://releases.hashicorp.com/consul/0.7.5/consul_0.7.5_linux_amd64.zip" -o /tmp/consul_0.7.5_linux_amd64.zip
unzip consul_0.7.5_linux_amd64.zip
mv consul /usr/local/bin/
chmod u+x /usr/local/bin/consul
systemctl enable consul
