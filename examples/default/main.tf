provider "azurerm" {
  features {}
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
}

module "amba_alz" {
  source = "../../"

  location                            = "swedencentral"
  root_management_group_name          = "alz"
  resource_group_name                 = module.naming.resource_group.name_unique
  user_assigned_managed_identity_name = module.naming.user_assigned_identity.name_unique
}
