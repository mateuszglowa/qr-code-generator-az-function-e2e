resource "azurerm_postgresql_flexible_server" "this" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "15"
  administrator_login    = var.admin_username
  administrator_password = var.admin_password

  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768

  backup_retention_days = 7
  zone                  = "1"

  public_network_access_enabled = true
}

resource "azurerm_postgresql_flexible_server_database" "this" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.this.id

  depends_on = [azurerm_postgresql_flexible_server.this]
}

# # Create firewall rule for Azure services
# resource "azurerm_postgresql_flexible_server_firewall_rule" "azure_services" {
#   count = var.allow_azure_services ? 1 : 0

#   name             = "AllowAzureServices"
#   server_id        = azurerm_postgresql_flexible_server.this.id
#   start_ip_address = "0.0.0.0"
#   end_ip_address   = "0.0.0.0"
# }

# Store connection string in Key Vault (if Key Vault ID is provided)
# resource "azurerm_key_vault_secret" "postgres_connection_string" {
#   count = var.key_vault_id != null ? 1 : 0

#   name         = "postgres-connection-string"
#   value        = "host=${azurerm_postgresql_flexible_server.this.fqdn} port=5432 dbname=${azurerm_postgresql_flexible_server_database.this.name} user=${var.administrator_login} password=${var.administrator_password} sslmode=require"
#   key_vault_id = var.key_vault_id

#   tags = var.tags

#   depends_on = [var.key_vault_depends_on]
# }