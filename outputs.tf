output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "location" {
  value = azurerm_resource_group.main.location
}

output "app_service_plan_name" {
  value = azurerm_service_plan.main.name
}

output "backend_app_name" {
  value = var.os_type == "Windows" ? azurerm_windows_web_app.be[0].name : azurerm_linux_web_app.be[0].name
}

output "backend_url" {
  value = var.os_type == "Windows" ? "https://${azurerm_windows_web_app.be[0].default_hostname}" : "https://${azurerm_linux_web_app.be[0].default_hostname}"
}

output "frontend_app_name" {
  value = var.os_type == "Windows" ? azurerm_windows_web_app.fe[0].name : azurerm_linux_web_app.fe[0].name
}

output "frontend_url" {
  value = var.os_type == "Windows" ? "https://${azurerm_windows_web_app.fe[0].default_hostname}" : "https://${azurerm_linux_web_app.fe[0].default_hostname}"
}

output "storage_account_name" {
  value = azurerm_storage_account.poc.name
}

output "templates_container" {
  value = azurerm_storage_container.templates.name
}
