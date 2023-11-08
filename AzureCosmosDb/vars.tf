variable "location" {
  type        = string
  description = "Azure Region"
  default     = "eastus"
}

variable "cosmos_account_name" {
  type    = string
  default = "shivam-mongodb"
}
variable "cosmos_api" {
  type    = string
  default = "mongo"
}