# Abstraction

# Inception

Ensure variables are available according to your shell of choice.
```sh
# Generated from Digital Ocean
export DO_TOKEN=${DO_PAT}"
# Generated locally
export user="alice"
export project="rehab.earth"
export TF_VAR_do_token="${DO_PAT}"
# ssh-keygen ...
export TF_VAR_pub_key="$HOME/.ssh/${user}.${project}_rsa.pub"
export TF_VAR_pvt_key="$HOME/.ssh/${user}.${project}_rsa"
export TF_VAR_ssh_fingerprint=$(ssh-keygen -lf ~/.ssh/${user}.${project}_rsa.pub | awk '{print $2}')
```

Running with Terraform v0.8.4.
```sh
terraform plan
```

After Sanity check.
```sh
terraform apply
```

# Acceptance 

# Realisation

# Termination

```sh
terraform plan -destroy
```

After sanity check.
```sh
terraform destroy
```
