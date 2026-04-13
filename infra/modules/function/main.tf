
resource "azurerm_service_plan" "this" {
  name                         = "asp-${var.function_name}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  os_type                      = "Linux"
  sku_name                     = "FC1"
  maximum_elastic_worker_count = 1
  zone_balancing_enabled       = false
}


resource "azurerm_storage_container" "function_container" {
  name                  = var.storage_account.container_name
  storage_account_id    = var.storage_account.id
  container_access_type = "private"
}


resource "azurerm_function_app_flex_consumption" "this" {
  name                = var.function_name
  resource_group_name = var.resource_group_name
  location            = var.location

  service_plan_id               = azurerm_service_plan.this.id
  instance_memory_in_mb         = 512
  maximum_instance_count        = 100
  public_network_access_enabled = true
  runtime_name                  = "python"
  runtime_version               = "3.13"
  storage_authentication_type   = "StorageAccountConnectionString"
  storage_access_key            = var.storage_account.primary_access_key
  storage_container_endpoint    = "https://${var.storage_account.name}.blob.core.windows.net/${var.storage_account.container_name}"
  # storage_container_endpoint         = "https://sargdevday17b5c0.blob.core.windows.net/app-package-tralaltest-e841da9"
  storage_container_type = "blobContainer"
  app_settings           = var.app_settings
  tags                   = var.tags
  site_config {
    cors {
      allowed_origins = ["https://portal.azure.com"]
    }
  }

}