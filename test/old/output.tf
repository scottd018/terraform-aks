output "subnet_prefixes" {
  value = data.azurerm_subnet.aks.address_prefixes
}

# resource "local_file" "test" {
#   content  = "test"
#   filename = "./output.txt"
# }
