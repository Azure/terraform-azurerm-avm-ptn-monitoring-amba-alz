terraform {
  required_version = "~> 1.9"
  required_providers {
    alz = {
      source  = "Azure/alz"
      version = "~> 0.16"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.71"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "alz" {
  library_overwrite_enabled = true
  library_references = [
    {
      custom_url = "${path.root}/lib"
    }
  ]
}

provider "azurerm" {
  features {}
}

locals {
  management_group_display_name = jsondecode(file("${path.root}/lib/custom.alz_architecture_definition.json")).management_groups[0].id
}

module "amba-alz" {
  source                                  = "git::https://github.com/Azure/terraform-azurerm-avm-ptn-monitoring-amba-alz?ref=feat-amba-alz"
  tenant_id                               = "04f97928-a004-4c6d-897f-16187e165159"
  location                                = "swedencentral"
  architecture_name                       = "custom"
  amba_root_management_group_display_name = local.management_group_display_name
  resource_group_name                     = "rg-amba-prod-001"
  //user_assigned_managed_identity_name     = "id-amba-alz-arg-reader-prod-001"
  management_subscription_id              = "04f97928-a004-4c6d-897f-16187e165159"
  //action_group_email                      = ["email@arjen.cloud"]
  //action_group_arm_role_id                = ["8e3af657-a8ff-443c-a75c-2fe8c4bcb635"]
  bring_your_own_user_assigned_managed_identity = true
  bring_your_own_user_assigned_managed_identity_resource_id = "/subscriptions/04f97928-a004-4c6d-897f-16187e165159/resourceGroups/rg-avm-test-byo/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-amba-test"
  bring_your_own_alert_processing_rule_resource_id = "/subscriptions/04f97928-a004-4c6d-897f-16187e165159/resourceGroups/rg-avm-test-byo/providers/Microsoft.AlertsManagement/actionRules/apr-amba"
  bring_your_own_action_group_resource_id = ["/subscriptions/04f97928-a004-4c6d-897f-16187e165159/resourceGroups/rg-avm-test-byo/providers/microsoft.insights/actiongroups/ag-amba"]
  tags = {
    environment = "prod"
  }

}
