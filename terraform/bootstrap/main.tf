resource "digitalocean_droplet" "bootstrap" {
  image = "${var.base_id}"
  name = "bootstrap"
  region = "${var.region}"
  size = "${var.size}"
  private_networking = true

  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]

  connection {
    user = "root"
    type = "ssh"
    private_key = "${file("${var.pvt_key}")}"
    timeout = "2m"
  }

  provisioner "file" {
    source = "etc/concourse/docker-compose.yml"
    destination = "/tmp/concourse-docker-compose.yml"
  }

  provisioner "file" {
    source = "etc/consul/docker-compose.yml"
    destination = "/tmp/consul-docker-compose.yml"
  }

  provisioner "file" {
    source = "bin/concourse/refresh.sh"
    destination = "/tmp/concourse-refresh.sh"
  }

  provisioner "file" {
    source = "etc/concourse/hello-world.yml"
    destination = "/tmp/concourse-hello-world.yml"
  }

  # Set up chef. No chef-client --local provisioner yet
  provisioner "remote-exec" {
    inline = [
      "curl -L \"https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "chmod +x /usr/local/bin/docker-compose",
      # godope
      "pushd /tmp",
      "wget https://github.com/Klazomenai/godope/releases/download/v0.0.1/godope_0.0.1_amd64.tar.gz",
      "tar -xzvf godope_0.0.1_amd64.tar.gz",
      "DO_KEY=${var.do_token} /tmp/godope",
      "cat /etc/hosts",
      "popd",
      # Consul
      "mkdir ~/consul",
      "mv /tmp/consul-docker-compose.yml ~/consul/docker-compose.yml",
      "pushd ~/consul",
      "docker-compose up -d",
      "popd",
      # Concourse
      "mkdir ~/concourse",
      "mv /tmp/concourse-docker-compose.yml ~/concourse/docker-compose.yml",
      "pushd ~/concourse",
      "mkdir -p keys/web keys/worker",
      "ssh-keygen -t rsa -f ./keys/web/tsa_host_key -N ''",
      "ssh-keygen -t rsa -f ./keys/web/session_signing_key -N ''",
      "ssh-keygen -t rsa -f ./keys/worker/worker_key -N ''",
      "cp ./keys/worker/worker_key.pub ./keys/web/authorized_worker_keys",
      "cp ./keys/web/tsa_host_key.pub ./keys/worker",
      "docker-compose up -d",
      "popd",
      # Maybe a job for a jobs container
      "wget -O fly -q https://github.com/concourse/concourse/releases/download/v2.7.0/fly_linux_amd64",
      "mv fly /usr/local/bin/fly",
      "chmod u+x /usr/local/bin/fly",
      # Looks like concourse needs a little sleep before it wakes up, this sleep needs sorting properly
      "sleep 20",
      # Need Vault!
      "fly --target lite login --concourse-url http://bootstrap:8080 --username=concourse --password=changeme",
      # The start of the beginning and the end of bootstrap
      "fly --target lite set-pipeline --non-interactive --pipeline hello-world --config /tmp/concourse-hello-world.yml",
      "fly --target lite unpause-pipeline --pipeline hello-world",
    ]
  }
}
