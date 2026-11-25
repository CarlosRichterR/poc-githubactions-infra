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
  # Subscription: usa `az login` + `az account set --subscription ...`
  # o ARM_SUBSCRIPTION_ID / ARM_CLIENT_ID en CI.
}
