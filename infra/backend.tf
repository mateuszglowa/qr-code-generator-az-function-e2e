terraform {
    backend "azurerm" {
        resource_group_name  = "rg-tf-backend"  # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
        storage_account_name = "tfbackendstoragemg"                      # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
        container_name       = "day18-backend-container"                 # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
        key                  = "day18.terraform.tfstate"                 # Can be passed via `
    }
}