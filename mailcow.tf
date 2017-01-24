# Mailcow stack
# https://mailcow.email/dockerized/

resource "digitalocean_droplet" "mailcow" {
  image = "docker-16-04"
  name = "mailcow"
  region = "${var.region}"
  size = "2gb"
  private_networking = true
  depends_on = ["digitalocean_droplet.firewall"]
  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]

  connection {
    user = "root"
    type = "ssh"
    private_key = "${file("${var.pvt_key}")}"
    timeout = "2m"
    bastion_host = "${digitalocean_droplet.firewall.ipv4_address}"
    bastion_user = "${var.freebsd_user}"
  }

  provisioner "remote-exec" {
    inline = [
      "ifconfig eth0 down",
      # This is volatile and wrong and should go soon! See Issue #1 in GitHub
      "sed -i '9,22d' /etc/network/interfaces.d/50-cloud-init.cfg",
      "git clone https://github.com/andryyy/mailcow-dockerized",
      "cd ~/mailcow-dockerized && export MAILCOW_HOSTNAME=mail.rehab.earth; export TZ=\"Europe/London\"; ./generate_config.sh",
      "cd ~/mailcow-dockerized/ && docker-compose up -d"
    ]
  }
}
