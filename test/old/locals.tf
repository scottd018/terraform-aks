locals {
  vnet_resource_group = var.vnet_resource_group == "" || var.vnet_resource_group == null ? var.cluster_resource_group : var.vnet_resource_group
}
