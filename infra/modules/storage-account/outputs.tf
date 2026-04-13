output "id" {
  description = "The ID of the storage account."
  value       = azurerm_storage_account.this.id
}

output "primary_connection_string" {
  description = "Primary connection string for the storage account."
  value       = azurerm_storage_account.this.primary_connection_string
  sensitive   = true
}

output "primary_access_key" {
  description = "Primary access key for the storage account."
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}

output "name" {
  description = "The name of the storage account."
  value       = azurerm_storage_account.this.name
}