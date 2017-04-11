# Abstraction

Sandpit for CD:
((DigitalOcean + Docker) + (Terraform + Chef + Inspec) + (Consul + Vault)) + Concourse = MailCow

The intention is to have a basic opinionated framework for Docker Containers on DigitalOcean. Bootstrap
can be considered as ground zero (basic infra able to fire Concourse). Concourse is then the gateway to
all new creations (Containers) and the new world. We're using the MailCow stack of Docker containers to
attach some value and purpose to the infrastructure. Consul keeps the relevant config and Vault the
secrets, with consul-template plumbing in the relevant bits in the correct place.

Still desperately missing. Docker Swarm Vs Nomad and a descent testing structure.

If you fancy getting stuck in with the development, come join the community on the
[Project Entorpy Rocket](http://project-entropy.com/pages/community), and see what you can pick up from
[Trello](https://trello.com/b/IAKTSzT9/infrastructure-alpha).

# Tests

```sh
pushd cookbooks/mailcow
bundle install
bundle exec kitchen test
popd
```

# Inception

Create base image and ensure relevant env var is exported:
[terraform/base/README.md](https://github.com/Klazomenai/rehab.earth/blob/master/terraform/base/README.md)

Ensure the following variables are also available according to your shell of choice.
```sh
# Personal
export user=""
export TF_VAR_project=""
export TF_VAR_tz=""
# Generated from Digital Ocean
export TF_VAR_ssh_fingerprint=""
export TF_VAR_do_token=""
# Something like... ssh-keygen -t rsa -f ~/.ssh/${user}.${project}_rsa
export TF_VAR_pvt_key="$HOME/.ssh/${user}.${project}_rsa"
# Branch to pull from rehab.earth for deployments.
export TF_VAR_project_branch="master"
```

Running with Terraform v0.8.4.
```sh
pushd terraform
terraform plan
```

After Sanity check.
```sh
terraform apply
popd
```

# Termination

```sh
pushd terraform
terraform plan -destroy
```

After sanity check.
```sh
terraform destroy
popd
```
