output "management_group_resource_id" {
  description = "Resource ID of the isolated management group owned by this example."
  value       = azapi_resource.management_group.id
}

output "resource_id" {
  description = "Resource ID of the AMBA resource group."
  value       = module.amba_alz.resource_id
}

output "user_assigned_managed_identity_resource_id" {
  description = "Resource ID of the AMBA user-assigned managed identity."
  value       = module.amba_alz.user_assigned_managed_identity_resource_id
}
