# required AVM interfaces
# remove only if not supported by the resource
# tflint-ignore: terraform_unused_declarations

variable "amba_root_management_group_name" {
  type        = string
  description = "The display name of the management group."
  nullable    = false
}

variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
}

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

variable "resource_group_name" {
  type        = string
  default     = "rg-amba-monitoring-001"
  description = "The resource group where the resources will be deployed."
}

variable "retries" {
  type = object({
    role_assignments = optional(object({
      error_message_regex = optional(list(string), [
        "AuthorizationFailed", # Avoids a eventual consistency issue where a recently created management group is not yet available for a GET operation.
        "ResourceNotFound",    # If the resource has just been created, retry until it is available.
      ])
      interval_seconds     = optional(number, null)
      max_interval_seconds = optional(number, null)
      multiplier           = optional(number, null)
      randomization_factor = optional(number, null)
    }), {})
  })
  default     = {}
  description = <<DESCRIPTION
The retry settings to apply to the CRUD operations. Value is a nested object, the top level keys are the resources and the values are an object with the following attributes:

- `error_message_regex` - (Optional) A list of error message regexes to retry on. Defaults to `null`, which will will disable retries. Specify a value to enable.
- `interval_seconds` - (Optional) The initial interval in seconds between retries. Defaults to `null` and will fall back to the provider default value.
- `max_interval_seconds` - (Optional) The maximum interval in seconds between retries. Defaults to `null` and will fall back to the provider default value.
- `multiplier` - (Optional) The multiplier to apply to the interval between retries. Defaults to `null` and will fall back to the provider default value.
- `randomization_factor` - (Optional) The randomization factor to apply to the interval between retries. Defaults to `null` and will fall back to the provider default value.

For more information please see the provider documentation here: <https://registry.terraform.io/providers/Azure/azapi/azurerm/latest/docs/resources/resource#nestedatt--retry>
DESCRIPTION
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

variable "timeouts" {
  type = object({
    role_assignment = optional(object({
      create = optional(string, "5m")
      delete = optional(string, "5m")
      update = optional(string, "5m")
      read   = optional(string, "5m")
      }), {}
    )
  })
  default     = {}
  description = <<DESCRIPTION
A map of timeouts to apply to the creation and destruction of resources.
If using retry, the maximum elapsed retry time is governed by this value.

The object has attributes for each resource type, with the following optional attributes:

- `create` - (Optional) The timeout for creating the resource. Defaults to `5m` apart from policy assignments, where this is set to `15m`.
- `delete` - (Optional) The timeout for deleting the resource. Defaults to `5m`.
- `update` - (Optional) The timeout for updating the resource. Defaults to `5m`.
- `read` - (Optional) The timeout for reading the resource. Defaults to `5m`.

Each time duration is parsed using this function: <https://pkg.go.dev/time#ParseDuration>.
DESCRIPTION
}

variable "user_assigned_managed_identity_name" {
  type        = string
  default     = "id-amba-prod-001"
  description = "The name of the user-assigned managed identity."

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]{1,126}[a-zA-Z0-9]$", var.user_assigned_managed_identity_name))
    error_message = "The resource name must start with a letter or number, have a length between 3 and 128 characters and can only contain a combination of alphanumeric characters, hyphens and underscores."
  }
}
