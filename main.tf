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

resource "azapi_resource" "role_assignments" {
  type = "Microsoft.Authorization/roleAssignments@2022-04-01"
  body = {
    properties = {
      principalId      = module.user_assigned_managed_identity.principal_id
      roleDefinitionId = "/providers/Microsoft.Authorization/roleDefinitions/43d0d8ad-25c7-4714-9337-8ba259a9fe05"
      description      = "_deployed_by_amba"
      principalType    = "ServicePrincipal"
    }
  }
  name      = uuid()
  parent_id = "/providers/Microsoft.Management/managementGroups/${var.amba_root_management_group_name}"
  retry = var.retries.role_assignments.error_message_regex != null ? {
    error_message_regex  = var.retries.role_assignments.error_message_regex
    interval_seconds     = lookup(var.retries.role_assignments, "interval_seconds", null)
    max_interval_seconds = lookup(var.retries.role_assignments, "max_interval_seconds", null)
    multiplier           = lookup(var.retries.role_assignments, "multiplier", null)
    randomization_factor = lookup(var.retries.role_assignments, "randomization_factor", null)
  } : null

  timeouts {
    create = var.timeouts.role_assignment.create
    delete = var.timeouts.role_assignment.delete
    read   = var.timeouts.role_assignment.read
    update = var.timeouts.role_assignment.update
  }

  lifecycle {
    # https://github.com/Azure/terraform-provider-azapi/issues/671
    ignore_changes = [output.properties.updatedOn]
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
