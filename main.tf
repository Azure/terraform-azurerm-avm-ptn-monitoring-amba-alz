module "resource_group" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "0.2.1"
  location = var.location
  name     = var.resource_group_name
  tags     = var.tags
}

module "user_assigned_managed_identity" {
  source              = "Azure/avm-res-managedidentity-userassignedidentity/azurerm"
  version             = "0.3.3"
  location            = var.location
  resource_group_name = module.resource_group.name
  name                = var.user_assigned_managed_identity_name
}

module "role_assignments" {
  source  = "Azure/avm-res-authorization-roleassignment/azurerm"
  version = "0.2.0"

  user_assigned_managed_identities_by_client_id = {
    mi1 = module.user_assigned_managed_identity.client_id
  }

  role_definitions = {
    monitoring_reader = {
      name = "Monitoring Reader"
    }
  }

  role_assignments_for_management_groups = {
    amba-uami = {
      management_group_display_name = var.amba_root_management_group_display_name
      role_assignments = {
        role_assignment1 = {
          role_definition                  = "monitoring_reader"
          user_assigned_managed_identities = ["mi1"]
        }
      }
    }
  }
}

# required AVM resources interfaces
resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = module.resource_group.resource_id
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = module.resource_group.resource_id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}
