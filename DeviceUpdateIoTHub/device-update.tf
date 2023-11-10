
####### Existing Resource Group ######################

data "azurerm_resource_group" "existing_resource_group" {
  name = var.resource_group_name                      ####Update your resource group here
}

############ Existing IotHub #####################

data "azurerm_iothub" "existing_iothub" {
  name                = var.iothub_name               ####Give your IotHub Name here
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name
}


############ Existing Storage Account #################

data "azurerm_storage_account" "existing_storage_account" {
  name                = var.storage_account_name                #####Give your Storage Account name here
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name
}

################# Account Creation for Device Update of IoThub

resource "azurerm_iothub_device_update_account" "device_account" {
  name                          = var.client_name
  resource_group_name           = data.azurerm_resource_group.existing_resource_group.name
  location                      = var.location
  sku                           = var.sku
  public_network_access_enabled = "true"
  identity {
    type = "SystemAssigned"

  }

  tags = {
    Owner   = "Shivam"
    Project = "Edyneer"
  }
}


#################### Storage account mapping and Instance creation ###########################

resource "azurerm_iothub_device_update_instance" "example" {
  name                     = var.instance_name
  device_update_account_id = azurerm_iothub_device_update_account.device_account.id
  iothub_id                = data.azurerm_iothub.existing_iothub.id
  diagnostic_enabled       = true

  diagnostic_storage_account {
    connection_string = data.azurerm_storage_account.existing_storage_account.primary_connection_string
    id                = data.azurerm_storage_account.existing_storage_account.id
  }

  tags = {
    Owner   = "Shivam"
    Project = "Edyneer"
  }
}

########## Mapping the role to the Device Update service ##################

resource "azurerm_role_assignment" "iothub_data_contributor" {
  scope                = azurerm_iothub_device_update_instance.example.id
  role_definition_name = "IoT Hub Data Contributor"
  principal_id         = "22513a8e-8df6-48f9-b97b-5482c438404a"  # Replace with the object_id of the user or service principal
}