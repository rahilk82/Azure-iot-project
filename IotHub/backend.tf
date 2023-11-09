terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-file"
    storage_account_name = "terraformdemo7276"
    container_name       = "terraform-state-storage"
    key                  = "terraform-state-file-in-iothub"
  }
}
