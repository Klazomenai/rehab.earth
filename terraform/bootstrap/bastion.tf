resource "digitalocean_droplet" "bastion" {
  image = "centos-7-x64"
  name = "bastion"
  region = "${var.region}"
  size = "512mb"
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
    source = "bin/concourse/refresh.sh"
    destination = "/tmp/concourse-refresh.sh"
  }

  # Set up chef. No chef-client --local provisioner yet
  provisioner "remote-exec" {
    inline = [
      "yum install -y unzip iptables-services",
      "wget https://github.com/tam7t/droplan/releases/download/v1.2.0/droplan_1.2.0_linux_amd64.tar.gz",
      "tar -xzvf droplan_1.2.0_linux_amd64.tar.gz",
      "mkdir /opt/droplan",
      "mv ./droplan /opt/droplan/",
      "DO_KEY=${var.do_token} /opt/droplan/droplan",
      # Debug
      "iptables -L -v",
      # FW
      "sudo systemctl stop firewalld",
      "sudo systemctl mask firewalld",
      "systemctl enable iptables",
      "sudo service iptables save",
      #Cron
      "mv /tmp/concourse-refresh.sh /opt/droplan/refresh.sh",
      "chmod u+x /opt/droplan/refresh.sh",
      "crontab -l | { cat; echo \"*/1 * * * * root PATH=/sbin:/usr/bin:/bin DO_KEY=personal_access_token /opt/droplan/refresh.sh > /var/log/droplan.log 2>&1\"; } | crontab -",
      "crontab -l",
    ]
  }
}
