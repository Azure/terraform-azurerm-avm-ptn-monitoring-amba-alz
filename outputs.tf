output "resource_group_name" {
  description = "The resource group name"
  value       = module.resource_group.name
}

output "resource_id" {
  description = "The resource id of the resource group"
  value       = module.resource_group.resource_id
}

output "user_assigned_managed_identity_resource_id" {
  description = "The resource id of the user assigned managed identity"
  value       = module.user_assigned_managed_identity.resource_id
}

output "user_assigned_managed_identity_name" {
  description = "The user assigned managed identity name"
  value       = module.user_assigned_managed_identity.resource_name
}
