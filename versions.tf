terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Estado local al empezar (cero costo / cero bootstrap).
  # Cuando quieras remote state, descomenta y crea el storage a mano una vez:
  #
  # backend "azurerm" {
  #   resource_group_name  = "rg-poc-tfstate"
  #   storage_account_name = "stpoctfstateXXXX"
  #   container_name       = "tfstate"
  #   key                  = "poc/dev.terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
  # En suscripciones nuevas el default registra docenas de providers (lento / se cuelga).
  # Solo registramos lo que usa este POC: App Service + Storage.
  resource_provider_registrations = "none"
  resource_providers_to_register = [
    "Microsoft.Web",
    "Microsoft.Storage",
  ]
  # Subscription: `az login` + `az account set --subscription ...`
}
