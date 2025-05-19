<!-- BEGIN_TF_DOCS -->
# Complete example of deploying AMBA ALZ

This example demonstrates how to deploy the AMBA ALZ pattern using an existing management group hierarchy with default naming as used in the ALZ reference architecture. It shows how to use the variables to customize the deployment.

```hcl
data "azapi_client_config" "current" {}

provider "alz" {
  library_references = [{
    path = "platform/amba"
    ref  = "2025.04.0"
  }]
}

provider "azurerm" {
  alias           = "management"
  subscription_id = var.management_subscription_id != "" ? var.management_subscription_id : data.azapi_client_config.current.subscription_id
  features {}
}

locals {
  root_management_group_name = "alz"
}

module "amba_alz" {
  source = "../../"
  providers = {
    azurerm = azurerm.management
  }
  count = var.bring_your_own_user_assigned_managed_identity ? 0 : 1

  location                            = var.location
  root_management_group_name          = local.root_management_group_name
  resource_group_name                 = var.resource_group_name
  user_assigned_managed_identity_name = var.user_assigned_managed_identity_name
}

module "amba_policy" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "0.11.0"

  architecture_name  = "amba"
  location           = var.location
  parent_resource_id = data.azapi_client_config.current.tenant_id
  policy_default_values = {
    amba_alz_management_subscription_id            = jsonencode({ value = var.management_subscription_id != "" ? var.management_subscription_id : data.azapi_client_config.current.subscription_id })
    amba_alz_resource_group_location               = jsonencode({ value = var.location })
    amba_alz_resource_group_name                   = jsonencode({ value = var.resource_group_name })
    amba_alz_resource_group_tags                   = jsonencode({ value = var.tags })
    amba_alz_user_assigned_managed_identity_name   = jsonencode({ value = var.user_assigned_managed_identity_name })
    amba_alz_byo_user_assigned_managed_identity_id = jsonencode({ value = var.bring_your_own_user_assigned_managed_identity_resource_id })
    amba_alz_disable_tag_name                      = jsonencode({ value = var.amba_disable_tag_name })
    amba_alz_disable_tag_values                    = jsonencode({ value = var.amba_disable_tag_values })
    amba_alz_action_group_email                    = jsonencode({ value = var.action_group_email })
    amba_alz_arm_role_id                           = jsonencode({ value = var.action_group_arm_role_id })
    amba_alz_webhook_service_uri                   = jsonencode({ value = var.webhook_service_uri })
    amba_alz_event_hub_resource_id                 = jsonencode({ value = var.event_hub_resource_id })
    amba_alz_function_resource_id                  = jsonencode({ value = var.function_resource_id })
    amba_alz_function_trigger_url                  = jsonencode({ value = var.function_trigger_uri })
    amba_alz_logicapp_resource_id                  = jsonencode({ value = var.logic_app_resource_id })
    amba_alz_logicapp_callback_url                 = jsonencode({ value = var.logic_app_callback_url })
    amba_alz_byo_alert_processing_rule             = jsonencode({ value = var.bring_your_own_alert_processing_rule_resource_id })
    amba_alz_byo_action_group                      = jsonencode({ value = var.bring_your_own_action_group_resource_id })
  }
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.9)

- <a name="requirement_alz"></a> [alz](#requirement\_alz) (~> 0.17.4)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 2.2)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

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

### <a name="input_amba_disable_tag_name"></a> [amba\_disable\_tag\_name](#input\_amba\_disable\_tag\_name)

Description: Tag name used to disable monitoring at the resource level.

Type: `string`

Default: `"MonitorDisable"`

### <a name="input_amba_disable_tag_values"></a> [amba\_disable\_tag\_values](#input\_amba\_disable\_tag\_values)

Description: Tag value(s) used to disable monitoring at the resource level.

Type: `list(string)`

Default:

```json
[
  "true",
  "Test",
  "Dev",
  "Sandbox"
]
```

### <a name="input_bring_your_own_action_group_resource_id"></a> [bring\_your\_own\_action\_group\_resource\_id](#input\_bring\_your\_own\_action\_group\_resource\_id)

Description: The resource id of the action group, required if you intend to use an existing action group for monitoring purposes.

Type: `list(string)`

Default: `[]`

### <a name="input_bring_your_own_alert_processing_rule_resource_id"></a> [bring\_your\_own\_alert\_processing\_rule\_resource\_id](#input\_bring\_your\_own\_alert\_processing\_rule\_resource\_id)

Description: The resource id of the alert processing rule, required if you intend to use an existing alert processing rule for monitoring purposes.

Type: `string`

Default: `""`

### <a name="input_bring_your_own_user_assigned_managed_identity"></a> [bring\_your\_own\_user\_assigned\_managed\_identity](#input\_bring\_your\_own\_user\_assigned\_managed\_identity)

Description: Flag to indicate if the user-assigned managed identity is provided by the user.

Type: `bool`

Default: `false`

### <a name="input_bring_your_own_user_assigned_managed_identity_resource_id"></a> [bring\_your\_own\_user\_assigned\_managed\_identity\_resource\_id](#input\_bring\_your\_own\_user\_assigned\_managed\_identity\_resource\_id)

Description: The resource ID of the user-assigned managed identity.

Type: `string`

Default: `""`

### <a name="input_event_hub_resource_id"></a> [event\_hub\_resource\_id](#input\_event\_hub\_resource\_id)

Description: The resource ID of the event hub.

Type: `list(string)`

Default: `[]`

### <a name="input_function_resource_id"></a> [function\_resource\_id](#input\_function\_resource\_id)

Description: The resource ID of the Azure function.

Type: `string`

Default: `""`

### <a name="input_function_trigger_uri"></a> [function\_trigger\_uri](#input\_function\_trigger\_uri)

Description: The trigger URI of the Azure function.

Type: `string`

Default: `""`

### <a name="input_location"></a> [location](#input\_location)

Description: Location

Type: `string`

Default: `"swedencentral"`

### <a name="input_logic_app_callback_url"></a> [logic\_app\_callback\_url](#input\_logic\_app\_callback\_url)

Description: The callback URL of the logic app.

Type: `string`

Default: `""`

### <a name="input_logic_app_resource_id"></a> [logic\_app\_resource\_id](#input\_logic\_app\_resource\_id)

Description: The resource ID of the logic app.

Type: `string`

Default: `""`

### <a name="input_management_subscription_id"></a> [management\_subscription\_id](#input\_management\_subscription\_id)

Description: Management subscription ID

Type: `string`

Default: `""`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

Default: `"rg-amba-monitoring-001"`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: (Optional) Tags of the resource.

Type: `map(string)`

Default:

```json
{
  "_deployed_by_amba": "True"
}
```

### <a name="input_user_assigned_managed_identity_name"></a> [user\_assigned\_managed\_identity\_name](#input\_user\_assigned\_managed\_identity\_name)

Description: The name of the user-assigned managed identity.

Type: `string`

Default: `"id-amba-prod-001"`

### <a name="input_webhook_service_uri"></a> [webhook\_service\_uri](#input\_webhook\_service\_uri)

Description: The service URI of the webhook.

Type: `list(string)`

Default: `[]`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_amba_alz"></a> [amba\_alz](#module\_amba\_alz)

Source: ../../

Version:

### <a name="module_amba_policy"></a> [amba\_policy](#module\_amba\_policy)

Source: Azure/avm-ptn-alz/azurerm

Version: 0.11.0

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->