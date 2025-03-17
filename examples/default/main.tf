data "azapi_client_config" "current" {}

provider "alz" {
  library_references = [{
    path = "platform/amba"
    ref  = "2025.02.0"
  }]
}

provider "azurerm" {
  alias           = "management"
  subscription_id = var.management_subscription_id != "" ? var.management_subscription_id : data.azapi_client_config.current.subscription_id
  features {}
}

variable "management_subscription_id" {
  description = "Management subscription ID"
  type        = string
  default     = ""
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

variable "tags" {
  type = map(string)
  default = {
    _deployed_by_amba = "True"
  }
  description = "(Optional) Tags of the resource."
}

locals {
  root_management_group_name = "alz"
}

module "amba_alz" {
  source = "../../"
  providers = {
    azurerm = azurerm.management
  }
  location                   = var.location
  root_management_group_name = local.root_management_group_name
}

module "amba_policy" {
  source             = "Azure/avm-ptn-alz/azurerm"
  version            = "0.11.0"
  architecture_name  = "amba"
  location           = var.location
  parent_resource_id = data.azapi_client_config.current.tenant_id
  policy_default_values = {
    amba_alz_management_subscription_id = jsonencode({ value = var.management_subscription_id != "" ? var.management_subscription_id : data.azapi_client_config.current.subscription_id })
    amba_alz_resource_group_location    = jsonencode({ value = var.location })
    amba_alz_resource_group_tags        = jsonencode({ value = var.tags })
    amba_alz_action_group_email         = jsonencode({ value = var.action_group_email })
    amba_alz_arm_role_id                = jsonencode({ value = var.action_group_arm_role_id })
  }
}
