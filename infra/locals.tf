locals {
  common_tags = {
    owner       = "matglo"
    managed_by  = "matglo"
    department  = "startup"
    environment = var.environment
  }
}

output "common_tags" { value = local.common_tags }