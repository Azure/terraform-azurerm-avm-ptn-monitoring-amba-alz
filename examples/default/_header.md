# Default AMBA ALZ deployment

This baseline E2E example deploys the AMBA resource group, user-assigned managed identity, and default Monitoring Reader role assignment. Optional module settings retain their defaults.

The example creates a uniquely named management group with AzAPI instead of assuming that an `alz` management group exists. No subscriptions or existing management groups are moved into it. Names remain stable for the lifetime of the Terraform state.

## Prerequisites and cleanup

The authenticated identity needs permission to create and delete management groups under the tenant's configured default management group, manage role assignments on the new group, and deploy resources into the selected subscription. Subscription-only permissions are not sufficient for the management-group operations.

Run `avm test e2e --example default` from the repository root to deploy, check idempotency, and destroy the example. Terraform owns the prerequisite management group and removes the module's role assignment before deleting it. Do not import an existing management group into this example's state or move subscriptions into the test group.

For the full ALZ policy composition, see the `complete` and `custom-architecture-definition` examples.
