# Mailcow stack
# https://mailcow.email/dockerized/

resource "digitalocean_droplet" "mailcow" {
    image = "docker-16-04"
    name = "mailcow"
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

provisioner "remote-exec" {
    inline = [
      "git clone https://github.com/Klazomenai/mailcow-dockerized",
      "cd ~/mailcow-dockerized && export MAILCOW_HOSTNAME=mail.rehab.earth; export TZ=\"Europe/London\"; ./generate_config.sh",
      "cd ~/mailcow-dockerized/ && docker-compose up -d"
    ]
  }
}
