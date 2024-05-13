resource "azurerm_subnet" "api" {
  name                                           = "${var.cluster_name}-aks-cp-subnet"
  resource_group_name                            = local.vnet_resource_group
  virtual_network_name                           = var.vnet_name
  address_prefixes                               = [var.api_subnet_cidr]
  service_endpoints                              = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
  enforce_private_link_service_network_policies  = true
  enforce_private_link_endpoint_network_policies = true

  delegation {
    name = "${var.cluster_name}-aks-cp-subnet"

    service_delegation {
      name = "Microsoft.ContainerService/managedClusters"
    }
  }
}

resource "azurerm_subnet" "aks" {
  name                 = "${var.cluster_name}-aks-machine-subnet"
  resource_group_name  = local.vnet_resource_group
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_cidr]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
}

# TODO: make this the proper bastion subnet and add bastion with name AzureBastionSubnet
resource "azurerm_subnet" "bastion" {
  count = var.private ? 1 : 0

  name                 = "${var.cluster_name}-aks-bastion"
  resource_group_name  = local.vnet_resource_group
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.bastion_cidr]
}

resource "azurerm_subnet_route_table_association" "api" {
  count = var.private ? 1 : 0

  subnet_id      = azurerm_subnet.api.id
  route_table_id = data.azurerm_route_table.aks[0].id
}

resource "azurerm_subnet_route_table_association" "aks" {
  count = var.private ? 1 : 0

  subnet_id      = azurerm_subnet.aks.id
  route_table_id = data.azurerm_route_table.aks[0].id
}
