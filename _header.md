# AMBA ALZ resources module

This module deploys resources for the AMBA Azure Landing Zones pattern. Please review the examples, which provide details on various scenarios.

## Features

- Deployment of Resource Group.
- Deployment of User Assigned Managed Identity.
- Deployment of Monitoring Reader Role Assignment for the User Assigned Managed Identity.

## AzAPI Provider

We use the AzAPI provider to interact with the Azure APIs.
The new features allow us to be more efficient and reliable, with orders of magnitude speed improvements and retry logic for transient errors.

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
