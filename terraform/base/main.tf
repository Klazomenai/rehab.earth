resource "digitalocean_droplet" "base" {
  image = "centos-7-x64"
  name = "base"
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
    source = "../../scripts/etc/consul.d/client/config.json"
    destination = "/tmp/consul_client_config.json"
  }

  provisioner "file" {
    source = "../../scripts/etc/systemd/consul.service"
    destination = "/etc/systemd/system/consul.service"
  }

  provisioner "file" {
    source = "scripts/all_the_things.sh"
    destination = "/root/all_the_things.sh"
  }

  # Set up chef. No chef-client --local provisioner yet
  provisioner "remote-exec" {
    inline = [
      "rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org",
      "rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm",
      "yum --enablerepo=elrepo-kernel -y install kernel-ml",
      # Core tools
      "yum -y install git",
      # debug
      "uname -r",
      # or possibly update-grub
      "grub2-set-default 0",
      # Until chef arrives,
      "bash all_the_things.sh",
    ]
  }
}
