# NOTE: this does not work but needs to be enabled to use the vnet_integration_enabled
#       feature in the aks cluster resource
#
# resource "azurerm_resource_provider_registration" "vnet_integration" {
#   name = "Microsoft.ContainerService"
#
#   feature {
#     name       = "EnableAPIServerVnetIntegrationPreview"
#     registered = true
#   }
# }

resource "azurerm_kubernetes_cluster" "cluster" {
  name                       = var.cluster_name
  location                   = var.location
  resource_group_name        = var.cluster_resource_group
  dns_prefix                 = var.private ? null : var.cluster_name
  dns_prefix_private_cluster = var.private ? var.cluster_name : null
  private_cluster_enabled    = var.private
  private_dns_zone_id        = var.private ? azurerm_private_dns_zone.aks.id : null

  #
  # network settings
  #
  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "cilium"
    ebpf_data_plane     = "cilium"
    outbound_type       = var.private ? "userDefinedRouting" : "loadBalancer"
    pod_cidr            = "10.128.0.0/14"
    service_cidr        = "172.16.0.0/16"
    dns_service_ip      = "172.16.0.10" # must be within service_cidr range
    ip_versions         = ["IPv4"]
    load_balancer_sku   = "standard"
  }

  #
  # storage settings
  #
  storage_profile {
    blob_driver_enabled         = false
    disk_driver_enabled         = true
    disk_driver_version         = "v1"
    file_driver_enabled         = true
    snapshot_controller_enabled = true
  }

  #
  # apiserver settings
  #
  api_server_access_profile {
    subnet_id                = data.azurerm_subnet.api.id
    vnet_integration_enabled = true
    authorized_ip_ranges     = local.allowed_cidrs
  }

  #
  # worker settings
  #
  default_node_pool {
    name    = "default"
    vm_size = var.worker_node_size
    tags    = var.tags

    # network settings
    enable_node_public_ip = false
    vnet_subnet_id        = data.azurerm_subnet.aks.id

    # autoscaling settings
    enable_auto_scaling = local.enable_auto_scaling
    node_count          = var.worker_node_count
    min_count           = local.enable_auto_scaling ? var.worker_node_count : null
    max_count           = local.enable_auto_scaling ? var.worker_node_max_count : null
    scale_down_mode     = local.enable_auto_scaling ? "Delete" : null

    # os settings
    os_sku            = "AzureLinux"
    os_disk_type      = "Ephemeral"
    os_disk_size_gb   = var.worker_disk_size_gb
    fips_enabled      = true # temp for testing hypershift
    kubelet_disk_type = "Temporary"

    kubelet_config {
      image_gc_high_threshold = 75
      image_gc_low_threshold  = 60
      pod_max_pid             = 16384
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  tags = var.tags
}
