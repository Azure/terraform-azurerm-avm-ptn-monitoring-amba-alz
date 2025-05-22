data "azapi_client_config" "current" {}

provider "alz" {
  library_overwrite_enabled = true
  library_references = [
    {
      path = "platform/amba"
      ref  = "2025.05.0"
    },
    {
      custom_url = "${path.root}/lib"
    }
  ]
}

provider "azurerm" {
  alias           = "management"
  subscription_id = var.management_subscription_id != "" ? var.management_subscription_id : data.azapi_client_config.current.subscription_id
  features {}
}

module "amba_policy" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "0.12.0"

  architecture_name  = "custom"
  location           = var.location
  parent_resource_id = data.azapi_client_config.current.tenant_id
  policy_default_values = {
    amba_alz_management_subscription_id = jsonencode({ value = var.management_subscription_id != "" ? var.management_subscription_id : data.azapi_client_config.current.subscription_id })
    amba_alz_resource_group_location    = jsonencode({ value = var.location })
    amba_alz_resource_group_name        = jsonencode({ value = var.resource_group_name })
    amba_alz_resource_group_tags        = jsonencode({ value = var.tags })
    amba_alz_disable_tag_name           = jsonencode({ value = var.amba_disable_tag_name })
    amba_alz_disable_tag_values         = jsonencode({ value = var.amba_disable_tag_values })
    amba_alz_action_group_email         = jsonencode({ value = var.action_group_email })
    amba_alz_arm_role_id                = jsonencode({ value = var.action_group_arm_role_id })
    amba_alz_webhook_service_uri        = jsonencode({ value = var.webhook_service_uri })
    amba_alz_event_hub_resource_id      = jsonencode({ value = var.event_hub_resource_id })
    amba_alz_function_resource_id       = jsonencode({ value = var.function_resource_id })
    amba_alz_function_trigger_url       = jsonencode({ value = var.function_trigger_uri })
    amba_alz_logicapp_resource_id       = jsonencode({ value = var.logic_app_resource_id })
    amba_alz_logicapp_callback_url      = jsonencode({ value = var.logic_app_callback_url })
    amba_alz_byo_action_group           = jsonencode({ value = var.bring_your_own_action_group_resource_id })
  }
}
