resource "digitalocean_droplet" "bootstrap" {
  image = "centos-7-x64"
  name = "bootstrap"
  region = "${var.region}"
  size = "2gb"
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
    source = "etc/docker/sysconfig"
    destination = "/tmp/docker-sysconfig"
  }

  # Set up chef. No chef-client --local provisioner yet
  provisioner "remote-exec" {
    inline = [
      "yum install -y unzip iptables-services",
      "wget https://github.com/tam7t/droplan/releases/download/v1.2.0/droplan_1.2.0_linux_amd64.tar.gz",
      "tar -xzvf droplan_1.2.0_linux_amd64.tar.gz",
      "sudo mkdir /opt/droplan",
      "sudo mv ./droplan /opt/droplan/",
      "sudo DO_KEY=${var.do_token} PUBLIC=true /opt/droplan/droplan",
      # FW
      "sudo systemctl stop firewalld",
      "sudo systemctl mask firewalld",
      "systemctl enable iptables",
      "sudo service iptables save",
      # Droplan Cron
      "mv /tmp/concourse-refresh.sh /opt/droplan/refresh.sh",
      "chmod u+x /opt/droplan/refresh.sh",
      "crontab -l | { cat; echo \"*/1 * * * * root PATH=/sbin:/usr/bin:/bin DO_KEY=${var.do_token} /opt/droplan/refresh.sh > /var/log/droplan.log 2>&1\"; } | crontab -",
      # Docker
      "yum install -y docker",
      "mv -f /tmp/docker-sysconfig /etc/sysconfig/docker",
      "systemctl daemon-reload",
      "systemctl start docker",
      "curl -L \"https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "chmod +x /usr/local/bin/docker-compose",
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
      # Need Consul and Vault!
      #"fly -t lite login -c http://bootstrap:8080 --username=concourse --password=changeme",
    ]
  }
}
