########### Data Source for Existing Resources #############

data "azurerm_resource_group" "existing_resource_group" {
  name = "rg-testing-shivam-poc"
}

########### Existing IoTHub ###################

data "azurerm_iothub" "existing_iothub" {
  name                = var.iothub_name
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name
}


########### IoTHub Shared Polcy #################

data "azurerm_iothub_shared_access_policy" "existing_shared" {
  name                = "iothubowner"
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name
  iothub_name         = data.azurerm_iothub.existing_iothub.name
}

####### DPS #########

resource "azurerm_iothub_dps" "dps_device" {
  name                = var.instance_name
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name
  location            = var.location
  allocation_policy   = "Hashed"

  linked_hub {
    connection_string = data.azurerm_iothub_shared_access_policy.existing_shared.primary_connection_string
    location = data.azurerm_resource_group.existing_resource_group.location
    allocation_weight = 150
    apply_allocation_policy = true
  }

  sku {
    name     = "S1"
    capacity = "1"
  }
}


######### DPS Shared Policy ##########

resource "azurerm_iothub_dps_shared_access_policy" "dps_shared_policy" {
  name                = var.shared_policy_name
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name
  iothub_dps_name     = azurerm_iothub_dps.dps_device.name

  enrollment_write   = true
  enrollment_read    = true
  registration_read  = true
  registration_write = true
}