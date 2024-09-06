terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
    talos = {
      source = "siderolabs/talos"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox.endpoint
  username = "${var.proxmox.username}@pam"
  password = var.proxmox.password
  insecure = true

  ssh {
    agent = true
  }
}
