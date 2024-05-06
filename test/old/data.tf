data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

# NOTE: subnet_id assumes the VNET is located in the same subscription
data "azurerm_subnet" "aks" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = local.vnet_resource_group
}
