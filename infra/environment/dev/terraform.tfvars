# Azure region to deploy resources into
location = "polandcentral"

# Environment name (used in resource naming)
environment = "development"
# The Log Analytics workspace name to use for monitoring
log_analytics_name = "law-dev-shared"

# Global suffix to apply to resource names
suffix = "qrcode"

# Azure subscription & tenant used for deployment
subscription_id = "75e8aac1-d90c-4d46-b9af-e73a819a4968"
tenant_id       = "4ce7bca3-7d98-4d2d-afb5-a9bbc223460e"

# The Resource Group in which resources will be created
resource_group_name = "rg-dev-qrcode"

# Name used for monitoring resources (Log Analytics / App Insights)
monitoring_name     = "qrcode-monx"

# App Service resource naming
app_service_name      = "webapp-dev-qrcode"
app_service_plan_name = "asp-dev-qrcode"

# Storage Account naming
storage_account_name = "stdevqrcodesa"

# Function App naming
function_app_name   = "funcapp-dev-qrcode"

# App Service application settings
app_service_app_settings = {
  QR_CODE_CONTAINER_NAME   = "funcapp-qrcode-container"
  QR_CODE_SAS_EXPIRY_MINUTES = "15"
}

# Function runtime (python, dotnet, node, etc.)
function_app_worker_runtime = "python"

# Storage container for Function App (must exist in storage account)
function_storage_container_name = "funcapp-qrcode-container"