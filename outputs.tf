output "resource_group_name" {
  description = "The resource group name"
  value       = module.resource_group.name
}

output "user_assigned_managed_identity_name" {
  description = "The user assigned managed identity name"
  value       = module.user_assigned_managed_identity[0].resource_name
}
