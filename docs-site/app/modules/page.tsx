import { Key, Shield, Lock, Eye, Server } from "lucide-react";
import { CodeBlock } from "@/components/code-block";

const modules = [
  {
    icon: Key,
    name: "Secrets Rotation",
    slug: "secrets-rotation",
    controls: ["CC6.2"],
    summary: "Azure Key Vault Premium with HSM-backed keys and automated rotation policy.",
    deployed: [
      "Azure Key Vault (Premium SKU, HSM-backed)",
      "RBAC authorization — no legacy access policies",
      "Purge protection · soft-delete 90 days",
      "Default-deny network ACLs with AzureServices bypass",
      "Example key with RSA-HSM rotation (30 days)",
      "Diagnostic logging to Log Analytics Workspace",
    ],
    code: `module "secrets" {
  source = "./modules/secrets-rotation"

  project_name        = "myproject"
  environment         = "production"
  resource_group_name = azurerm_resource_group.main.name

  key_vault_sku              = "premium"
  soft_delete_retention_days = 90
  allowed_ips                = ["203.0.113.0/24"]
}`,
  },
  {
    icon: Shield,
    name: "IAM Least-Privilege",
    slug: "iam-least-privilege",
    controls: ["CC6.1", "CC6.3"],
    summary: "Custom Azure RBAC roles with zero wildcard permissions and explicit deny blocks.",
    deployed: [
      "Workload Operator role — explicit actions only",
      "Security Reader role — zero write permissions",
      "not_actions block: role modification, RG deletion, KV purge",
      "not_data_actions: secret purge, blob deletion",
      "Validated UUID format on all principal IDs",
      "Scoped to resource group, not subscription",
    ],
    code: `module "iam" {
  source = "./modules/iam-least-privilege"

  project_name        = "myproject"
  environment         = "production"
  resource_group_name = azurerm_resource_group.main.name

  workload_principal_ids = ["<sp-object-id>"]
  reader_principal_ids   = ["<auditor-object-id>"]
}`,
  },
  {
    icon: Lock,
    name: "KMS Encryption",
    slug: "kms-encryption",
    controls: ["CC6.6", "CC6.7"],
    summary: "Customer-managed RSA-4096 keys with auto-rotation for storage and disks.",
    deployed: [
      "CMK RSA-HSM 4096 with 30-day pre-expiry rotation",
      "Storage Account encrypted with CMK · GRS · TLS 1.2",
      "Shared keys disabled · Azure AD auth only",
      "Disk Encryption Set linked to CMK",
      "Blob soft-delete + container soft-delete (7 days)",
      "Public network access via firewall only",
    ],
    code: `module "encryption" {
  source = "./modules/kms-encryption"

  project_name        = "myproject"
  environment         = "production"
  resource_group_name = azurerm_resource_group.main.name

  key_vault_id = module.secrets.key_vault_id
}`,
  },
  {
    icon: Eye,
    name: "Compliance Checks",
    slug: "compliance-checks",
    controls: ["CC7.1", "CC7.2", "CC8.1"],
    summary: "Azure Policy initiative mapped to SOC2 controls plus activity log alerts.",
    deployed: [
      "Policy: storage encryption required (CC6.7)",
      "Policy: HTTPS-only storage (CC6.6)",
      "Policy: Key Vault purge protection (CC6.2)",
      "Policy: disk encryption required (CC6.7)",
      "Alert: RBAC role assignment changes (CC7.1)",
      "Alert: Key Vault configuration changes (CC7.2)",
      "Alert: Azure Policy modifications (CC8.1)",
    ],
    code: `module "compliance" {
  source = "./modules/compliance-checks"

  project_name        = "myproject"
  environment         = "production"
  resource_group_name = azurerm_resource_group.main.name

  key_vault_id               = module.secrets.key_vault_id
  enable_activity_log_alerts = true
}`,
  },
  {
    icon: Server,
    name: "VM Compliance",
    slug: "vm-compliance",
    controls: ["CIS L1"],
    summary: "CIS Level 1 benchmark checks for Azure Virtual Machines.",
    deployed: [
      "CIS 5.2.4 — SSH key authentication required",
      "CIS 1.4 — Restrict open network ports on NSGs",
      "Audit passwordless remote login",
      "VM disk encryption required",
      "System updates installed",
      "Monitoring agent required",
    ],
    code: `module "vm_compliance" {
  source = "./modules/vm-compliance"

  project_name        = "myproject"
  environment         = "production"
  resource_group_name = azurerm_resource_group.main.name
}`,
  },
];

export default function ModulesPage() {
  return (
    <div className="mx-auto max-w-7xl px-6 py-16">
      <div className="max-w-3xl mb-16">
        <div className="text-xs uppercase tracking-widest text-cyan-400 mb-3">
          Modules
        </div>
        <h1 className="text-5xl font-bold tracking-tight text-ink-50">
          Five modules. One contract.
        </h1>
        <p className="mt-4 text-lg text-ink-300">
          Each module follows the same interface — validated inputs,
          secure defaults, and a <code className="font-mono text-cyan-400">compliance_status</code> output
          that aggregates into the root <code className="font-mono text-cyan-400">compliance_report</code>.
        </p>
      </div>

      <div className="space-y-20">
        {modules.map((m, idx) => {
          const Icon = m.icon;
          return (
            <article
              id={m.slug}
              key={m.slug}
              className="grid gap-10 lg:grid-cols-5 lg:items-start scroll-mt-24"
            >
              <header className="lg:col-span-2">
                <div className="flex items-center gap-3 mb-4">
                  <div className="rounded-lg border border-cyan-400/20 bg-cyan-400/5 p-2.5">
                    <Icon className="h-6 w-6 text-cyan-400" />
                  </div>
                  <div className="font-mono text-xs text-ink-500">
                    {String(idx + 1).padStart(2, "0")} / 05
                  </div>
                </div>
                <h2 className="text-3xl font-bold text-ink-50">{m.name}</h2>
                <div className="mt-3 flex flex-wrap gap-1.5">
                  {m.controls.map((c) => (
                    <span
                      key={c}
                      className="rounded-full bg-emerald-400/10 px-2.5 py-0.5 text-[11px] font-mono text-emerald-400 border border-emerald-400/20"
                    >
                      {c}
                    </span>
                  ))}
                </div>
                <p className="mt-4 text-ink-300">{m.summary}</p>
                <ul className="mt-6 space-y-2">
                  {m.deployed.map((item) => (
                    <li key={item} className="flex items-start gap-2 text-sm text-ink-300">
                      <span className="mt-2 h-1 w-1 flex-shrink-0 rounded-full bg-cyan-400" />
                      <span>{item}</span>
                    </li>
                  ))}
                </ul>
              </header>
              <div className="lg:col-span-3">
                <CodeBlock title={`modules/${m.slug}/main.tf`} lang="hcl" code={m.code} />
              </div>
            </article>
          );
        })}
      </div>
    </div>
  );
}
