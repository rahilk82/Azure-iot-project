########### Data Source for Existing Resources #############

data "azurerm_resource_group" "existing_resource_group" {
  name = "rg-testing-shivam-poc"
}

data "azurerm_storage_account" "existing_storage_account" {
  name                = "sttestingshivamusepoclog"
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name
}

data "azurerm_storage_container" "existing_storage_container" {
  name                 = "blobcontainer"
  storage_account_name = data.azurerm_storage_account.existing_storage_account.name
}

################# Resources to provision IOT HUB ###################

resource "azurerm_eventhub_namespace" "iot_namespace" {
  name                = "shivam-namespace"
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name
  location            = var.location
  sku                 = "Basic"
}

resource "azurerm_eventhub" "iot_eventhub" {
  name                = "shivam-eventhub"
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name
  namespace_name      = azurerm_eventhub_namespace.iot_namespace.name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "eventhub_rule" {
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name
  namespace_name      = azurerm_eventhub_namespace.iot_namespace.name
  eventhub_name       = azurerm_eventhub.iot_eventhub.name
  name                = "shivamtest"
  send                = true
}

resource "azurerm_iothub" "iothub_poc" {
  name                         = "shivam-IoTHub"
  resource_group_name          = data.azurerm_resource_group.existing_resource_group.name
  location                     = var.location
  # local_authentication_enabled = false

  sku {
    name     = "S1"
    capacity = "1"
  }

  endpoint {
    type                       = "AzureIotHub.StorageContainer"
    connection_string          = data.azurerm_storage_account.existing_storage_account.primary_blob_connection_string
    name                       = "export"
    batch_frequency_in_seconds = 60
    max_chunk_size_in_bytes    = 10485760
    container_name             = data.azurerm_storage_container.existing_storage_container.name
    encoding                   = "Avro"
    file_name_format           = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
  }

  endpoint {
    type              = "AzureIotHub.EventHub"
    connection_string = azurerm_eventhub_authorization_rule.eventhub_rule.primary_connection_string
    name              = "export2"
  }

  route {
    name           = "export"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["export"]
    enabled        = true
  }

  route {
    name           = "export2"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["export2"]
    enabled        = true
  }

  enrichment {
    key            = "tenant"
    value          = "$twin.tags.Tenant"
    endpoint_names = ["export", "export2"]
  }

  cloud_to_device {
    max_delivery_count = 30
    default_ttl        = "PT1H"
    feedback {
      time_to_live       = "PT1H10M"
      max_delivery_count = 15
      lock_duration      = "PT30S"
    }
  }

  tags = {
    purpose = "poc"
  }
}