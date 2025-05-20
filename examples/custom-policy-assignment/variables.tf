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
