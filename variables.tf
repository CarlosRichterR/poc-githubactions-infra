variable "project_name" {
  type        = string
  description = "Prefijo corto para nombres de recursos (solo minúsculas/números)."
  default     = "pocghactions"

  validation {
    condition     = can(regex("^[a-z0-9]{3,16}$", var.project_name))
    error_message = "project_name debe ser 3-16 chars [a-z0-9]."
  }
}

variable "environment" {
  type        = string
  description = "Nombre del entorno (dev, test, ...)."
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Región de Azure."
  default     = "eastus"
}

variable "tags" {
  type        = map(string)
  description = "Tags comunes."
  default = {
    project = "poc-githubactions"
    managed = "terraform"
  }
}

variable "app_service_sku" {
  type        = string
  description = "SKU del App Service Plan. F1 = gratis (Windows). B1 = ~USD 13/mes (Linux/Windows)."
  default     = "F1"
}

variable "os_type" {
  type        = string
  description = "Windows (permite F1) o Linux (usar B1+)."
  default     = "Windows"

  validation {
    condition     = contains(["Windows", "Linux"], var.os_type)
    error_message = "os_type debe ser Windows o Linux."
  }
}
