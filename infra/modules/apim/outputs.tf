output "name" {
  description = "Name of the API Management instance."
  value       = azurerm_api_management.this.name
}

output "id" {
  description = "Resource ID of the API Management instance."
  value       = azurerm_api_management.this.id
}

output "gateway_url" {
  description = "The URL of the gateway for the API Management service."
  value       = azurerm_api_management.this.gateway_url
}
