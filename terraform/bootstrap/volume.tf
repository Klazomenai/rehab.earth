resource "digitalocean_volume" "mail" {
  region      = "${var.region}"
  name        = "mail"
  size        = 1
  description = "Persistent storage for MailCow"
}
