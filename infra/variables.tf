variable "suffix" {
  description = "Suffix for all resources"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources in"
  type        = string
  default     = "westeurope"
}

variable "subscription_id" {
  description = "Azure Subscription ID to deploy resources into"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID to use for authentication"
  type        = string
}

variable "environment" {
  description = "current environment"
  type        = string
}

variable "log_analytics_name" {
  description = "Log Analytics Workspace Name"
  type        = string
  default     = "law-dev-shared"
}

variable "app_service_app_settings" {
  description = "Application settings to apply to the App Service"
  type        = map(string)
}

variable "function_app_worker_runtime" {
  description = "Worker runtime for the Azure Function App (e.g., python, dotnet)"
  type        = string
}

variable "function_storage_container_name" {
  description = "Container name for the Function App storage account"
  type        = string
}

variable "resource_group_name" {
  description = "Full name of the Azure Resource Group"
  type        = string
}

variable "monitoring_name" {
  description = "Name for monitoring resources (Log Analytics / App Insights)"
  type        = string
}

variable "app_service_name" {
  description = "Name of the App Service"
  type        = string
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the Storage Account"
  type        = string
}

variable "function_app_name" {
  description = "Name of the Function App"
  type        = string
}
