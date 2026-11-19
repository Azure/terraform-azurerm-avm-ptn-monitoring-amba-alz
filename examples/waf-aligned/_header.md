# WAF-aligned AMBA ALZ deployment

This E2E scenario demonstrates applicable Well-Architected Framework practices for this module's resource group, user-assigned managed identity, and management-group role assignment. It does not deploy the full ALZ policy architecture.

## Deployment readiness

This scenario is not yet deployment-ready: the root module's pinned managed-identity dependency still requires AzureRM configuration. This example deliberately does not introduce that configuration or a policy exception. Resolve the dependency/provider compatibility before running the deployment test; discovery alone is not evidence that the test passes.

## Alignment and boundaries

- The module's managed identity avoids application secrets, and its default Monitoring Reader role is scoped to an isolated test management group rather than the tenant root. This is the least-privilege default for the module's monitoring-reader scenario, not a complete AMBA policy-remediation identity configuration.
- Tags on the resource group and identity support resource organization and cost attribution.
- The example owns its uniquely named management group. No existing `alz` hierarchy or subscriptions are modified.
- A resource lock is intentionally omitted so automated teardown can remove all test resources. This is an E2E cleanup trade-off, not a recommendation to omit production protection.

These resources do not expose availability-zone, data-redundancy, or private-networking settings. The example does not claim coverage of unrelated WAF recommendations.

## Prerequisites and cleanup

After resolving deployment readiness, the authenticated identity needs permission to create and delete management groups under the tenant's configured default management group, manage role assignments on the new group, and deploy resources into the selected subscription.

Run `avm test e2e --example waf-aligned` from the repository root to deploy, check idempotency, and destroy the example. Terraform owns the prerequisite group and removes the module's role assignment before deleting it. Names remain stable for the lifetime of the Terraform state. Do not import an existing group or move subscriptions into the test group.
