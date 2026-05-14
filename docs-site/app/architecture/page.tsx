import { CodeBlock } from "@/components/code-block";
import { Workflow, Database, Lock, GitBranch } from "lucide-react";

export default function ArchitecturePage() {
  return (
    <div className="mx-auto max-w-7xl px-6 py-16">
      <div className="max-w-3xl mb-16">
        <div className="text-xs uppercase tracking-widest text-cyan-400 mb-3">
          Architecture
        </div>
        <h1 className="text-5xl font-bold tracking-tight text-ink-50">
          Built for composition.
        </h1>
        <p className="mt-4 text-lg text-ink-300">
          Each module is a self-contained Terraform unit with a strict interface contract.
          The root module wires them together with toggle variables and aggregates compliance
          evidence into a single output.
        </p>
      </div>

      {/* SYSTEM DIAGRAM */}
      <section className="mb-20">
        <h2 className="text-2xl font-semibold text-ink-50 mb-6 flex items-center gap-2">
          <Workflow className="h-6 w-6 text-cyan-400" />
          System Diagram
        </h2>
        <div className="rounded-xl border border-ink-800 bg-ink-900/40 p-8 overflow-x-auto">
          <pre className="font-mono text-xs text-ink-200 leading-relaxed">
{`GitHub Repository
     │
     ├── Push to main ─────► .github/workflows/deploy.yml
     │                            │
     │                            ├── OIDC Federation → Azure
     │                            ├── Whitelist runner IP on KV
     │                            ├── terraform init
     │                            ├── terraform plan
     │                            └── terraform apply ──► Azure RG
     │
     └── PR to dev/main ───► .github/workflows/plan.yml
                                  │
                                  ├── OIDC Federation
                                  ├── Whitelist runner IP
                                  ├── terraform plan
                                  └── Post plan to PR comment

Azure Resource Group (rg-<project>-<env>)
     │
     ├── secrets-rotation/
     │   ├── azurerm_key_vault                  [Premium · HSM]
     │   ├── azurerm_key_vault_key.example      [RSA-HSM · 30d rotation]
     │   └── azurerm_log_analytics_workspace    [Audit logs]
     │
     ├── iam-least-privilege/
     │   ├── azurerm_role_definition.workload_operator  [zero wildcards]
     │   └── azurerm_role_definition.security_reader    [read-only]
     │
     ├── kms-encryption/
     │   ├── azurerm_key_vault_key.cmk          [RSA-HSM 4096]
     │   ├── azurerm_storage_account            [CMK · TLS 1.2 · GRS]
     │   └── azurerm_disk_encryption_set        [for VM disks]
     │
     ├── compliance-checks/
     │   ├── azurerm_resource_group_policy_assignment.*   [4 SOC2 policies]
     │   └── azurerm_monitor_activity_log_alert.*         [3 alerts]
     │
     └── vm-compliance/
         └── azurerm_resource_group_policy_assignment.*   [6 CIS L1 policies]`}
          </pre>
        </div>
      </section>

      {/* REPO LAYOUT */}
      <section className="mb-20">
        <h2 className="text-2xl font-semibold text-ink-50 mb-6 flex items-center gap-2">
          <GitBranch className="h-6 w-6 text-cyan-400" />
          Repository Layout
        </h2>
        <div className="grid gap-6 lg:grid-cols-2">
          <CodeBlock
            title="zero-trust-compliance-pack/"
            lang="bash"
            code={`zero-trust-compliance-pack/
├── .github/
│   ├── workflows/
│   │   ├── validate.yml    # fmt, validate, tfsec, checkov
│   │   ├── plan.yml        # OIDC plan, post to PR
│   │   └── deploy.yml      # OIDC apply on main
│   ├── CODEOWNERS
│   └── pull_request_template.md
│
├── main.tf                 # Root — wires modules with toggles
├── variables.tf            # Top-level config
├── outputs.tf              # Aggregated compliance_report
├── providers.tf            # Pinned versions, OIDC backend
├── .tfsec.yml              # Severity threshold
├── .checkov.yaml           # Documented skips
│
├── bootstrap/
│   ├── main.tf             # State storage account
│   └── init-environment.sh # One-time setup
│
├── modules/
│   ├── secrets-rotation/
│   ├── iam-least-privilege/
│   ├── kms-encryption/
│   ├── compliance-checks/
│   └── vm-compliance/
│
├── examples/
│   └── azure-landing-zone/
│
└── docs/
    ├── compliance-matrix.md
    ├── architecture.md
    └── demo-script.md`}
          />
          <div className="space-y-6">
            <div className="rounded-xl border border-ink-800 bg-ink-900/40 p-6">
              <Lock className="h-5 w-5 text-cyan-400 mb-3" />
              <h3 className="font-semibold text-ink-50 mb-2">Module Toggle Pattern</h3>
              <p className="text-sm text-ink-300 mb-4">
                Every module is wrapped in <code className="font-mono text-cyan-400">count = var.enable_*</code> for
                clean independent disable.
              </p>
              <pre className="rounded-lg bg-ink-950/80 p-3 text-xs font-mono text-ink-200 overflow-x-auto">
{`module "secrets_rotation" {
  count  = var.enable_secrets_rotation ? 1 : 0
  source = "./modules/secrets-rotation"
  ...
}`}
              </pre>
            </div>

            <div className="rounded-xl border border-ink-800 bg-ink-900/40 p-6">
              <Database className="h-5 w-5 text-cyan-400 mb-3" />
              <h3 className="font-semibold text-ink-50 mb-2">Remote State Backend</h3>
              <p className="text-sm text-ink-300 mb-2">Azure Storage Account, OIDC-authenticated:</p>
              <ul className="text-xs text-ink-400 space-y-1 list-disc list-inside">
                <li>AES-256 encryption at rest</li>
                <li>HTTPS only, TLS 1.2 minimum</li>
                <li>Blob versioning for state recovery</li>
                <li>Blob lease locking (concurrent apply protection)</li>
                <li>Access restricted to service principal</li>
              </ul>
            </div>
          </div>
        </div>
      </section>

      {/* INTERFACE CONTRACT */}
      <section>
        <h2 className="text-2xl font-semibold text-ink-50 mb-6">
          Module Interface Contract
        </h2>
        <p className="text-ink-300 mb-6 max-w-3xl">
          Every module accepts the same five variables and exports a{" "}
          <code className="font-mono text-cyan-400">compliance_status</code> output keyed by SOC2 control ID.
          This makes modules interchangeable and the root aggregation trivial.
        </p>
        <div className="grid gap-6 lg:grid-cols-2">
          <CodeBlock
            title="Required inputs"
            lang="hcl"
            code={`variable "project_name" {
  type = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,23}$", var.project_name))
    error_message = "3-24 lowercase alphanumeric chars."
  }
}

variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Must be dev, staging, or production."
  }
}

variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tags" { type = map(string); default = {} }`}
          />
          <CodeBlock
            title="Required output"
            lang="hcl"
            code={`output "compliance_status" {
  description = "SOC2 evidence map keyed by control."
  value = {
    "CC6.X" = {
      control     = "CC6.X — Control name"
      status      = "COMPLIANT"
      resource_id = azurerm_some_resource.this.id
      evidence    = "Human-readable description"
    }
  }
}`}
          />
        </div>
      </section>
    </div>
  );
}
