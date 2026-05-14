# Architecture Decision Record

Key technical decisions and their rationale for the Zero-Trust Compliance Pack.

## ADR-001: Azure Key Vault over HashiCorp Vault

**Decision:** Use Azure Key Vault (native) instead of HashiCorp Vault.

**Context:** HashiCorp Vault is more feature-rich (dynamic secrets, multi-cloud) but requires deploying, unsealing, and operating a server.

**Rationale:** 5-hour hackathon constraint. Key Vault is zero-ops — no server to deploy, no unseal ceremony, no HA configuration. Premium SKU gives HSM-backed keys. Trade-off is acceptable: the module can be extended to support Vault later.

## ADR-002: RBAC over Access Policies for Key Vault

**Decision:** Use `enable_rbac_authorization = true` on all Key Vaults.

**Context:** Key Vault supports two auth models: legacy access policies (per-vault) and RBAC (Azure-wide).

**Rationale:** RBAC is the zero-trust approach — permissions are managed centrally, auditable, and follow least-privilege. Access policies are per-vault and don't integrate with Azure AD Conditional Access. Microsoft recommends RBAC for new deployments.

## ADR-003: Custom Roles over Built-in Roles

**Decision:** Create custom RBAC role definitions instead of using built-in Contributor/Reader.

**Context:** Built-in roles like Contributor include wildcard permissions and can modify IAM.

**Rationale:** Zero wildcards is a hard requirement. Built-in Contributor includes `*` actions — violates CC6.1. Custom roles enumerate every permission explicitly. `not_actions` blocks dangerous operations even if the role is over-scoped accidentally.

## ADR-004: Azure Policy over Custom Compliance Tooling

**Decision:** Use Azure Policy built-in definitions for compliance monitoring.

**Context:** Could build custom Lambda/Functions for compliance checks, or use third-party tools (Prowler, ScoutSuite).

**Rationale:** Azure Policy is declarative, requires no compute, integrates with Portal's compliance dashboard, and has built-in policy definitions for most of our SOC2 controls. No Functions to deploy or maintain. Trade-off: less flexible than custom checks, but covers our 8 controls.

## ADR-005: GitHub OIDC over Stored Credentials

**Decision:** CI/CD authenticates to Azure via OIDC federation, not stored client secrets.

**Context:** Traditional approach stores a client secret in GitHub secrets. OIDC uses federated identity — no secret to rotate or leak.

**Rationale:** Zero long-lived credentials is a core zero-trust principle. OIDC tokens are short-lived, scoped to the repo and branch, and don't require rotation. If the GitHub secret store is compromised, there's no credential to extract.

## ADR-006: Premium SKU as Default

**Decision:** Key Vault defaults to Premium SKU.

**Context:** Standard SKU is cheaper but uses software-protected keys. Premium uses HSM-backed keys.

**Rationale:** Secure defaults — users opt into less security, not out of it. HSM-backed keys satisfy stricter compliance requirements. The cost difference is negligible for most workloads.

## ADR-007: Module Toggle Pattern

**Decision:** Root module uses `enable_*` boolean variables with `count` to toggle modules.

**Context:** Could use separate root modules per combination, or `for_each` on a module list.

**Rationale:** Simple, predictable, no dynamic blocks. Each module can be disabled independently without affecting others. Emergency recovery: `terraform apply -var="enable_kms_encryption=false"` bypasses a broken module instantly.

## ADR-008: Audit Effect over Deny during Hackathon

**Decision:** Azure Policy assignments use `Audit` effect, not `Deny`.

**Context:** `Deny` would block non-compliant resource creation. `Audit` reports non-compliance without blocking.

**Rationale:** During hackathon, Deny would slow iteration — every non-compliant resource creation would fail. Audit gives the compliance dashboard and evidence without blocking. Production deployments should switch to Deny via the `policy_effect` variable.
