# talos-cluster

## MiniPC
16cpu 32gb 2tb + 2tb

Control Plane - 1
4cpu 4gb 100gb

Worker - 6
2cpu 4gb 500gb

## Terraform
terraform init -upgrade        
terraform apply --auto-approve

## Talos

https://www.virtualizationhowto.com/2024/01/proxmox-kubernetes-install-with-talos-linux/

export CONTROL_PLANE_IP=

talosctl gen config talos-proxmox-cluster https://$CONTROL_PLANE_IP:6443
talosctl apply-config --insecure -n $CONTROL_PLANE_IP --file controlplane.yaml

export WORKER_IP=
talosctl apply-config --insecure --nodes $WORKER_IP --file worker.yaml