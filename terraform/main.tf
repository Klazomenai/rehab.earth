resource "digitalocean_droplet" "mail" {
  image = "centos-7-x64"
  name = "mail"
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
    source = "modules/docker/files/sysconfig_docker"
    destination = "/tmp/docker"
  }

  provisioner "file" {
    source = "modules/mailcow/scripts/chef-prep.sh"
    destination = "/tmp/chef-prep.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/chef-prep.sh",
      "/tmp/chef-prep.sh"
    ]
  }

  # Set up chef. No chef-client --local provisioner yet
  provisioner "remote-exec" {
    inline = [
      # Docker
      #"mv /tmp/docker /etc/sysconfig/docker",
      "curl -L \"https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "chmod +x /usr/local/bin/docker-compose"
      # Mailcow
      #"systemctl disable postfix",
      #"systemctl stop postfix",
      #"cd && git clone https://github.com/andryyy/mailcow-dockerized",
      #"cd ~/mailcow-dockerized && export MAILCOW_HOSTNAME=mail.rehab.earth; export TZ=\"Europe/London\"; ./generate_config.sh",
      #"cd ~/mailcow-dockerized/ && docker-compose up -d",
    ]
  }
}
