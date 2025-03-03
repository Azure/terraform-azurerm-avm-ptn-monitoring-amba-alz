terraform {
  required_version = "~> 1.9"
  required_providers {
    alz = {
      source  = "Azure/alz"
      version = "~> 0.16"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.2"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.71"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
