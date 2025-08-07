# Create Outputs
# 1. Resource Group Location
# 2. Resource Group Id
# 3. Resource Group Name

output "location" {
  value = azurerm_resource_group.aks_rg.location
}

output "resource_group_id" {
  value = azurerm_resource_group.aks_rg.id
}   

output "resource_group_name" {
  value = azurerm_resource_group.aks_rg.name
  
}

variable "ssh_public_key" {
    default = "~/.ssh/aks-prod-sshkeys-terraform/aksprodsshkey.pub"
    description = "This variable defines the SSH Public Key for Linux k8s Worker nodes"  
}

# Windows Admin Username for k8s worker nodes
variable "windows_admin_username" {
    type = string
    default = "azureuser"
    description = "This variable defines the Windows admin username k8s Worker nodes"  
}

# Windows Admin Password for k8s worker nodes
variable "windows_admin_password" {
    type = string
    default = "HiIAmFromGorakhpur@1984"
    description = "This variable defines the Windows admin password k8s Worker nodes"  
}				
