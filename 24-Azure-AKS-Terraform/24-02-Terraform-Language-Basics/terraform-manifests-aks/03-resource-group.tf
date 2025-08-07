# Terraform Resource to Create Azure Resource Group with Input Variables defined in variables.tf

resource "azurerm_resource_group" "aks_rg" {
  name = var.resource_group_name
  location = var.location
  tags = {
    environment = var.environment
    created_by  = "Terraform"
  }
}
