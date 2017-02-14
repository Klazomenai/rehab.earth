# Abstraction

# Inception

Ensure variables are available according to your shell of choice.
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
terraform plan
```

After Sanity check.
```sh
terraform apply
```

# Tests

```sh
cd cookbooks/mailcow
bundle install
bundle exec kitchen test
```

# Realisation

# Termination

```sh
terraform plan -destroy
```

After sanity check.
```sh
terraform destroy
```
