data "azapi_client_config" "current" {}

provider "alz" {
  library_overwrite_enabled = true
  library_references = [
    {
      path = "platform/amba"
      ref  = "2025.02.0"
    },
    {
      custom_url = "${path.root}/lib"
    }
  ]
}

provider "azurerm" {
  alias           = "management"
  subscription_id = var.management_subscription_id
  features {}
}

variable "management_subscription_id" {
  description = "Management subscription ID"
  type        = string
  default     = data.azurerm_client_config.current.subscription_id
}

variable "location" {
  description = "Location"
  type        = string
  default     = "swedencentral"
}

variable "action_group_email" {
  description = "Action group email"
  type        = list(string)
  default     = []
}

variable "action_group_arm_role_id" {
  description = "Action group ARM role ID"
  type        = list(string)
  default     = []
}

module "amba_policy" {
  source             = "Azure/avm-ptn-alz/azurerm"
  version            = "0.11.0"
  architecture_name  = "custom"
  location           = var.location
  parent_resource_id = data.azapi_client_config.current.tenant_id
  policy_default_values = {
    amba_alz_management_subscription_id = jsonencode({ value = var.management_subscription_id })
    amba_alz_resource_group_location    = jsonencode({ value = var.location })
    amba_alz_action_group_email         = jsonencode({ value = var.action_group_email })
    amba_alz_arm_role_id                = jsonencode({ value = var.action_group_arm_role_id })
  }
}
