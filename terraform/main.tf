terraform {
  backend "gcs" {
    credentials = "../credential.json"
    bucket = "setup-api-nodejs-using-terraform-ansible"
    prefix = "/"
  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

  }
}

provider "digitalocean" {
  token = var.token
}

resource "digitalocean_ssh_key" "my_ssh_key" {
  name       = "id_ed25519"
  public_key = var.ssh_key_pub
}

resource "digitalocean_droplet" "api_nodejs" {
  name   = "api-nodejs"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  image  = "ubuntu-20-04-x64"
  ssh_keys = [
    digitalocean_ssh_key.my_ssh_key.id,
  ]

}

resource "null_resource" "ansible-provision" {
  depends_on = [
    digitalocean_droplet.api_nodejs
  ]

  provisioner "local-exec" {
    command = "echo '[api]' > ../ansible/hosts && echo '${digitalocean_droplet.api_nodejs.ipv4_address} ansible_user=root ansible_ssh_private_key_file=${var.path_ssh_key_priv}' >> ../ansible/hosts"
  }
}
