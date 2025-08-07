# We will define 
# 1. Terraform Settings Block
# 1. Required Version Terraform
# 2. Required Terraform Providers
# 3. Terraform Remote State Storage with Azure Storage Account (last step of this section)
# 2. Terraform Provider Block for AzureRM
# 3. Terraform Resource Block: Define a Random Pet Resource

# Terraform Settings Block
terraform {
  # Required Version Terraform
  required_version = "~> 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstorageacount"
    container_name        = "containerbypawan"
    key                   = "terraform.tfstate"
  }
}


# Terraform Provider Block for AzureRM
 provider "azurerm" {
  features {

  }
 }

# Terraform Resource Block: Define a Random Pet Resource
resource "random_pet" "aksrandom_pet" {
  
}
