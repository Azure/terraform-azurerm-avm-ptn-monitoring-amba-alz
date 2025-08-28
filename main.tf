module "resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.2.1"

  location         = var.location
  name             = var.resource_group_name
  enable_telemetry = var.enable_telemetry
  lock             = var.lock
  role_assignments = var.role_assignments
  tags             = var.tags
}

module "user_assigned_managed_identity" {
  source  = "Azure/avm-res-managedidentity-userassignedidentity/azurerm"
  version = "0.3.3"

  location            = var.location
  name                = var.user_assigned_managed_identity_name
  resource_group_name = module.resource_group.name
  enable_telemetry    = var.enable_telemetry
  tags                = var.tags
}

resource "azapi_resource" "role_assignments" {
  name      = uuidv5("oid", "${var.role_definition_id}-${var.user_assigned_managed_identity_name}-${var.root_management_group_name}")
  parent_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}"
  type      = "Microsoft.Authorization/roleAssignments@2022-04-01"
  body = {
    properties = {
      principalId      = module.user_assigned_managed_identity.principal_id
      roleDefinitionId = "/providers/Microsoft.Authorization/roleDefinitions/${var.role_definition_id}"
      description      = var.description
      principalType    = "ServicePrincipal"
    }
  }
  create_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  delete_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  read_headers   = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  retry = var.retries.role_assignments.error_message_regex != null ? {
    error_message_regex  = var.retries.role_assignments.error_message_regex
    interval_seconds     = lookup(var.retries.role_assignments, "interval_seconds", null)
    max_interval_seconds = lookup(var.retries.role_assignments, "max_interval_seconds", null)
    multiplier           = lookup(var.retries.role_assignments, "multiplier", null)
    randomization_factor = lookup(var.retries.role_assignments, "randomization_factor", null)
  } : null
  update_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null

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
