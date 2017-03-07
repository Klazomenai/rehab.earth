output "MailCow_ID" {
  value = "${digitalocean_droplet.mail.id}"
}

output "MailCow_Public_IP" {
    value = "${digitalocean_droplet.mail.ipv4_address}"
}

output "MailCow_Private_IP" {
    value = "${digitalocean_droplet.mail.ipv4_address_private}"
}
