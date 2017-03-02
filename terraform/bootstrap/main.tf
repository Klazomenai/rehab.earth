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
    source = "scripts/all_the_things.sh"
    destination = "/root/all_the_things.sh"
  }

  # Set up chef. No chef-client --local provisioner yet
  provisioner "remote-exec" {
    inline = [
      # Until chef arrives,
      "bash all_the_things.sh",
    ]
  }
}
