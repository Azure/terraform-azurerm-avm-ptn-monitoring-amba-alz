<!-- BEGIN_TF_DOCS -->
# Default example

This deploys the module in its simplest form.

```hcl
data "azapi_client_config" "current" {}

provider "alz" {
  library_references = [{
    path = "platform/amba"
    ref  = "2025.02.0"
  }]
}

provider "azurerm" {
  alias           = "management"
  subscription_id = var.management_subscription_id
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
  default     = ""
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

locals {
  root_management_group_name = "alz"
}

module "amba-alz" {
  source = "git::https://github.com/Azure/terraform-azurerm-avm-ptn-monitoring-amba-alz?ref=feat-amba-alz"
  providers = {
    azurerm = azurerm.management
  }
  location                        = var.location
  amba_root_management_group_name = local.root_management_group_name
}

module "amba-policy" {
  source             = "Azure/avm-ptn-alz/azurerm"
  version            = "0.11.0"
  architecture_name  = "amba"
  location           = var.location
  parent_resource_id = data.azapi_client_config.current.tenant_id
  policy_default_values = {
    amba_alz_management_subscription_id = jsonencode({ value = var.management_subscription_id })
    amba_alz_resource_group_location    = jsonencode({ value = var.location })
    amba_alz_action_group_email         = jsonencode({ value = var.action_group_email })
    amba_alz_arm_role_id                = jsonencode({ value = var.action_group_arm_role_id })
  }
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.9)

- <a name="requirement_alz"></a> [alz](#requirement\_alz) (~> 0.16)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 2.2)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.71)

- <a name="requirement_local"></a> [local](#requirement\_local) (~> 2.5)

- <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) (~> 0.3)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.6)

## Resources

The following resources are used by this module:

- [azapi_client_config.current](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/client_config) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_action_group_arm_role_id"></a> [action\_group\_arm\_role\_id](#input\_action\_group\_arm\_role\_id)

Description: Action group ARM role ID

Type: `list(string)`

Default: `[]`

### <a name="input_action_group_email"></a> [action\_group\_email](#input\_action\_group\_email)

Description: Action group email

Type: `list(string)`

Default: `[]`

### <a name="input_location"></a> [location](#input\_location)

Description: Location

Type: `string`

Default: `""`

### <a name="input_management_subscription_id"></a> [management\_subscription\_id](#input\_management\_subscription\_id)

Description: Management subscription ID

Type: `string`

Default: `""`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_amba-alz"></a> [amba-alz](#module\_amba-alz)

Source: git::https://github.com/Azure/terraform-azurerm-avm-ptn-monitoring-amba-alz

Version: feat-amba-alz

### <a name="module_amba-policy"></a> [amba-policy](#module\_amba-policy)

Source: Azure/avm-ptn-alz/azurerm

Version: 0.11.0

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->