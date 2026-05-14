README.md
# Zero-Trust Compliance Pack — Execution Guide Index

> **Team:** Ayo (Principal), Owen, Philip Afrane
> **Duration:** 5 hours
> **Repo:** GitHub (OIDC to Azure, branch protection, CI/CD)

---

## Quick Reference: Who Does What

```
HOUR  AYO (Principal)              OWEN                         PHILIP AFRANE
──────────────────────────────────────────────────────────────────────────────────
0:00  Module 0: Bootstrap          Module 1: secrets-rotation   Module 2: iam-least-privilege
      (Azure, TF, GitHub, OIDC)    (write locally)              (write locally)

0:30  Module 3: Root wiring        Module 1: apply + iterate    Module 2: apply + iterate

1:30  Integrate P0 modules         Module 4: kms-encryption     Module 5: compliance-checks
      Review + merge PRs           (P1)                         (P1)

2:30  Integrate P1 modules         PR kms-encryption            PR compliance-checks

3:30  ── INTEGRATION CHECKPOINT ─────────────────────────────────────────────────
      Full terraform apply         Fix issues                   Fix issues

4:15  ── DEMO PREP ──────────────────────────────────────────────────────────────
      Demo script rehearsal        Verify secrets + encryption  Verify policies + alerts

4:45  ── DEMO ───────────────────────────────────────────────────────────────────
      Present                      Support                      Support
```

---

## Module Guides

Read YOUR module guide. Each is self-contained with full code, commands, and verification checklists.

### Ayo's Modules

| # | Module | Guide | Priority | Time |
|---|---|---|---|---|
| 0 | [Environment Bootstrap](./00-environment-bootstrap.md) | Azure sub, TF backend, GitHub repo, OIDC | P0 | 0:00–0:30 |
| 3 | [Root Module Wiring](./03-root-module-wiring.md) | Integrate all sub-modules, aggregated compliance output | P0 | 0:30–3:30 |

### Owen's Modules

| # | Module | Guide | Priority | Time |
|---|---|---|---|---|
| 1 | [Secrets Rotation](./01-secrets-rotation.md) | Key Vault, secret rotation, audit logging | P0 | 0:00–1:30 |
| 4 | [KMS Encryption](./04-kms-encryption.md) | CMK, storage encryption, disk encryption set | P1 | 1:30–2:30 |

### Philip's Modules

| # | Module | Guide | Priority | Time |
|---|---|---|---|---|
| 2 | [IAM Least-Privilege](./02-iam-least-privilege.md) | Custom RBAC roles, zero wildcards, deny assignments | P0 | 0:00–1:30 |
| 5 | [Compliance Checks](./05-compliance-checks.md) | Azure Policy initiative, activity log alerts, SOC2 dashboard | P1 | 1:30–2:30 |

---

## SOC2 Control Coverage

| Control | Description | Module | Owner |
|---|---|---|---|
| CC6.1 | Logical access security | `iam-least-privilege` + `compliance-checks` | Philip |
| CC6.2 | Credentials & secrets | `secrets-rotation` + `compliance-checks` | Owen + Philip |
| CC6.3 | Restrict unauthorized access | `iam-least-privilege` | Philip |
| CC6.6 | Encryption in transit | `kms-encryption` + `compliance-checks` | Owen + Philip |
| CC6.7 | Encryption at rest | `kms-encryption` + `compliance-checks` | Owen + Philip |
| CC7.1 | Monitoring & detection | `compliance-checks` | Philip |
| CC7.2 | Anomaly detection | `compliance-checks` | Philip |
| CC8.1 | Change management | `compliance-checks` | Philip |

---

## Critical Checkpoints

| Time | Gate | If Failing |
|---|---|---|
| **0:30** | Bootstrap complete? | Ayo continues. Owen + Philip write code but cannot apply. |
| **1:30** | P0 modules working individually? | **DROP P1.** All three focus on P0. |
| **3:30** | Full stack applies cleanly? | Disable broken P1 modules. Demo P0 only. |
| **4:15** | Demo rehearsal passes? | Simplify script. Show `terraform plan` instead of live apply. |

---

## Git Workflow

```bash
# Branch naming
feature/secrets-rotation
feature/iam-least-privilege
feature/kms-encryption
feature/compliance-checks
feature/root-module

# PR process
1. Push branch
2. CI runs: terraform fmt, validate, tfsec, checkov
3. Request review from Ayo
4. 1 approval required
5. Merge to main

# Commit signing
git commit -S -m "feat: description"
```

---

## Emergency Procedures

### Module breaks integration
```bash
# Disable the broken module and continue
terraform apply -var="enable_kms_encryption=false"
```

### Azure auth fails
```bash
# Re-authenticate
az login
az account set --subscription "<subscription-id>"
```

### Terraform state lock stuck
```bash
# Break the lock (ONLY if no one else is applying)
terraform force-unlock <lock-id>
```

### Policy evaluation not showing
```bash
# Force policy scan
az policy state trigger-scan --resource-group "rg-ztcp-workload" --no-wait
```

---

## PRD

Full product requirements: [zero-trust-secrets-compliance-pack.md](../prd/zero-trust-secrets-compliance-pack.md)