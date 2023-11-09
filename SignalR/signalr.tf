#Run this 2 commands before running the SignalR terraform code

# az provider register --namespace Microsoft.SignalRService
# az provider show --namespace Microsoft.SignalRService --query "registrationState"



data "azurerm_resource_group" "existing_resource_group" {
  name = "rg-testing-shivam-poc"
}

module "signalr" {
  source  = "claranet/signalr/azurerm"
  version = "6.0.0"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = var.location
  location_short      = var.location_short
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name
  service_mode        = "Serverless"

  sku = {
    name     = "Standard_S1"
    capacity = 1
  }

  network_rules = [
    {
      name      = "AllowClientConnection"
      rule_type = "allow"
      endpoint  = "public-network"
      services  = ["ClientConnection"]
    },
    {
      name      = "DenyAllOthers"
      rule_type = "deny"
      endpoint  = "public-network"
      services  = ["ServerConnection", "RESTAPI"]
    }
  ]
}