# SOC2 / ISO 27001 Compliance Matrix

This document maps SOC2 Trust Services Criteria to the modules and automated evidence in the Zero-Trust Compliance Pack.

## Scope

We cover **8 SOC2 controls** across 4 modules. This is not a full SOC2 certification — it is automated evidence generation for the controls that this pack enforces.

## Control Matrix

| SOC2 Control | Name | Module | Automated Evidence | Verification |
|---|---|---|---|---|
| CC6.1 | Logical access security | `iam-least-privilege` | Custom RBAC roles with zero wildcard permissions, scoped to resource group | Azure Portal → IAM → Roles → inspect permissions |
| CC6.2 | Credentials & secrets | `secrets-rotation` | Key Vault with Premium SKU, RBAC auth, purge protection, rotation policy, audit logging to Log Analytics | Azure Portal → Key Vault → Secrets + Activity Log |
| CC6.3 | Restrict unauthorized access | `iam-least-privilege` | `not_actions` deny blocks on dangerous operations (role modification, RG deletion, KV purge) | Azure Portal → IAM → Role → Not Actions tab |
| CC6.6 | Encryption in transit | `kms-encryption` | TLS 1.2 minimum enforced, HTTPS-only traffic, shared access keys disabled | Azure Portal → Storage → Configuration |
| CC6.7 | Encryption at rest | `kms-encryption` | Customer-managed RSA-4096 key with auto-rotation, storage CMK encryption, disk encryption set | Azure Portal → Storage → Encryption blade |
| CC7.1 | Monitoring & detection | `compliance-checks` | Activity log alerts on RBAC role assignment changes, Azure Policy compliance monitoring | Azure Portal → Monitor → Alerts |
| CC7.2 | Anomaly detection | `compliance-checks` | Activity log alerts on Key Vault configuration changes | Azure Portal → Monitor → Alerts |
| CC8.1 | Change management | `compliance-checks` | All infrastructure Terraform-managed (IaC), policy change alerts for drift detection | Azure Portal → Policy → Compliance |

## ISO 27001 Cross-Reference

| ISO 27001 Control | SOC2 Equivalent | Module |
|---|---|---|
| A.9.2.3 — Management of privileged access | CC6.1 | `iam-least-privilege` |
| A.10.1.1 — Cryptographic controls | CC6.6, CC6.7 | `kms-encryption` |
| A.9.4.3 — Password management | CC6.2 | `secrets-rotation` |
| A.12.4.1 — Event logging | CC7.1, CC7.2 | `compliance-checks` |
| A.12.1.2 — Change management | CC8.1 | `compliance-checks` |

## Evidence Collection

After `terraform apply`, run:

```bash
terraform output -json compliance_report
```

This returns a machine-readable map of every control with:
- `control` — SOC2 control ID and name
- `status` — COMPLIANT / NON_COMPLIANT
- `resource_id` — Azure resource ID as proof
- `evidence` — human-readable description of what was deployed

## Auditor Notes

- All evidence is generated at apply-time and can be re-verified by re-running `terraform output`
- Azure Policy compliance dashboard provides continuous monitoring (Portal → Policy → Compliance)
- Activity Log alerts provide real-time notification of security-relevant changes
- All infrastructure is version-controlled in GitHub with signed commits and PR review requirements
