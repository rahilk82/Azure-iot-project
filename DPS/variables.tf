variable "location" {
  description = "Azure region to use."
  type        = string
  default     = "eastus"
}

variable "instance_name" {
  type    = string
  default = "edgyneer-dps-instance"
}

variable "iothub_name" {
    type = string
    default = "shivam-IoTHub"
  
}


variable "shared_policy_name" {
  type    = string
  default = "edgyneer-shared-policy"
}