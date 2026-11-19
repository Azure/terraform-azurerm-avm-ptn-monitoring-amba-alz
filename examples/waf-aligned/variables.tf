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

variable "ignore_body_changes" {
  type = object({
    management_management_groups = optional(list(string), [])
  })
  default     = {}
  description = "Body-relative dot-notation paths to ignore on the test management group. Changes take effect after apply; ignored properties are not sent to Azure until their paths are removed."
  nullable    = false
}

variable "location" {
  type        = string
  default     = "swedencentral"
  description = "Azure region for the AMBA resource group and managed identity."
  nullable    = false
}

variable "resource_types" {
  type = object({
    management_management_groups = optional(string, "Microsoft.Management/managementGroups@2021-04-01")
  })
  default     = {}
  description = "AzAPI resource types used by the test setup. management_management_groups configures the isolated management group's resource type and API version."
  nullable    = false
}

variable "retry" {
  type = object({
    error_message_regex  = optional(list(string))
    interval_seconds     = optional(number)
    max_interval_seconds = optional(number)
    multiplier           = optional(number)
    randomization_factor = optional(number)
  })
  default     = null
  description = "Optional retry settings for the test management group: error_message_regex selects retryable errors; interval_seconds, max_interval_seconds, multiplier, and randomization_factor control backoff."
}

variable "tags" {
  type = map(string)
  default = {
    environment = "test"
    purpose     = "amba-waf-aligned-e2e"
    workload    = "monitoring"
  }
  description = "Tags applied to the AMBA resource group and managed identity for resource organization and cost attribution."
  nullable    = false
}

variable "timeouts" {
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default     = null
  description = "Optional create, read, update, and delete timeouts for the test management group, expressed as Go duration strings such as 10m. Null uses provider defaults."
}
