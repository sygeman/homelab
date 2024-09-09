resource "talos_machine_secrets" "machine_secrets" {}

locals {
  cp_ip = "${var.base_machine_ip}${var.cp_config.first_ip}"
}

data "talos_client_configuration" "talosconfig" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  endpoints            = [local.cp_ip]
}

data "talos_machine_configuration" "machineconfig_cp" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${local.cp_ip}:6443"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

resource "talos_machine_configuration_apply" "cp_config_apply" {
  depends_on                  = [proxmox_virtual_environment_vm.talos_cp]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.machineconfig_cp.machine_configuration
  count                       = 1
  node                        = local.cp_ip
}

data "talos_machine_configuration" "machineconfig_worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${local.cp_ip}:6443"
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

resource "talos_machine_configuration_apply" "worker_config_apply" {
  depends_on                  = [proxmox_virtual_environment_vm.talos_worker]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.machineconfig_worker.machine_configuration
  count                       = var.worker_config.count
  node                        = "${var.base_machine_ip}${var.worker_config.first_ip + count.index}"
}

resource "talos_machine_bootstrap" "bootstrap" {
  depends_on           = [talos_machine_configuration_apply.cp_config_apply]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = local.cp_ip
}

data "talos_cluster_health" "health" {
  depends_on           = [talos_machine_configuration_apply.cp_config_apply, talos_machine_configuration_apply.worker_config_apply]
  client_configuration = data.talos_client_configuration.talosconfig.client_configuration
  control_plane_nodes  = [local.cp_ip]
  worker_nodes         = [for i in range(var.worker_config.count) : "${var.base_machine_ip}${var.worker_config.first_ip + i}"]
  endpoints            = data.talos_client_configuration.talosconfig.endpoints
}

data "talos_cluster_kubeconfig" "kubeconfig" {
  depends_on           = [talos_machine_bootstrap.bootstrap, data.talos_cluster_health.health]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = local.cp_ip
}

output "talosconfig" {
  value     = data.talos_client_configuration.talosconfig.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = data.talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  sensitive = true
}

resource "local_file" "kubeconfig" {
  content  = data.talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  filename = "${path.module}/output/.kubeconfig"
}
