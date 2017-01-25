resource "digitalocean_droplet" "droplet" {
  image = "centos-7-x64"
  name = "droplet"
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
    source = "modules/iptables/files/config.sh"
    destination = "/tmp/iptables_config.sh"
  }

  provisioner "remote-exec" {
    inline = [
      # Configure firewall iptables
      "systemctl disable firewalld",
      "yum install -y iptables-services",
      "systemctl enable iptables",
      "chmod u+x /tmp/iptables_config.sh",
      "/tmp/iptables_config.sh",
      # Docker
      "yum install -y docker",
      "chkconfig docker on",
      "systemctl start docker",
      "curl -L \"https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "chmod +x /usr/local/bin/docker-compose",
      # Mailcow
      "systemctl disable postfix",
      "systemctl stop postfix",
      "yum install -y git",
      "git clone https://github.com/andryyy/mailcow-dockerized",
      "cd ~/mailcow-dockerized && export MAILCOW_HOSTNAME=mail.rehab.earth; export TZ=\"Europe/London\"; ./generate_config.sh",
      "cd ~/mailcow-dockerized/ && docker-compose up -d"
    ]
  }
}
