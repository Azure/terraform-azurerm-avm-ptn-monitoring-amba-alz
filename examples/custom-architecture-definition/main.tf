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

variable "resource_group_name" {
  type        = string
  default     = "rg-amba-monitoring-001"
  description = "The resource group where the resources will be deployed."
}

variable "user_assigned_managed_identity_name" {
  type        = string
  default     = "id-amba-prod-001"
  description = "The name of the user-assigned managed identity."
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
  root_management_group_name = jsondecode(file("${path.root}/lib/custom.alz_architecture_definition.json")).management_groups[0].id
}

module "amba_alz" {
  source = "../../"
  providers = {
    azurerm = azurerm.management
  }
  location                            = var.location
  root_management_group_name          = local.root_management_group_name
  resource_group_name                 = var.resource_group_name
  user_assigned_managed_identity_name = var.user_assigned_managed_identity_name
}

module "amba_policy" {
  source             = "Azure/avm-ptn-alz/azurerm"
  version            = "0.11.0"
  architecture_name  = "custom"
  location           = var.location
  parent_resource_id = data.azapi_client_config.current.tenant_id
  policy_default_values = {
    amba_alz_management_subscription_id          = jsonencode({ value = var.management_subscription_id != "" ? var.management_subscription_id : data.azapi_client_config.current.subscription_id })
    amba_alz_resource_group_location             = jsonencode({ value = var.location })
    amba_alz_resource_group_name                 = jsonencode({ value = var.resource_group_name })
    amba_alz_resource_group_tags                 = jsonencode({ value = var.tags })
    amba_alz_user_assigned_managed_identity_name = jsonencode({ value = var.user_assigned_managed_identity_name })
    amba_alz_action_group_email                  = jsonencode({ value = var.action_group_email })
    amba_alz_arm_role_id                         = jsonencode({ value = var.action_group_arm_role_id })
  }
}
