
# Buttery biscuit base

Bare bones base image, no snowflakes please.

Ideally the base would come from DigitalOcean, and would not need to build on top of that, but latest Kernel is required for Concourse. So, build this, snapshot, then use snapshot throughout infrastructure.

```sh
terraform plan
terraform apply
doctl compute droplet-action snapshot $(terraform output ID) --snapshot-name base.rehab.earth --wait
terraform plan -destroy
terraform destroy
```

Bootstrap is dependent on the Base ID, get image id:
```sh
doctl compute image list|grep base.rehab.earth
```

and add it to relevant exports for your env:
```sh
export TF_VAR_base_snapshot_id="<<insert_base_snapshot_ID_here>>"
```

When done with base (i.e. when environment is destroyed), clean up.
```sh
doctl compute image delete $TF_VAR_base_snapshot_id
```
