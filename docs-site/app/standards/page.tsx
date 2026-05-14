import { CodeBlock } from "@/components/code-block";
import { ShieldCheck, Lock, AlertTriangle, Eye, Network } from "lucide-react";

const principles = [
  {
    icon: ShieldCheck,
    title: "Never trust, always verify",
    desc: "No implicit permissions. Every access requires explicit grant. Default-deny on all resources.",
  },
  {
    icon: Lock,
    title: "Least privilege",
    desc: "Every role, policy, and service principal scoped to the minimum required. No wildcards. Ever.",
  },
  {
    icon: AlertTriangle,
    title: "Assume breach",
    desc: "Encrypt everything. Log everything. Alert on anomalies. Design as if the attacker is inside.",
  },
  {
    icon: Eye,
    title: "No long-lived credentials",
    desc: "OIDC federation for CI/CD. Managed identities for Azure workloads. Zero stored secrets.",
  },
  {
    icon: Network,
    title: "Defense in depth",
    desc: "Multiple independent security layers. Encryption + RBAC + network rules + audit. If one fails, others hold.",
  },
];

const checklist = [
  { ok: true, item: "Every variable has a validation block" },
  { ok: true, item: "Zero hardcoded values or magic strings" },
  { ok: true, item: "Secure defaults — most restrictive option" },
  { ok: true, item: "sensitive = true on all secret outputs" },
  { ok: true, item: "compliance_status output for SOC2 aggregation" },
  { ok: true, item: "Idempotent — terraform apply is safe to re-run" },
  { ok: true, item: "Tagged with environment, project, module, managed_by" },
  { ok: true, item: "README with usage, inputs, outputs, controls" },
  { ok: true, item: "No wildcards (*) in any role definition" },
  { ok: true, item: "No plaintext secrets in Terraform state" },
];

const defaults = [
  { var: "key_vault_sku", value: '"premium"', why: "HSM-backed" },
  { var: "network_acls_default_action", value: '"Deny"', why: "Block by default" },
  { var: "purge_protection_enabled", value: "true", why: "Cannot accidentally destroy" },
  { var: "min_tls_version", value: '"TLS1_2"', why: "Industry minimum" },
  { var: "https_traffic_only_enabled", value: "true", why: "No HTTP in 2026" },
  { var: "shared_access_key_enabled", value: "false", why: "Force Azure AD auth" },
  { var: "allow_nested_items_to_be_public", value: "false", why: "No public blobs" },
  { var: "enable_activity_log_alerts", value: "true", why: "Anomaly detection on" },
  { var: "enable_diagnostic_logging", value: "true", why: "Audit trail required" },
  { var: "soft_delete_retention_days", value: "90", why: "Maximum recovery window" },
];

export default function StandardsPage() {
  return (
    <div className="mx-auto max-w-7xl px-6 py-16">
      <div className="max-w-3xl mb-16">
        <div className="text-xs uppercase tracking-widest text-cyan-400 mb-3">
          Engineering Standards
        </div>
        <h1 className="text-5xl font-bold tracking-tight text-ink-50">
          Military-grade defaults.
        </h1>
        <p className="mt-4 text-lg text-ink-300">
          Non-negotiable rules. Code that violates them does not merge.
          Every contributor codes to this contract.
        </p>
      </div>

      {/* PRINCIPLES */}
      <section className="mb-20">
        <h2 className="text-2xl font-semibold text-ink-50 mb-8">Zero-Trust Principles</h2>
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {principles.map((p) => {
            const Icon = p.icon;
            return (
              <div
                key={p.title}
                className="rounded-xl border border-ink-800 bg-ink-900/40 p-6 transition hover:border-cyan-400/30"
              >
                <Icon className="h-7 w-7 text-cyan-400 mb-4" />
                <h3 className="font-semibold text-ink-50">{p.title}</h3>
                <p className="mt-2 text-sm text-ink-300 leading-relaxed">{p.desc}</p>
              </div>
            );
          })}
        </div>
      </section>

      {/* CHECKLIST */}
      <section className="mb-20">
        <h2 className="text-2xl font-semibold text-ink-50 mb-8">Module Standards Checklist</h2>
        <div className="rounded-xl border border-ink-800 bg-ink-900/40 p-6">
          <div className="grid gap-3 md:grid-cols-2">
            {checklist.map((c) => (
              <div key={c.item} className="flex items-start gap-3">
                <span className="mt-0.5 inline-flex h-5 w-5 flex-shrink-0 items-center justify-center rounded-full bg-emerald-400/10 text-emerald-400 font-mono text-xs border border-emerald-400/30">
                  ✓
                </span>
                <span className="text-sm text-ink-200">{c.item}</span>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* SECURE DEFAULTS */}
      <section className="mb-20">
        <h2 className="text-2xl font-semibold text-ink-50 mb-3">Secure Defaults</h2>
        <p className="text-ink-300 mb-6 max-w-3xl">
          Every default value is the <strong className="text-ink-100">most secure</strong> option.
          Users opt INTO permissiveness, never out of security.
        </p>
        <div className="overflow-hidden rounded-xl border border-ink-800 bg-ink-900/40">
          <table className="w-full text-left text-sm">
            <thead className="border-b border-ink-800 bg-ink-900/60">
              <tr>
                <th className="px-4 py-3 font-mono text-xs uppercase tracking-wider text-ink-400">Variable</th>
                <th className="px-4 py-3 font-mono text-xs uppercase tracking-wider text-ink-400">Default</th>
                <th className="px-4 py-3 font-mono text-xs uppercase tracking-wider text-ink-400">Why</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-ink-800">
              {defaults.map((d) => (
                <tr key={d.var}>
                  <td className="px-4 py-3 font-mono text-cyan-400">{d.var}</td>
                  <td className="px-4 py-3 font-mono text-amber-400">{d.value}</td>
                  <td className="px-4 py-3 text-ink-300">{d.why}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>

      {/* ANTI-PATTERNS */}
      <section>
        <h2 className="text-2xl font-semibold text-ink-50 mb-3">Anti-Patterns</h2>
        <p className="text-ink-300 mb-6 max-w-3xl">
          What good code does <em>not</em> look like, with the corrected pattern.
        </p>
        <div className="grid gap-6 lg:grid-cols-2">
          <div>
            <div className="text-xs font-mono uppercase tracking-wider text-rose-400 mb-2">
              ❌ Wrong — wildcard permission
            </div>
            <CodeBlock
              lang="hcl"
              code={`permissions {
  actions = ["*"]
}`}
            />
          </div>
          <div>
            <div className="text-xs font-mono uppercase tracking-wider text-emerald-400 mb-2">
              ✓ Right — explicit enumeration
            </div>
            <CodeBlock
              lang="hcl"
              code={`permissions {
  actions = [
    "Microsoft.KeyVault/vaults/secrets/read",
    "Microsoft.Storage/storageAccounts/read",
  ]
}`}
            />
          </div>
          <div>
            <div className="text-xs font-mono uppercase tracking-wider text-rose-400 mb-2">
              ❌ Wrong — plaintext secret in state
            </div>
            <CodeBlock
              lang="hcl"
              code={`resource "azurerm_key_vault_secret" "ex" {
  value = "initial-value-123"
}`}
            />
          </div>
          <div>
            <div className="text-xs font-mono uppercase tracking-wider text-emerald-400 mb-2">
              ✓ Right — generated, ignored on changes
            </div>
            <CodeBlock
              lang="hcl"
              code={`resource "random_password" "ex" {
  length = 32
}
resource "azurerm_key_vault_secret" "ex" {
  value = random_password.ex.result
  lifecycle { ignore_changes = [value] }
}`}
            />
          </div>
        </div>
      </section>
    </div>
  );
}
