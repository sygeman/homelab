resource "proxmox_virtual_environment_vm" "talos_cp_01" {
  name      = "${var.cluster_name}-cp-01"
  tags      = [var.cluster_name]
  node_name = var.target_node
  on_boot   = true

  cpu {
    cores = var.cp_config.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.cp_config.memory
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = var.storage
    file_id      = proxmox_virtual_environment_download_file.talos_nocloud_image.id
    file_format  = "raw"
    interface    = "virtio0"
    size         = var.cp_config.size
  }

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    datastore_id = var.storage
    ip_config {
      ipv4 {
        address = "${var.cp_config.first_ip}/24"
        gateway = var.default_gateway
      }
      ipv6 {
        address = "dhcp"
      }
    }
  }
}

resource "proxmox_virtual_environment_vm" "talos_worker_01" {
  depends_on = [proxmox_virtual_environment_vm.talos_cp_01]
  name       = "${var.cluster_name}-worker-01"
  tags       = [var.cluster_name]
  node_name  = var.target_node
  on_boot    = true

  cpu {
    cores = var.worker_config.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.worker_config.memory
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = var.storage
    file_id      = proxmox_virtual_environment_download_file.talos_nocloud_image.id
    file_format  = "raw"
    interface    = "virtio0"
    size         = var.worker_config.size
  }

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    datastore_id = var.storage
    ip_config {
      ipv4 {
        address = "${var.worker_config.first_ip}/24"
        gateway = var.default_gateway
      }
      ipv6 {
        address = "dhcp"
      }
    }
  }
}
