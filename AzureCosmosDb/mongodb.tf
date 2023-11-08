data "azurerm_resource_group" "existing_resource_group" {
  name = "rg-testing-shivam-poc"
}

module "cosmosdb" {
  source              = "Azure/cosmosdb/azurerm"
  version             = "1.0.0"
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name
  location            = var.location
  cosmos_account_name = var.cosmos_account_name
  cosmos_api          = var.cosmos_api
  capabilities = {
    "mongo": "EnableMongo"
  }
  additional_capabilities = [
       "EnableServerless"
    ]
}