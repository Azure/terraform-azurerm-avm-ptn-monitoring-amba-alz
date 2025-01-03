output "resource_group_name" {
  description = "The resource group name"
  value       = module.amba-resourcegroup.name
}

output "user_assigned_managed_identity_name" {
  description = "<the user assigned managed identity name"
  value       = module.amba-uami.resource_name
}
