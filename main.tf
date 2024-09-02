resource "proxmox_vm_qemu" "talos-control-plane" {
  name        = "talos-control-plane"
  target_node = var.TARGET_NODE
  memory      = var.CONTROL_PLANE_CONFIG.memory
  cores       = var.CONTROL_PLANE_CONFIG.cores

  disks {
    scsi {
      scsi0 {
        disk {
          storage = var.storage
          size    = var.CONTROL_PLANE_CONFIG.size
        }
      }
    }

    ide {
      ide2 {
        cdrom {
          iso = var.TALOS_ISO
        }
      }
    }
  }

  network {
    bridge = var.network.bridge
    model  = var.network.model
  }
}

resource "proxmox_vm_qemu" "talos-worker" {
  count = var.WORKER_CONFIG.count

  name        = "talos-worker-${count.index + 1}"
  target_node = var.TARGET_NODE
  memory      = var.WORKER_CONFIG.memory
  cores       = var.WORKER_CONFIG.cores

  disks {
    scsi {
      scsi0 {
        disk {
          storage = var.storage
          size    = var.WORKER_CONFIG.size
        }
      }
    }

    ide {
      ide2 {
        cdrom {
          iso = var.TALOS_ISO
        }
      }
    }
  }

  network {
    bridge = var.network.bridge
    model  = var.network.model
  }
}
