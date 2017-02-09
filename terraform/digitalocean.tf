variable "digitalocean_access_token" {}

variable "machines" {
  default = 1
}

variable "region" {
  default = "fra1"
}

variable "size" {
  default = "4GB"

}

variable "private_key" {
  default = "./topconf_id_rsa"
}

variable "openjdk_version" {
  default = "8"
}

provider "digitalocean" {
  token = "${var.digitalocean_access_token}"
}

resource "digitalocean_ssh_key" "topconf" {
  name = "topconf"
  public_key = "${file(format("%s.pub", var.private_key))}"
}

resource "digitalocean_droplet" "topconf" {
    image = "ubuntu-16-10-x64"
    name= "${format("topconf-%02d", (count.index + 1))}"
    region = "${var.region}"
    size = "${var.size}"
    private_networking = true
    resize_disk = false

    count = "${var.machines}"

    ssh_keys = [
      "${digitalocean_ssh_key.topconf.fingerprint}"
    ]

    provisioner "local-exec" {
        command = "docker-machine create --driver generic --generic-ip-address ${self.ipv4_address} --generic-ssh-key ${var.private_key} ${self.name}"
    }

    provisioner "remote-exec" {
      connection {
        user = "root"
        # the private key must not be passsword protected
        private_key = "${file(var.private_key)}"
        agent = false
      }
      inline = [
        "curl -L \"https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose",
        "docker-compose --version",
        "git clone https://github.com/SoftwareCraftsmen/continuousdelivery.git",
        "docker pull openjdk:${var.openjdk_version}-jdk",
        "docker pull openjdk:${var.openjdk_version}-jre",
        "docker pull postgres:9.6"
      ]
    }
}

output "private_ip" {
  value = ["${digitalocean_droplet.topconf.*.ipv4_address_private}"]
}

output "public_ip" {
  value = ["${digitalocean_droplet.topconf.*.ipv4_address}"]
}

output "id" {
  value = ["${digitalocean_droplet.topconf.*.id}"]
}

output "status" {
  value = ["${digitalocean_droplet.topconf.*.status}"]
}
