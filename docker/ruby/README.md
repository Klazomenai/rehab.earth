Docker images used for concourse jobs as part of [rehab.earth](https://github.com/Klazomenai/rehab.earth). The
jobs Docker images require Vault.

Docker hub images: [docker/klazomenai/concourse.rehab.earth/](https://hub.docker.com/r/klazomenai/ruby.rehab.earth/)

The ruby Docker image is Apline, was struggling to get apk to install unzip on the images, so lets unzip and push
Vault manually for now. This process needs better automation.

To update the image:
```sh
curl -L "https://releases.hashicorp.com/vault/0.6.5/vault_0.6.5_linux_amd64.zip" -o vault.zip
unzip vault.zip
curl -L "https://releases.hashicorp.com/terraform/0.8.4/terraform_0.8.4_linux_amd64.zip" -o terraform.zip
unzip terraform.zip
docker login
docker build -t klazomenai/ruby.rehab.earth:2.2.6 .
docker push klazomenai/ruby.rehab.earth:2.2.6
rm vault{,.zip} terraform{,.zip}
```
