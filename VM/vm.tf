########## Existing Resource Group ##############

data "azurerm_resource_group" "existing_resource_group" {
  name = "rg-testing-shivam-poc"
}

########## Existing Network Interface ############

data "azurerm_virtual_network" "existing_vnetwork" {
  name                = var.existing_virtual_network
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name
}

data "azurerm_subnet" "existing_subnet" {
  name                 = var.existing_subnet
  virtual_network_name = data.azurerm_virtual_network.existing_vnetwork.name
  resource_group_name  = data.azurerm_resource_group.existing_resource_group.name
}


######### Public IP Creation ########

resource "azurerm_public_ip" "ip_config" {
  allocation_method   = "Static"
  location            = var.location
  name                = "edgyneer-pub-ip"
  sku                 = "Standard"
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name
}
######### Virtual Machine ###########

module "virtual-machine" {
  source              = "Azure/virtual-machine/azurerm"
  version             = "1.0.0"
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  new_network_interface = {
    ip_forwarding_enabled = true
    ip_configurations = [{
      public_ip_address_id = azurerm_public_ip.ip_config.id
      primary              = true
    }]
  }
  image_os                        = "linux"
  location                        = var.location
  disable_password_authentication = false
  name                            = var.instance_name
  subnet_id                       = data.azurerm_subnet.existing_subnet.id
  size                            = "Standard_F2"
  os_simple                       = "UbuntuServer"
  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              sudo systemctl enable nginx
              sudo systemctl start nginx
              sudo systemctl status nginx
              EOF
  )
}