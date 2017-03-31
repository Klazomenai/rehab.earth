# Bootstrap

Bootstrap module is currently WIP and does not fully provision the full env yet.

# Inception

Ensure env vars are exported and base snapshot is available like in the main [README.md](https://github.com/Klazomenai/rehab.earth/blob/master/README.md)

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

## Useful Key/Value Data

- The `Environment Branch` which was used to build the bootstrap environment.
```sh
consul kv get env/bootstrap/branch
```

# Realisation

Connection to hosts is via tunnels until VNP is configured.

Consul
```sh
ssh -L 8501:localhost:8501 -i $TF_VAR_pvt_key root@$(terraform output Public_IP)
```

Concourse
```sh
ssh -L 8080:localhost:8080 -i $TF_VAR_pvt_key root@$(terraform output Public_IP)
```
