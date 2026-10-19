provider "azurerm" {
  features {}
}

module "naming" {
  source  = "Azure/avm-utl-naming/azure"
  version = "0.2.0"
}

module "amba_alz" {
  source    = "../../"
  providers = { modtm = modtm }

  location                            = "swedencentral"
  root_management_group_name          = "alz"
  enable_telemetry                    = var.enable_telemetry
  resource_group_name                 = module.naming.resource_group.name_unique
  user_assigned_managed_identity_name = module.naming.user_assigned_identity.name_unique
}
