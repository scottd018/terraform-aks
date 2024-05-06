output "subnet_prefixes" {
  value = data.azurerm_subnet.aks.address_prefixes
}
