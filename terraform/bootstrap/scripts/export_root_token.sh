#!/usr/bin/env bash

#
# Temporarily export Vault Initial Root Token until GitHub backend
# is implemented. Initialise and unseal the Vault in a way we don't
# care for at the moment. Keys will be lost!
#

IFS=!

# Temporary static IP address until Docker Swarm or similar knows
# how to resolve consul cluster. See Vault Docker Compose file.
echo "export VAULT_ADDR=http://172.100.0.5:8200" >> ~/.bashrc
source ~/.bashrc

vault_init=$(vault init -key-shares=5 -key-threshold=3)

echo $vault_init | while read line
do
  grep "Unseal Key" | head -n3 |
    awk '{
      command = "for i in $(xargs); do vault unseal $i; done"
      print $4 | command }'
done

initial_root_token=$(echo $vault_init | grep "Initial Root Token" | awk '{print $4}' )

echo "export VAULT_TOKEN=$initial_root_token" >> ~/.bashrc
