variable "token" {
  type = string
  description = "The token used to communicate with DigitalOcean"
}

variable "ssh_key_pub" {
  type = string
  description =  "The content the ssh key public"
}

variable "path_ssh_key_priv" {
    type = string
    description = "The private ssh key path"
    default = "~/.ssh/id_ed25519"
}