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
      "chef-client --local --override-runlist recipe['mailcow']",
      # No Mailcow chef cookbook just yet
      "cd && git clone https://github.com/andryyy/mailcow-dockerized",
      "cd ~/mailcow-dockerized && export MAILCOW_HOSTNAME=mail.${var.project}; export TZ=${var.tz}; ./generate_config.sh",
      #"cd ~/mailcow-dockerized/ && docker-compose up -d",
    ]
  }
}
