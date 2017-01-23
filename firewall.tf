resource "digitalocean_droplet" "firewall" {
  image = "freebsd-11-0-x64-zfs"
  name = "firewall"
  region = "${var.region}"
  size = "512mb"
  private_networking = true
  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]

  connection {
    user = "${var.freebsd_user}"
    type = "ssh"
    private_key = "${file("${var.pvt_key}")}"
    timeout = "2m"
  }

  provisioner "file" {
    source = "modules/pf/files/rc.conf"
    destination = "/tmp/rc.conf"
  }

  provisioner "file" {
    source = "modules/pf/files/pf.conf"
    destination = "/tmp/pf.conf"
  }

  provisioner "file" {
    source = "modules/pf/files/firewall_config.sh"
    destination = "/tmp/firewall_config.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/firewall_config.sh",
      "sudo /tmp/firewall_config.sh",
      "sudo service pf start"
    ]
  }
}
