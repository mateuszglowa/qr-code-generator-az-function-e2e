
module "resource_group" {
  source = "./modules/resource-group"

  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Log Analytics & Application Insights
module "monitoring" {
  source = "./modules/monitoring"

  name                = var.monitoring_name
  resource_group_name = module.resource_group.name
  location            = var.location
}

module "storage_account" {
  source = "./modules/storage-account"

  name                = var.storage_account_name
  resource_group_name = module.resource_group.name
  location            = var.location
  tags                = local.common_tags
}

module "function_app" {
  source = "./modules/function"

  function_name       = var.function_app_name
  resource_group_name = module.resource_group.name
  location            = var.location

  app_settings = {
    for key, value in merge(
      var.app_service_app_settings, 
      {
        "AzureWebJobsStorage"        = module.storage_account.primary_connection_string
        "QR_CODE_CONTAINER_NAME"     = var.function_storage_container_name
        "QR_CODE_SAS_EXPIRY_MINUTES" = "15"
      }
    ) : key => value
  }
  storage_account = {
    name               = module.storage_account.name
    id                 = module.storage_account.id
    container_name     = var.function_storage_container_name
    primary_access_key = module.storage_account.primary_access_key
  }
  tags = local.common_tags
}

module "identity" {
  source = "./modules/identity"

  name                = "${var.environment}-identity-${var.suffix}"
  resource_group_name = module.resource_group.name
  location            = var.location
}