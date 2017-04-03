#!/usr/bin/env bash

#
# Temporarily export Vault Initial Root Token until GitHub backend
# is implemented. Initialise and unseal the Vault in a way we don't
# care for at the moment. Keys will be lost!
#

IFS=!

PROJECT=$1
DO_PAT=$2

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
source ~/.bashrc

# Load the main DigitalOcean token into Vault so Concourse can build
# things. These should NOT be visible in any verbose output as Concourse
# will display to the world
vault write secret/$PROJECT DO_PAT=$DO_PAT
# Export the token as an env var so Concourse worker can use it. Not the
# most optimal way, the worker should be Vault aware and be able to call
# Vault itself for the token.
echo "export DO_PAT=$(vault read secret/$PROJECT DO_PAT)" >> ~/.bashrc
