resource "digitalocean_floating_ip" "mail" {
  droplet_id = "${digitalocean_droplet.mail.id}"
  region = "${var.region}"
}
