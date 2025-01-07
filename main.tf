module "resource_group" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "0.1.0"
  location = var.location
  name     = var.resource_group_name
  tags     = var.tags
}

module "user_assigned_managed_identity" {
  source              = "Azure/avm-res-managedidentity-userassignedidentity/azurerm"
  version             = "0.3.3"
  location            = var.location
  resource_group_name = module.amba-resourcegroup.name
  name                = var.user_assigned_managed_identity_name
}

module "role_assignments" {
  source  = "Azure/avm-res-authorization-roleassignment/azurerm"
  version = "0.2.0"

  user_assigned_managed_identities_by_client_id = {
    mi1 = module.amba-uami.client_id
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
  depends_on = [module.user_assigned_managed_identity]
}

module "amba" {
  source             = "Azure/avm-ptn-alz/azurerm"
  version            = "0.10.0"
  architecture_name  = var.architecture_name
  location           = var.location
  parent_resource_id = var.tenant_id
  policy_default_values = {
    amba_alz_management_subscription_id            = jsonencode({ value = var.management_subscription_id })
    amba_alz_resource_group_name                   = jsonencode({ value = var.resource_group_name })
    amba_alz_resource_group_tags                   = jsonencode({ value = var.tags })
    amba_alz_resource_group_location               = jsonencode({ value = var.location })
    amba_alz_user_assigned_managed_identity_name   = jsonencode({ value = var.user_assigned_managed_identity_name })
    amba_alz_byo_user_assigned_managed_identity_id = jsonencode({ value = var.bring_your_own_user_assigned_managed_identity_resource_id })
    amba_alz_disable_tag_name                      = jsonencode({ value = var.amba_disable_tag_name })
    amba_alz_disable_tag_values                    = jsonencode({ value = var.amba_disable_tag_values })
    amba_alz_action_group_email                    = jsonencode({ value = var.action_group_email })
    amba_alz_arm_role_id                           = jsonencode({ value = var.action_group_arm_role_id })
    amba_alz_webhook_service_uri                   = jsonencode({ value = var.webhook_service_uri })
    amba_alz_event_hub_resource_id                 = jsonencode({ value = var.event_hub_resource_id })
    amba_alz_function_resource_id                  = jsonencode({ value = var.function_resource_id })
    amba_alz_function_trigger_url                  = jsonencode({ value = var.function_trigger_uri })
    amba_alz_logicapp_resource_id                  = jsonencode({ value = var.logic_app_resource_id })
    amba_alz_logicapp_callback_url                 = jsonencode({ value = var.logic_app_callback_url })
    amba_alz_byo_alert_processing_rule             = jsonencode({ value = var.bring_your_own_alert_processing_rule_resource_id })
    amba_alz_byo_action_group                      = jsonencode({ value = var.bring_your_own_action_group_resource_id })
  }
}

# required AVM resources interfaces
resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = module.amba-resourcegroup.resource_id
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = module.amba-resourcegroup.resource_id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}
