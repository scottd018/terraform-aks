variable "cluster_name" {
  type        = string
  default     = "dscott-aks"
  description = "AKS cluster name"
}

variable "tags" {
  type = map(string)
  default = {
    environment = "development"
    owner       = "dscott_redhat.com"
  }
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region"
}

variable "cluster_resource_group" {
  type        = string
  default     = null
  description = "AKS resource group name"

  validation {
    condition     = var.cluster_resource_group != "" && var.cluster_resource_group != null
    error_message = "Invalid 'cluster_resource_group'. Must be not be empty."
  }
}

variable "private" {
  type        = bool
  description = "Private cluster"
  default     = false
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
  default     = null

  validation {
    condition     = var.vnet_name != "" && var.vnet_name != null
    error_message = "Invalid 'vnet_name'. Must be not be empty."
  }
}

variable "api_subnet_name" {
  type        = string
  description = "Subnet name to use for the API endpoint (Must exist within 'vnet_name')"
  default     = null

  validation {
    condition     = var.api_subnet_name != "" && var.api_subnet_name != null
    error_message = "Invalid 'api_subnet_name'. Must be not be empty."
  }
}

variable "subnet_name" {
  type        = string
  description = "Subnet name to use for the worker nodes (Must exist within 'vnet_name')"
  default     = null

  validation {
    condition     = var.subnet_name != "" && var.subnet_name != null
    error_message = "Invalid 'subnet_name'. Must be not be empty."
  }
}

#
# control plane settings
#
variable "additional_cidr_blocks" {
  type        = list(string)
  description = "Additonal CIDR blocks, beyond the VNET CIDR block"
  default     = []
}

#
# worker settings
#
variable "worker_node_size" {
  type        = string
  description = "VM size for the worker VMs."
  default     = "Standard_D4s_v3"

  validation {
    condition     = var.worker_node_size != "" && var.worker_node_size != null
    error_message = "Invalid 'worker_node_size'. Must be not be empty."
  }
}

variable "worker_node_count" {
  type        = number
  default     = 1
  description = "Number of worker nodes (minimum = 1)."

  validation {
    condition     = var.worker_node_count >= 1
    error_message = "Invalid 'worker_node_count'. Minimum of 1."
  }
}

# NOTE: the actual max size here is 1000, but restricting this down for the demo
#       so I cannot typo a large number in here.
variable "worker_node_max_count" {
  type        = number
  default     = 1
  description = "Number of maximum worker nodes (maximum = 10)."

  validation {
    condition     = var.worker_node_max_count <= 10
    error_message = "Invalid 'worker_node_max_count'. Maximum of 10."
  }
}

variable "worker_disk_size_gb" {
  type        = number
  default     = 128
  description = "Disk size for the worker nodes."

  validation {
    condition     = var.worker_disk_size_gb >= 128
    error_message = "Invalid 'worker_disk_size_gb'. Minimum of 128GB."
  }
}

# variable "aks_admin_username" {
#   type        = string
#   default     = "aks-user"
#   description = "Admin username for the AKS worker nodes"
#   sensitive   = true

#   validation {
#     condition     = var.aks_admin_username != "" && var.aks_admin_username != null
#     error_message = "Invalid 'aks_admin_username'. Must be not be empty."
#   }
# }

# variable "aks_admin_password" {
#   type        = string
#   description = "Admin passoword for the AKS worker nodes"
#   sensitive   = true

#   validation {
#     condition     = var.aks_admin_password != "" && var.aks_admin_password != null
#     error_message = "Invalid 'aks_admin_password'. Must be not be empty."
#   }
# }
