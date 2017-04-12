output "ID" {
  value = "${digitalocean_droplet.geth-node.id}"
}

output "Public_IP" {
    value = "${digitalocean_droplet.geth-node.ipv4_address}"
}

output "Private_IP" {
    value = "${digitalocean_droplet.geth-node.ipv4_address_private}"
}
