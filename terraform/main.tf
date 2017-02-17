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
      "cd ~/rehab.earth",
      "chef-client --local --override-runlist recipe['mailcow']",
      # Docker Compose - until using cookbook
      "curl -L \"https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "chmod +x /usr/local/bin/docker-compose",
      # No Mailcow chef cookbook just yet
      "cd && git clone --branch only-ports-for-server-server-comms --depth 1 https://github.com/Klazomenai/mailcow-dockerized.git",
      "cd ~/mailcow-dockerized && export MAILCOW_HOSTNAME=mail.${var.project}; export TZ=${var.tz}; ./generate_config.sh",
      "cd ~/mailcow-dockerized/ && docker-compose up -d"
    ]
  }
}