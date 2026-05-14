# Demo Script — Zero-Trust Secrets & Compliance Pack

> **Duration:** 5 minutes
> **Presenter:** Ayo
> **Support:** Owen, Philip

---

## Before the Demo (15 min prep)

```bash
# 1. Ensure resources are deployed
cd /tmp/zero-trust-compliance-pack
git checkout dev && git pull origin dev
terraform init
terraform apply -var="project_name=demo" -auto-approve

# 2. Trigger policy scan (takes 15-30 min — do this EARLY)
az policy state trigger-scan \
  --resource-group "rg-demo-dev" --no-wait

# 3. Bookmark these Azure Portal pages:
#    - Key Vault → Secrets
#    - Key Vault → Keys (rotation policy)
#    - Key Vault → Diagnostic settings
#    - Resource Group → IAM → Roles
#    - Storage Account → Encryption
#    - Policy → Compliance
#    - Monitor → Alerts

# 4. Pre-run the compliance output
terraform output -json compliance_report | jq .
terraform output -json compliance_summary | jq .

# 5. Dry run the whole demo once
```

---

## Demo Flow

### 1. The Problem (30 seconds)

> "Every client landing zone we deploy needs the same security work — secret rotation, least-privilege IAM, encryption, compliance evidence. Today that's **1-2 weeks of manual Terraform per engagement**. Inconsistent across teams. Controls are incomplete. Compliance evidence is generated retroactively during audit prep."

### 2. The Solution (30 seconds)

> "We built a single Terraform module that does all of it. One module call. One `terraform apply`."

Show `main.tf`:

```bash
cat examples/azure-landing-zone/main.tf
```

> "That's it. `source`, `project_name`, `resource_group`. Everything else is automated with secure defaults."

### 3. Live Demo (3 minutes)

#### 3a. Show the Plan

```bash
terraform plan -var="project_name=demo"
```

> "You can see it's creating: Key Vault with rotation, custom RBAC roles, encrypted storage with customer-managed keys, Azure Policy assignments mapped to SOC2 controls, and activity log alerts."

#### 3b. Azure Portal Walkthrough

**Key Vault** (Owen navigates)

> "Premium SKU — HSM-backed keys. RBAC authorization, not legacy access policies. Purge protection enabled — secrets can't be permanently deleted. Default-deny network rules."

- Show: Keys tab → `cmk-demo-dev` → rotation policy (auto-rotate 30 days before expiry)
- Show: Diagnostic settings → AuditEvent logging to Log Analytics

**IAM** (Philip navigates)

> "We don't use built-in Contributor — that has wildcard permissions. We created custom roles."

- Show: Resource Group → IAM → Roles → `demo-dev-workload-operator`
- Click into permissions: "Every permission is explicitly listed. Zero wildcards."
- Show: Not Actions tab: "Even if someone escalates, these operations are blocked — can't delete the resource group, can't purge Key Vault, can't modify role assignments."

**Encryption**

> "Customer-managed RSA-4096 key. Storage account encrypted with CMK. Disk encryption set ready for any VMs."

- Show: Storage Account → Encryption → Customer-managed key
- Show: TLS 1.2, HTTPS only, shared access keys disabled

**Compliance Dashboard**

> "Azure Policy assignments mapped directly to SOC2 control IDs."

- Show: Policy → Compliance → assignments named `[CC6.7] Storage Encryption Required`, `[CC6.6] HTTPS Required`, etc.

> "Every control has a name, a policy, and automated evidence. No manual spreadsheets."

#### 3c. Compliance Report

```bash
terraform output -json compliance_report | jq .
```

> "Machine-readable compliance report. Every SOC2 control, with status, resource ID as proof, and human-readable evidence. Auditors can verify this against the Azure Portal."

```bash
terraform output -json compliance_summary | jq .
```

> "8 controls covered across 4 modules. All compliant."

### 4. Technical Highlights (30 seconds)

> "A few things that make this military-grade:"

- **Zero stored credentials** — GitHub Actions authenticates via OIDC. No secrets in the repo.
- **Every variable validated** — invalid input is rejected before apply.
- **Secure defaults everywhere** — Premium SKU, Deny network rules, purge protection. You opt INTO permissiveness, never out of security.
- **tfsec + checkov in CI** — misconfigurations blocked before merge.
- **Module toggles** — disable any module without breaking the others.

### 5. Future (30 seconds)

> "This is Azure-first, but the architecture supports multi-cloud. The module interface is provider-agnostic — same variables, same compliance output format. AWS is the next provider."
>
> "We also have the foundation for VM-level CIS benchmark checks — compute compliance as an extension."
>
> "Drop this into any client landing zone. One apply. Instant compliance."

---

## Backup Plan

If live `terraform apply` is too risky during the demo:

1. **Pre-deploy** resources before the demo
2. Show `terraform plan` output live (proves the code works)
3. Walk Azure Portal with pre-deployed resources
4. Show `terraform output` for compliance report

If Azure Portal is slow:

1. Show `terraform output -json compliance_report` instead
2. Show code in the modules (Key Vault config, RBAC roles, policy assignments)

If a module is broken:

```bash
# Disable and continue
terraform apply -var="enable_kms_encryption=false" -var="project_name=demo"
```

---

## Questions to Anticipate

| Question | Answer |
|---|---|
| "Does this cover full SOC2?" | No — we cover 8 of 60+ controls. The ones that can be automated via infrastructure. |
| "Why not HashiCorp Vault?" | Operational overhead. Key Vault is zero-ops, HSM-backed, native RBAC. See ADR-001. |
| "What about AWS?" | Architecture is provider-agnostic. AWS is the next module set. |
| "Can we use Deny instead of Audit?" | Yes — change `policy_effect = "Deny"`. We use Audit for hackathon velocity. |
| "How long to deploy?" | Under 90 seconds for all 4 modules. |
| "What if a module breaks?" | Toggle it off: `enable_kms_encryption = false`. Others unaffected. |

---

## Cleanup (after demo)

```bash
terraform destroy -var="project_name=demo" -auto-approve
```

Note: Key Vault with purge protection stays in soft-deleted state for 90 days. This is by design.
