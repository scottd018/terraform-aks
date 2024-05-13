module "test" {
  source = "../"

  cluster_name           = "dscott-aks"
  cluster_resource_group = "dscott-rg"
  location               = "eastus"

  private                = true
  vnet_resource_group    = "dscott-rg"
  vnet_name              = "dscott-vnet"
  route_table_name       = "dscott-fw-rt"
  api_subnet_cidr        = "10.0.8.0/23"
  subnet_cidr            = "10.0.10.0/23"
  bastion_cidr           = "10.0.12.64/26"
  additional_cidr_blocks = ["0.0.0.0/0"]

  worker_node_size      = "Standard_D8s_v3"
  worker_node_count     = 1
  worker_node_max_count = 3
  worker_disk_size_gb   = 128
  worker_ssh_public_key = file("~/.ssh/id_rsa.pub")

  tags = {
    "app-code"      = "MOBB-001"
    "cost-center"   = "CC468"
    "service-phase" = "lab"
    environment     = "development"
    owner           = "dscott_redhat.com"
  }
}

output "test" {
  value = module.test
}
