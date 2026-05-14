# Zero-Trust Secrets & Compliance Pack

> **One `terraform apply`. Instant SOC2 compliance. Zero stored credentials.**

A drop-in Terraform module that deploys zero-trust security into any Azure landing zone in under 5 minutes — secret rotation, least-privilege IAM, encryption-at-rest, and SOC2 compliance evidence. Built to military-grade standards.

---

## The Problem

Every client landing zone deployment requires the same security scaffolding: secret rotation, least-privilege IAM, encryption-at-rest, and compliance evidence. Today this is **1–2 weeks of manual Terraform work per engagement**, with inconsistent implementation across teams. Controls are often incomplete, and compliance evidence is generated retroactively during audit prep.

## The Solution

```hcl
module "zero_trust" {
  source = "github.com/Solirius/zero-trust-compliance-pack"

  environment         = "production"
  project_name        = "my-landing-zone"
  resource_group_name = azurerm_resource_group.main.name
}
```

That's it. One module call. Everything below is automated.

---

## What Gets Deployed

| Module | What It Does | SOC2 Controls |
|---|---|---|
| **secrets-rotation** | Azure Key Vault (Premium/HSM), automated secret rotation, audit logging | CC6.2 |
| **iam-least-privilege** | Custom RBAC roles with zero wildcards, deny assignments, scoped service principals | CC6.1, CC6.3 |
| **kms-encryption** | Customer-managed RSA-4096 keys, encrypted storage, disk encryption set, TLS 1.2 | CC6.6, CC6.7 |
| **compliance-checks** | Azure Policy initiative mapped to SOC2, activity log alerts, compliance dashboard | CC7.1, CC7.2, CC8.1 |

### SOC2 Controls Covered

| Control | Description | Automated Evidence |
|---|---|---|
| CC6.1 | Logical access security | Custom RBAC roles, zero wildcards, scoped to resource group |
| CC6.2 | Credentials & secrets | Key Vault rotation policy, purge protection, audit logging |
| CC6.3 | Restrict unauthorized access | `not_actions` deny blocks on dangerous operations |
| CC6.6 | Encryption in transit | TLS 1.2 minimum, HTTPS-only, shared keys disabled |
| CC6.7 | Encryption at rest | CMK RSA-4096, auto-rotation, storage + disk encryption |
| CC7.1 | Monitoring & detection | Activity log alerts on RBAC and Key Vault changes |
| CC7.2 | Anomaly detection | Key Vault configuration change alerts |
| CC8.1 | Change management | Infrastructure-as-Code, policy drift detection alerts |

---

## Architecture

```
zero-trust-compliance-pack/
├── .github/
│   ├── workflows/
│   │   ├── validate.yml            # PR: fmt, validate, tfsec, checkov
│   │   └── deploy.yml              # Main: OIDC → terraform apply
│   ├── CODEOWNERS
│   └── pull_request_template.md
│
├── main.tf                         # Root module — wires everything
├── variables.tf                    # Top-level config
├── outputs.tf                      # Aggregated compliance report
├── versions.tf                     # Pinned provider versions
├── backend.tf                      # Azure blob remote state
│
├── bootstrap/                      # One-time environment setup
│   ├── main.tf
│   └── init-environment.sh
│
├── modules/
│   ├── secrets-rotation/           # Key Vault + rotation + logging
│   ├── iam-least-privilege/        # Custom RBAC + deny assignments
│   ├── kms-encryption/             # CMK + storage + disk encryption
│   └── compliance-checks/          # Azure Policy + alerts
│
└── examples/
    └── azure-landing-zone/         # Full working example
```

---

## Quick Start

### Prerequisites

- Azure subscription with **Contributor + User Access Administrator**
- Terraform >= 1.5
- Azure CLI: `az login` completed
- GitHub CLI: `gh auth status` passing

### 1. Bootstrap (first time only)

```bash
git clone https://github.com/Solirius/zero-trust-compliance-pack.git
cd zero-trust-compliance-pack/bootstrap
chmod +x init-environment.sh
./init-environment.sh
```

### 2. Deploy

```bash
cd ..
terraform init
terraform plan -var="project_name=my-project"
terraform apply -var="project_name=my-project"
```

### 3. Verify

```bash
# Compliance report
terraform output -json compliance_report

# Azure Portal
# → Key Vault: secrets, purge protection, RBAC
# → IAM: custom roles, zero wildcards
# → Storage: CMK encryption, TLS 1.2
# → Policy: compliance dashboard with SOC2 control names
```

---

## Military-Grade Standards

Every module in this pack enforces these non-negotiable requirements:

### Zero-Trust Principles

- **Never trust, always verify** — default-deny on all resources
- **Least privilege** — no wildcards (`*`) in permissions, ever
- **Assume breach** — encrypt everything, log everything, alert on anomalies
- **No long-lived credentials** — OIDC for CI/CD, managed identities for workloads
- **Defense in depth** — multiple independent security layers

### Module Engineering Standards

- ✅ Every variable has a `validation {}` block
- ✅ Zero hardcoded values — everything parameterised
- ✅ Secure defaults — most restrictive option is always the default
- ✅ `sensitive = true` on all secret outputs
- ✅ `compliance_status` output on every module for aggregation
- ✅ Idempotent — `terraform apply` is safe to run repeatedly
- ✅ Tagged — every resource carries `environment`, `project`, `managed_by`, `module_name`
- ✅ README — usage, inputs, outputs, SOC2 controls covered

### CI/CD Security

- GitHub Actions OIDC to Azure — zero stored credentials
- `tfsec` + `checkov` on every PR — misconfigurations blocked before merge
- Branch protection — 1 review required, no force push, signed commits
- CODEOWNERS — module owners must approve changes to their modules

---

## Module Toggles

Each module can be enabled or disabled independently:

```hcl
module "zero_trust" {
  source = "github.com/Solirius/zero-trust-compliance-pack"

  project_name        = "my-project"
  resource_group_name = "rg-workload"

  # Toggle modules on/off
  enable_secrets_rotation    = true
  enable_iam_least_privilege = true
  enable_kms_encryption      = true
  enable_compliance_checks   = true
}
```

Emergency disable a broken module without affecting others:

```bash
terraform apply -var="enable_kms_encryption=false"
```

---

## Compliance Report

After `terraform apply`, the root module outputs an aggregated compliance report:

```bash
terraform output -json compliance_report
```

```json
{
  "CC6.1": {
    "control": "CC6.1 — Logical access security",
    "status": "compliant",
    "evidence": "Custom RBAC roles with zero wildcard permissions..."
  },
  "CC6.2": {
    "control": "CC6.2 — Credentials & secrets",
    "status": "compliant",
    "evidence": "Key Vault with automated rotation policy..."
  }
}
```

---

## Team

| Person | Role | Modules |
|---|---|---|
| **Ayo** | Principal Engineer | Bootstrap, root wiring, integration, CI/CD |
| **Owen** | Engineer | secrets-rotation, kms-encryption |
| **Philip Afrane** | Engineer | iam-least-privilege, compliance-checks |

---

## Contributing

1. Branch from `dev`: `git checkout -b feature/<module-name>`
2. Follow the [module interface contract](#module-engineering-standards)
3. Run locally: `terraform fmt && terraform validate && tfsec .`
4. PR to `dev` — CI must pass, 1 approval required
5. Use conventional commits: `feat:`, `fix:`, `chore:`

---

## Project Board

[GitHub Project → Zero-Trust Secrets & Compliance Pack](https://github.com/orgs/Solirius/projects/11)

32 issues across P0/P1/P2 priorities with execution guides per module.

---

## License

Internal — Solirius Technology
