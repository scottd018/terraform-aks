module "test" {
  source = "../"

  cluster_name           = "dscott-aks"
  cluster_resource_group = "dscott-rg"
  location               = "eastus"

  private                = true
  vnet_resource_group    = "dscott-rg"
  vnet_name              = "dscott-vnet"
  api_subnet_name        = "dscott-cp-subnet"
  subnet_name            = "dscott-machine-subnet"
  additional_cidr_blocks = ["0.0.0.0/0"]

  worker_node_size      = "Standard_D4s_v3"
  worker_node_count     = 1
  worker_node_max_count = 3
  worker_disk_size_gb   = 500

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
