# talos-cluster

## Terraform
cp terraform.tfvars.example terraform.tfvars

terraform init -upgrade        
terraform apply --auto-approve

terraform output -raw kubeconfig
terraform output -raw talosconfig