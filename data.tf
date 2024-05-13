data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

# NOTE: this is not ideal but doing this quick for a POC.  take the route table
#       that is existing and use it for the subnets we create.
data "azurerm_route_table" "aks" {
  count = var.private ? 1 : 0

  name                = var.route_table_name
  resource_group_name = local.vnet_resource_group
}

# Data source to get the Contributor Role Definition ID
data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}
