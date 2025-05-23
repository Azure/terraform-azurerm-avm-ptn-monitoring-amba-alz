<!-- BEGIN_TF_DOCS -->
# Deploying AMBA ALZ

This example demonstrates how to deploy the AMBA ALZ pattern resources. This module is designed to be used alongside the “avm-ptn-alz” module. For additional information, refer to examples such as “complete” and “custom-architecture-definition”.

```hcl
provider "azurerm" {
  features {}
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

module "amba_alz" {
  source = "../../"

  location                            = "swedencentral"
  root_management_group_name          = "alz"
  resource_group_name                 = module.naming.resource_group.name_unique
  user_assigned_managed_identity_name = module.naming.user_assigned_identity.name_unique
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.9)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Resources

No resources.

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

No optional inputs.

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_amba_alz"></a> [amba\_alz](#module\_amba\_alz)

Source: ../../

Version:

### <a name="module_naming"></a> [naming](#module\_naming)

Source: Azure/naming/azurerm

Version: ~> 0.3

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->