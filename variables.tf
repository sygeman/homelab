variable "proxmox" {
  type = object({
    endpoint = string
    username = string
    password = string
  })
}

variable "target_node" {
  type    = string
  default = "pmx"
}

variable "storage" {
  type    = string
  default = "local-zfs"
}

variable "cluster_name" {
  type    = string
  default = "talos"
}

variable "talos_version" {
  type    = string
  default = "v1.7.6"
}

variable "default_gateway" {
  type    = string
  default = "192.168.88.1"
}

variable "cp_config" {
  type = object({
    memory   = number
    cores    = number
    size     = number
    first_ip = string
  })
}

variable "worker_config" {
  type = object({
    count    = number
    memory   = number
    cores    = number
    size     = number
    first_ip = string
  })
}
