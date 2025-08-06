# Configure Azure Provider
provider "azurerm" {
  # Version is optional
  # Terraform recommends to pin to a specific version of provider
  #version = "=2.35.0"
  #version = "~>2.35.0"
  #version = "~> 2.37.0"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "aks-rg2" {
  name     = "aks-rg2-tf"
  location = "East US"
}



