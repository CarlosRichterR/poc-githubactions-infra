locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = merge(var.tags, {
    environment = var.environment
  })
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = local.common_tags
}

# Un plan compartido: BE (.NET) + FE (estático/Node) en el mismo SKU barato.
resource "azurerm_service_plan" "main" {
  name                = "asp-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = var.os_type
  sku_name            = var.app_service_sku
  tags                = local.common_tags
}

resource "azurerm_windows_web_app" "be" {
  count = var.os_type == "Windows" ? 1 : 0

  name                = "app-${local.name_prefix}-be"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true
  tags                = local.common_tags

  site_config {
    always_on = var.app_service_sku != "F1"

    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v8.0"
    }

    cors {
      allowed_origins = [
        "https://app-${local.name_prefix}-fe.azurewebsites.net",
        "http://localhost:5048"
      ]
      support_credentials = false
    }
  }

  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = var.environment == "dev" ? "Development" : "Production"
    "App__WelcomeMessage"    = "POC backend on Azure (${var.environment})"
  }
}

resource "azurerm_windows_web_app" "fe" {
  count = var.os_type == "Windows" ? 1 : 0

  name                = "app-${local.name_prefix}-fe"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true
  tags                = local.common_tags

  site_config {
    always_on = var.app_service_sku != "F1"

    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v8.0"
    }
  }

  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = var.environment == "dev" ? "Development" : "Production"
    "Api__BaseUrl"           = "https://app-${local.name_prefix}-be.azurewebsites.net"
  }
}

resource "azurerm_linux_web_app" "be" {
  count = var.os_type == "Linux" ? 1 : 0

  name                = "app-${local.name_prefix}-be"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true
  tags                = local.common_tags

  site_config {
    always_on = var.app_service_sku != "F1"

    application_stack {
      dotnet_version = "8.0"
    }

    cors {
      allowed_origins = [
        "https://app-${local.name_prefix}-fe.azurewebsites.net",
        "http://localhost:5048"
      ]
    }
  }

  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = var.environment == "dev" ? "Development" : "Production"
    "App__WelcomeMessage"    = "POC backend on Azure (${var.environment})"
  }
}

resource "azurerm_linux_web_app" "fe" {
  count = var.os_type == "Linux" ? 1 : 0

  name                = "app-${local.name_prefix}-fe"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true
  tags                = local.common_tags

  site_config {
    always_on = var.app_service_sku != "F1"

    application_stack {
      dotnet_version = "8.0"
    }
  }

  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = var.environment == "dev" ? "Development" : "Production"
    "Api__BaseUrl"           = "https://app-${local.name_prefix}-be.azurewebsites.net"
  }
}

# Storage barato: útil luego para templates/blobs o artefactos del POC.
resource "azurerm_storage_account" "poc" {
  name                     = substr(replace("st${var.project_name}${var.environment}", "-", ""), 0, 24)
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = local.common_tags
}

resource "azurerm_storage_container" "templates" {
  name                  = "templates"
  storage_account_id    = azurerm_storage_account.poc.id
  container_access_type = "private"
}
