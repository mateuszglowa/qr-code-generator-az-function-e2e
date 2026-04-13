resource "azurerm_service_plan" "this" {
  name                = var.plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "this" {
  name                = "${var.name}-webapp"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id
  //key_vault_reference_identity_id          = "SystemAssigned"
  public_network_access_enabled = true
  site_config {
    always_on                               = false
    container_registry_use_managed_identity = false
    default_documents                       = ["Default.htm", "Default.html", "Default.asp", "index.htm", "index.html", "iisstart.htm", "default.aspx", "index.php", "hostingstart.html"]
    ftps_state                              = "FtpsOnly"
    //health_check_eviction_time_in_min             = 0
    http2_enabled               = false
    load_balancing_mode         = "LeastRequests"
    local_mysql_enabled         = false
    managed_pipeline_mode       = "Integrated"
    minimum_tls_version         = "1.2"
    remote_debugging_enabled    = false
    scm_minimum_tls_version     = "1.2"
    scm_use_main_ip_restriction = false
    vnet_route_all_enabled      = false
    websockets_enabled          = false
    worker_count                = 1
    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = var.app_settings
}

resource "azurerm_linux_web_app_slot" "staging" {
  name           = "${var.name}-staging"
  app_service_id = azurerm_linux_web_app.this.id

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = var.app_settings
}