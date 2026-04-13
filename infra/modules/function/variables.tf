
variable "function_name" {
  description = "Name of the Function App"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "app_settings" {
  description = "Application settings map"
  type        = map(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "storage_account" {
  description = "Storage account details for Function App"
  type = object({
    name               = string
    id                 = string
    primary_access_key = string
    container_name     = string
  })
}