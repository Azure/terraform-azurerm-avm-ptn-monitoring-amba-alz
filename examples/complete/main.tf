data "azapi_client_config" "current" {}

provider "alz" {
  library_references = [{
    path = "platform/amba"
    ref  = "2025.07.0"
  }]
}

provider "azurerm" {
  alias           = "management"
  subscription_id = var.management_subscription_id != "" ? var.management_subscription_id : data.azapi_client_config.current.subscription_id
  features {}
}

locals {
  root_management_group_name = "alz"
}

module "amba_alz" {
  source = "../../"
  providers = {
    azurerm = azurerm.management
  }
  count = var.bring_your_own_user_assigned_managed_identity ? 0 : 1

  location                            = var.location
  root_management_group_name          = local.root_management_group_name
  resource_group_name                 = var.resource_group_name
  tags                                = var.tags
  user_assigned_managed_identity_name = var.user_assigned_managed_identity_name
}

module "amba_policy" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "0.12.0"

  architecture_name  = "amba"
  location           = var.location
  parent_resource_id = data.azapi_client_config.current.tenant_id
  policy_default_values = {
    amba_alz_management_subscription_id            = jsonencode({ value = var.management_subscription_id != "" ? var.management_subscription_id : data.azapi_client_config.current.subscription_id })
    amba_alz_resource_group_location               = jsonencode({ value = var.location })
    amba_alz_resource_group_name                   = jsonencode({ value = var.resource_group_name })
    amba_alz_resource_group_tags                   = jsonencode({ value = var.tags })
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
