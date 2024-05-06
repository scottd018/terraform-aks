data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

# NOTE: subnet_id assumes the VNET is located in the same subscription
data "azurerm_subnet" "api" {
  name                 = var.api_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = local.vnet_resource_group
}

# NOTE: subnet_id assumes the VNET is located in the same subscription
data "azurerm_subnet" "aks" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = local.vnet_resource_group
}

# Data source to get the Contributor Role Definition ID
data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}
