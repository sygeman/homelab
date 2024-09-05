variable "PROXMOX_API_ENDPOINT" {
  description = "API endpoint for proxmox"
  type        = string
}

variable "PROXMOX_USERNAME" {
  description = "User name used to login proxmox"
  type        = string
}

variable "PROXMOX_PASSWORD" {
  description = "Password used to login proxmox"
  type        = string
}

variable "TARGET_NODE" {
  description = "Target node name in proxmox"
  type        = string
  default     = "pmx"
}

variable "TALOS_ISO" {
  description = "Talos iso path"
  type        = string
}

variable "CLUSTER_NAME" {
  description = "Cluster name, as prefix"
  type        = string
  default     = "talos"
}

variable "CONTROL_PLANE_CONFIG" {
  description = "Kubernetes master config"
  type = object({
    memory = string
    cores  = number
    size   = string
  })
}

variable "WORKER_CONFIG" {
  description = "Kubernetes worker config"
  type = object({
    count  = number
    memory = string
    cores  = number
    size   = string
  })
}

variable "storage" {
  description = "Storage type"
  type        = string
  default     = "local-zfs"
}

variable "network" {
  description = "Network config"
  type = object({
    bridge = string
    model  = string
  })
  default = {
    bridge = "vmbr0"
    model  = "virtio"
  }
}
