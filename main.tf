module "resource_group" {
  source           = "Azure/avm-res-resources-resourcegroup/azurerm"
  version          = "0.2.1"
  location         = var.location
  name             = var.resource_group_name
  tags             = var.tags
  lock             = var.lock
  role_assignments = var.role_assignments
  enable_telemetry = var.enable_telemetry

  count = var.deploy_resource_group ? 1 : 0
}

module "user_assigned_managed_identity" {
  source              = "Azure/avm-res-managedidentity-userassignedidentity/azurerm"
  version             = "0.3.3"
  location            = var.location
  resource_group_name = var.deploy_resource_group ? module.resource_group.name : var.resource_group_name
  name                = var.user_assigned_managed_identity_name
  enable_telemetry    = var.enable_telemetry
}

resource "azapi_resource" "role_assignments" {
  type = "Microsoft.Authorization/roleAssignments@2022-04-01"
  body = {
    properties = {
      principalId      = module.user_assigned_managed_identity.principal_id
      roleDefinitionId = "/providers/Microsoft.Authorization/roleDefinitions/${var.role_definition_id}"
      description      = var.description
      principalType    = "ServicePrincipal"
    }
  }
  name      = uuid()
  parent_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}"
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
