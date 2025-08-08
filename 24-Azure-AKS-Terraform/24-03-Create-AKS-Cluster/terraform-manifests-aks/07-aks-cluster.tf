# Provision AKS Cluster
/*
1. Add Basic Cluster Settings
  - Get Latest Kubernetes Version from datasource (kubernetes_version)
  - Add Node Resource Group (node_resource_group)
2. Add Default Node Pool Settings
  - orchestrator_version (latest kubernetes version using datasource)
  - availability_zones
  - enable_auto_scaling
  - max_count, min_count
  - os_disk_size_gb
  - type
  - node_labels
  - tags
3. Enable MSI
4. Add On Profiles 
  - Azure Policy
  - Azure Monitor (Reference Log Analytics Workspace id)
5. RBAC & Azure AD Integration
6. Admin Profiles
  - Windows Admin Profile
  - Linux Profile
7. Network Profile
8. Cluster Tags  
*/
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${azurerm_resource_group.aks_rg.name}-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "${azurerm_resource_group.aks_rg.name}-cluster"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${azurerm_resource_group.aks_rg.name}-nrg"
                        

  default_node_pool {
    name       = "systempool"
    # node_count = 1
    vm_size    = "standard_d2als_v6"
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    zones = ["1", "2", "3"]
    # enable_auto_scaling = true
    auto_scaling_enabled = true
    min_count = 1
    max_count = 3
    os_disk_size_gb = 30
    type = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type" : "system"
      "environment" = "dev"
      "nodepools" = "linux"
      "app" = "system-apps"

    }
    tags = {
      "nodepool-type" = "system"
      "environment" = "dev"
      "nodepools" = "linux"
      "app" = "system-apps"
    }
  }

  # Identity are system assigned or user assigned
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster#identity
  # https://learn.microsoft.com/en-us/azure/aks/use-managed-identity
  identity {
    type = "SystemAssigned"
  }

  # add on profiles
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
  }
  # RBAC & Azure AD Integration
  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
    tenant_id = data.azurerm_client_config.current.tenant_id
    admin_group_object_ids = [azuread_group.aks_administrators.object_id]
  
  }

  # Windows Admin Profile
  windows_profile {
    admin_username = var.windows_admin_username
    admin_password = var.windows_admin_password
    # enable_ssh = true
    # ssh_key = file(var.ssh_public_key)
  }

  # Linux Profile
  linux_profile {
    admin_username = "pawanazureuser"
    # enable_ssh = true
    # ssh_key = file(var.ssh_public_key)
    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  # Network Profile
  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
    load_balancer_sku = "standard"
    load_balancer_profile {
      # managed_outbound_ip_count = 1
      # outbound_ip_address_ids = [azurerm_public_ip.aks_lb_public_ip.id]
    }
  }

  tags = {
    Environment = "dev"
  }
}