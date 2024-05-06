variable "cluster_resource_group" {
  type        = string
  default     = "dscott-rg"
  description = "AKS resource group name"
}

#
# network settings
#
variable "vnet_resource_group" {
  type        = string
  default     = null
  description = "AKS VNET resource group name (defaults to 'cluster_resource_group' if unspecified)"
}

variable "vnet_name" {
  type        = string
  description = "VNET name to use for the worker nodes"
  default     = "dscott-vnet"

  validation {
    condition     = var.vnet_name != "" && var.vnet_name != null
    error_message = "Invalid 'vnet_name'. Must be not be empty."
  }
}

variable "subnet_name" {
  type        = string
  description = "Subnet name to use for the worker nodes (Must exist within 'vnet_name')"
  default     = "dscott-machine-subnet"

  validation {
    condition     = var.subnet_name != "" && var.subnet_name != null
    error_message = "Invalid 'subnet_name'. Must be not be empty."
  }
}
