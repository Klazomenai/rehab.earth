output "ID" {
  value = "${digitalocean_droplet.bootstrap.id}"
}

output "Public_IP" {
    value = "${digitalocean_droplet.bootstrap.ipv4_address}"
}

output "Private_IP" {
    value = "${digitalocean_droplet.bootstrap.ipv4_address_private}"
}
