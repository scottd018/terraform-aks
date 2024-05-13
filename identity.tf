resource "azurerm_user_assigned_identity" "aks" {
  name                = "${var.cluster_name}-aks"
  resource_group_name = var.cluster_resource_group
  location            = var.location
  tags                = var.tags
}

# TODO: these are highly open for an initial POC...need to lock down
resource "azurerm_role_assignment" "aks_dns" {
  scope                = azurerm_private_dns_zone.aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "aks_subnet" {
  scope                = azurerm_subnet.aks.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "aks_api_subnet" {
  scope                = azurerm_subnet.api.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "subscription" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = data.azurerm_role_definition.contributor.id
  principal_id       = azurerm_user_assigned_identity.aks.principal_id
}
