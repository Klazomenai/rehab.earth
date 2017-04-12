resource "digitalocean_droplet" "geth-node" {
  image = "${var.base_snapshot_id}"
  name = "geth-node"
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

  provisioner "remote-exec" {
    inline = [
      # Until chef arrives,
      "git clone --depth 1 --branch ${var.project_branch} https://github.com/Klazomenai/rehab.earth.git",
      "bash ${var.project}/terraform/geth-node/scripts/all_the_things.sh",
    ]
  }
}
