variable "admin_username" {
  type    = string
  default = "edgyneer"
}


variable "location" {
  type    = string
  default = "eastus"
}

variable "instance_name" {
  type    = string
  default = "edgyneer-instance"

}

variable "admin_password" {
  type        = string
  description = "This is the password for the Virtual Machine"
  sensitive   = true
}

variable "existing_subnet" {
  type    = string
  default = "default"

}

variable "existing_virtual_network" {
  type    = string
  default = "edgyneer-network"

}
