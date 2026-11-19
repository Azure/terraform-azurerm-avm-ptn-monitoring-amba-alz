provider "azurerm" {
  features {}
}

module "naming" {
  source  = "Azure/avm-utl-naming/azure"
  version = "0.3.0"
}

resource "azapi_resource" "management_group" {
  name      = "mg-default-${module.naming.resource_group.name_unique}"
  parent_id = "/"
  type      = var.resource_types.management_management_groups
  body = {
    properties = {
      displayName = "AMBA default E2E"
    }
  }
  ignore_body_changes    = length(var.ignore_body_changes.management_management_groups) > 0 ? var.ignore_body_changes.management_management_groups : null
  response_export_values = []
  retry                  = var.retry

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = timeouts.value.create
      read   = timeouts.value.read
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}

module "amba_alz" {
  source = "../../"

  location                            = var.location
  root_management_group_name          = azapi_resource.management_group.name
  enable_telemetry                    = var.enable_telemetry
  resource_group_name                 = module.naming.resource_group.name_unique
  user_assigned_managed_identity_name = module.naming.user_assigned_identity.name_unique
}
