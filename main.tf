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
    source = "modules/iptables/files/config.sh"
    destination = "/tmp/iptables_config.sh"
  }

  provisioner "file" {
    source = "modules/docker/files/sysconfig_docker"
    destination = "/tmp/docker"
  }

  # Set up chef. No chef-client --local provisioner yet
  provisioner "remote-exec" {
    inline = [
      # Chef + Dependencies
      "curl -L https://omnitruck.chef.io/install.sh | sudo bash",
      "yum install -y git",
      "cd && git clone https://github.com/Klazomenai/rehab.earth.git",
      "cd ~/rehab.earth",
      "chef-client --local -o recipe['iptables']",
      # Configure firewall iptables
      "chmod u+x /tmp/iptables_config.sh",
      "/tmp/iptables_config.sh",
      # Docker
      "yum install -y docker",
      "mv /tmp/docker /etc/sysconfig/docker",
      "chkconfig docker on",
      "systemctl restart docker",
      "curl -L \"https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "chmod +x /usr/local/bin/docker-compose",
      # Mailcow
      "systemctl disable postfix",
      "systemctl stop postfix",
      "cd && git clone https://github.com/andryyy/mailcow-dockerized",
      "cd ~/mailcow-dockerized && export MAILCOW_HOSTNAME=mail.rehab.earth; export TZ=\"Europe/London\"; ./generate_config.sh",
      "cd ~/mailcow-dockerized/ && docker-compose up -d",
    ]
  }
}
