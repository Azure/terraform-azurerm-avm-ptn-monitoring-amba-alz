provider "azurerm" {
  features {}
}

module "amba_alz" {
  source                              = "git::https://github.com/Azure/terraform-azurerm-avm-ptn-monitoring-amba-alz?ref=feat-amba-alz"
  location                            = "swedencentral"
  root_management_group_name          = "alz"
  resource_group_name                 = "rg-amba-monitoring-001"
  user_assigned_managed_identity_name = "id-amba-prod-001"
  enable_telemetry                    = false
}
