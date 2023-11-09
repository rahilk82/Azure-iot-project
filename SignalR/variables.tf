##### Variables for Azure Container Registry #####

variable "location" {
  description = "Azure region to use."
  type        = string
  default     = "eastus"
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Project environment."
  type        = string
  default     = "poc"
}

variable "stack" {
  description = "Project stack name."
  type        = string
  default     = "testingstack"
}

variable "client_name" {
  description = "Client name/account used in naming."
  type        = string
  default     = "shivam-signalR"
}