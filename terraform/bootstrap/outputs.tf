output "ID" {
  value = "${digitalocean_droplet.bootstrap.id}"
}

output "Public_IP" {
    value = "${digitalocean_droplet.bootstrap.public_ip}"
}

output "Private_IP" {
    value = "${digitalocean_droplet.bootstrap.private_ip}"
}
