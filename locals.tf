locals {
  enable_auto_scaling = var.worker_node_max_count > var.worker_node_count

  # networking
  vnet_resource_group = var.vnet_resource_group == "" || var.vnet_resource_group == null ? var.cluster_resource_group : var.vnet_resource_group
  allowed_cidrs       = length(var.additional_cidr_blocks) > 0 ? concat(var.additional_cidr_blocks, data.azurerm_subnet.aks.address_prefixes) : data.azurerm_subnet.aks.address_prefixes
}
