provider "kubernetes" {
  config_path    = "${path.module}/output/.kubeconfig"
  config_context = "admin@talos"
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "my-first-namespace"
  }
}
