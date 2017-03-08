# Abstraction

Sandpit for spinning up a basic MailCow instance.

The current stack: DigitalOcean, Terraform, Docker, Chef, Inspec.

Coming: Consul, Vault, Concourse.

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
export TF_VAR_pub_key="$HOME/.ssh/${user}.${project}_rsa.pub"
export TF_VAR_pvt_key="$HOME/.ssh/${user}.${project}_rsa"
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
