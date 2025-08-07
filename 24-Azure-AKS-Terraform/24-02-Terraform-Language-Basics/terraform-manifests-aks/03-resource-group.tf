# Terraform Resource to Create Azure Resource Group with Input Variables defined in variables.tf

resource "azurerm_resource_group" "aks_rg" {
  name = "terraform-aks"
  location = "eastus"
}
