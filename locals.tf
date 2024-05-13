locals {
  enable_auto_scaling = var.worker_node_max_count > var.worker_node_count

  # networking
  vnet_resource_group = var.vnet_resource_group == "" || var.vnet_resource_group == null ? var.cluster_resource_group : var.vnet_resource_group
  allowed_cidrs       = length(var.additional_cidr_blocks) > 0 ? concat(var.additional_cidr_blocks, azurerm_subnet.aks.address_prefixes) : azurerm_subnet.aks.address_prefixes

  # ssh
  ssh_public_key = var.worker_ssh_public_key == "" || var.worker_ssh_public_key == null ? null : var.worker_ssh_public_key
  ssh_username   = var.worker_ssh_public_key == "" || var.worker_ssh_public_key == null ? null : "aks-user"
}
