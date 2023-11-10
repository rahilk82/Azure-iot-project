variable "location" {
  description = "Azure region to use."
  type        = string
  default     = "eastus"
}

variable "sku" {
  type    = string
  default = "Standard"
}

variable "resource_group_name" {
    type = string
    default = "rg-testing-shivam-poc"
  
}

variable "storage_account_name" {
  type = string
  default = "sttestingshivamusepoclog"
}

variable "iothub_name" {
    type = string
    default = "shivam-IoTHub"
  
}

variable "client_name" {
    type = string
    default = "edgyneer-account"
  
}

variable "instance_name" {
  type = string
  default = "edgyneer-instance"
}