variable "tenant_id" {
  type        = string
  description = "The tenant ID of the Azure Active Directory tenant."
  nullable    = false
}

variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
}

variable "architecture_name" {
  type        = string
  description = "The name of the architecture."
  default     = "amba"
}

variable "amba_root_management_group_display_name" {
  type        = string
  description = "The display name of the management group."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "user_assigned_managed_identity_name" {
  type        = string
  description = "The name of the user-assigned managed identity."
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]{1,126}[a-zA-Z0-9]$", var.user_assigned_managed_identity_name))
    error_message = "The resource name must start with a letter or number, have a length between 3 and 128 characters and can only contain a combination of alphanumeric characters, hyphens and underscores."
  }
}

variable "management_subscription_id" {
  type        = string
  description = "The subscription ID of the management subscription."

}

variable "action_group_email" {
  type        = list(string)
  default     = []
  description = "The email address of the action group."

}

variable "action_group_arm_role_id" {
  type        = list(string)
  default     = []
  description = "The ARM role ID of the action group."

}

# required AVM interfaces
# remove only if not supported by the resource
# tflint-ignore: terraform_unused_declarations

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
  nullable    = false
}

# tflint-ignore: terraform_unused_declarations
variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}
