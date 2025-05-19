variable "action_group_arm_role_id" {
  type        = list(string)
  default     = []
  description = "Action group ARM role ID"
}

variable "action_group_email" {
  type        = list(string)
  default     = []
  description = "Action group email"
}

variable "location" {
  type        = string
  default     = "swedencentral"
  description = "Location"
}

variable "management_subscription_id" {
  type        = string
  default     = ""
  description = "Management subscription ID"
}

variable "resource_group_name" {
  type        = string
  default     = "rg-amba-monitoring-001"
  description = "The resource group where the resources will be deployed."
}

variable "tags" {
  type = map(string)
  default = {
    _deployed_by_amba = "True"
  }
  description = "(Optional) Tags of the resource."
}

variable "user_assigned_managed_identity_name" {
  type        = string
  default     = "id-amba-prod-001"
  description = "The name of the user-assigned managed identity."
}
