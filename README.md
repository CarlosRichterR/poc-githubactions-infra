# poc-githubactions-infra

Terraform del POC **GitHub Actions + Azure** (Pay-as-you-go, SKUs baratos).

Provisiona:

| Recurso | Default |
|---------|---------|
| Resource Group | `rg-pocghactions-dev` |
| App Service Plan | **F1** (gratis, Windows) |
| Web App BE | `app-pocghactions-dev-be` (.NET 8) |
| Web App FE | `app-pocghactions-dev-fe` (Blazor / .NET 8) |
| Storage + container `templates` | Standard LRS |

Los repos de app:

- [poc-githubactions-be](https://github.com/CarlosRichterR/poc-githubactions-be)
- [poc-githubactions-fe](https://github.com/CarlosRichterR/poc-githubactions-fe)

## Prerrequisitos

1. [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.6  
2. Azure CLI + login:

```bash
az login
az account show
# az account set --subscription "<subscription-id>"
```

## Uso local

```bash
cp terraform.tfvars.example terraform.tfvars   # edita si quieres
terraform init
terraform plan
terraform apply
```

Al terminar el POC:

```bash
terraform destroy
```

## Costo orientativo

- **F1 + Storage LRS**: ~USD 0–1 / mes si lo apagas / destruyes cuando no lo uses.
- **B1 Linux**: ~USD 13 / mes el plan (ambos apps en el mismo plan).

## Estado (state)

Por ahora **local** (archivo `terraform.tfstate` — está en `.gitignore`).  
Cuando quieras remote state (equipo / CI), crea un RG + Storage a mano y descomenta el `backend "azurerm"` en `versions.tf`.

## Siguiente

1. `terraform apply` una vez con tu suscripción Pay-as-you-go.  
2. Workflows en BE/FE para publicar al App Service.  
3. (Opcional) workflow aquí con `terraform plan` en PRs vía OIDC a Azure.
