# AMBA ALZ resources module

This module deploys resources for the AMBA Azure Landing Zones pattern. Please review the examples, which provide details on various scenarios.

## Features

- Deployment of Resource Group.
- Deployment of User Assigned Managed Identity.
- Deployment of Monitoring Reader Role Assignment for the User Assigned Managed Identity.

## AzAPI Provider

We use the AzAPI provider to interact with the Azure APIs.
The new features allow us to be more efficient and reliable, with orders of magnitude speed improvements and retry logic for transient errors.

## Upgrading from 0.4.0

- The managed identity module now requires AzureRM `>= 4.60.0, < 5.0.0`, and this module requires AzAPI `~> 2.12`. Check provider constraints and the dependency lock file before upgrading.
- When telemetry is enabled, this module and its referenced resource group, interfaces, and managed identity modules create empty subscription-scope deployments through their AzAPI provider. The identity running Terraform needs permission to manage deployments at that subscription scope, and deployment history and subsequent plans can change. Set `enable_telemetry = false` to disable telemetry in this module and its referenced modules.
- The previous telemetry resources in this module and its referenced modules have `removed` blocks with `destroy = false`. Back up your state and review the upgrade plan, including the handling of the old telemetry resources and any workload changes, before applying. Historical-state migration has not been validated.
- Remove any `modtm` mapping from this module's `providers` argument; the module no longer declares that provider, and forwarding it can cause a provider type mismatch. Older state may still require the original ModTM provider configuration until Terraform has processed the removed telemetry resource.
- For resource group role assignments created by older AzureRM-based versions, set each `role_assignments` entry's `name` to its existing assignment GUID in lowercase to avoid replacing it. This field was previously ignored by this module; remove it if an existing value should not become effective.
- Review resource group locks and existing lock notes in the plan: the updated resource group module sends `notes = null`, and its effect on existing notes has not been verified. The resource group's `ignore_tag_changes` remains at its default `false`; changing that setting in the resource group module can replace the group.

## Multi-Subscription Deployments

If you deploy this module into a subscription other than the one selected by your default provider configuration (for example, using an aliased `azurerm` provider), you **must** also pass an aliased `azapi` provider configured for the same subscription. Terraform disables automatic provider inheritance for *all* providers on a module call as soon as a `providers` argument is specified, so omitting `azapi` from that map causes the module's internal `azapi` resources (such as the resource group) to fall back to the default/unaliased `azapi` provider's subscription context, which can result in an empty or incorrect subscription ID.

```hcl
provider "azurerm" {
  alias           = "management"
  subscription_id = var.management_subscription_id
  features {}
}

provider "azapi" {
  alias           = "management"
  subscription_id = var.management_subscription_id
}

module "amba_alz" {
  source  = "Azure/avm-ptn-monitoring-amba-alz/azurerm"
  version = "x.x.x"

  providers = {
    azurerm = azurerm.management
    azapi   = azapi.management
  }
  # ...
}
```
