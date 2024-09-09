# talos-cluster

## Terraform
Копируем переменные и заполняем
```bash
cp terraform.tfvars.example terraform.tfvars
```

Ставим зависимости
```bash
terraform init -upgrade        
```

Разворачиваем все
```bash
terraform apply --auto-approve
```

K8s конфиг будет доступен в **output/.kubeconfig**