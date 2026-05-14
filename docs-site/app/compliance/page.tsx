import { CheckCircle2 } from "lucide-react";

const controls = [
  { id: "CC6.1", name: "Logical access security", module: "iam-least-privilege", evidence: "Custom RBAC roles with zero wildcard permissions, scoped to resource group" },
  { id: "CC6.2", name: "Credentials & secrets", module: "secrets-rotation", evidence: "Key Vault Premium SKU, RBAC auth, purge protection, rotation policy, audit logging to Log Analytics" },
  { id: "CC6.3", name: "Restrict unauthorized access", module: "iam-least-privilege", evidence: "not_actions deny blocks on dangerous operations (role modification, RG deletion, KV purge)" },
  { id: "CC6.6", name: "Encryption in transit", module: "kms-encryption", evidence: "TLS 1.2 minimum enforced, HTTPS-only traffic, shared access keys disabled" },
  { id: "CC6.7", name: "Encryption at rest", module: "kms-encryption", evidence: "Customer-managed RSA-4096 key with auto-rotation, storage CMK encryption, disk encryption set" },
  { id: "CC7.1", name: "Monitoring & detection", module: "compliance-checks", evidence: "Activity log alerts on RBAC role assignment changes, Azure Policy compliance monitoring" },
  { id: "CC7.2", name: "Anomaly detection", module: "compliance-checks", evidence: "Activity log alerts on Key Vault configuration changes" },
  { id: "CC8.1", name: "Change management", module: "compliance-checks", evidence: "All infrastructure Terraform-managed (IaC), policy change alerts for drift detection" },
];

const isoMapping = [
  { iso: "A.9.2.3", soc2: "CC6.1", desc: "Management of privileged access" },
  { iso: "A.9.4.3", soc2: "CC6.2", desc: "Password management" },
  { iso: "A.10.1.1", soc2: "CC6.6, CC6.7", desc: "Cryptographic controls" },
  { iso: "A.12.4.1", soc2: "CC7.1, CC7.2", desc: "Event logging" },
  { iso: "A.12.1.2", soc2: "CC8.1", desc: "Change management" },
];

export default function CompliancePage() {
  return (
    <div className="mx-auto max-w-7xl px-6 py-16">
      <div className="max-w-3xl mb-16">
        <div className="text-xs uppercase tracking-widest text-cyan-400 mb-3">
          Compliance Matrix
        </div>
        <h1 className="text-5xl font-bold tracking-tight text-ink-50">
          SOC2 control coverage.
        </h1>
        <p className="mt-4 text-lg text-ink-300">
          This pack automates evidence collection for 8 SOC2 Trust Services Criteria.
          We don't claim full SOC2 certification — we automate the infrastructure
          evidence that compliance teams spend weeks gathering manually.
        </p>
      </div>

      <div className="mb-16">
        <h2 className="text-2xl font-semibold text-ink-50 mb-6">SOC2 Trust Services Criteria</h2>
        <div className="overflow-hidden rounded-xl border border-ink-800 bg-ink-900/40">
          <table className="w-full text-left text-sm">
            <thead className="border-b border-ink-800 bg-ink-900/60">
              <tr>
                <th className="px-4 py-3 font-mono text-xs uppercase tracking-wider text-ink-400">Control</th>
                <th className="px-4 py-3 font-mono text-xs uppercase tracking-wider text-ink-400">Name</th>
                <th className="px-4 py-3 font-mono text-xs uppercase tracking-wider text-ink-400">Module</th>
                <th className="px-4 py-3 font-mono text-xs uppercase tracking-wider text-ink-400">Evidence</th>
                <th className="px-4 py-3 font-mono text-xs uppercase tracking-wider text-ink-400">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-ink-800">
              {controls.map((c) => (
                <tr key={c.id} className="transition hover:bg-ink-900/60">
                  <td className="px-4 py-4 font-mono text-emerald-400 font-medium whitespace-nowrap">
                    {c.id}
                  </td>
                  <td className="px-4 py-4 text-ink-100 font-medium">{c.name}</td>
                  <td className="px-4 py-4">
                    <code className="font-mono text-xs text-cyan-400 bg-cyan-400/5 px-2 py-0.5 rounded border border-cyan-400/10">
                      {c.module}
                    </code>
                  </td>
                  <td className="px-4 py-4 text-ink-300 text-xs leading-relaxed">{c.evidence}</td>
                  <td className="px-4 py-4">
                    <span className="inline-flex items-center gap-1 rounded-full bg-emerald-400/10 px-2 py-0.5 text-[11px] font-mono text-emerald-400 border border-emerald-400/20">
                      <CheckCircle2 className="h-3 w-3" />
                      COMPLIANT
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      <div className="grid gap-10 md:grid-cols-2">
        <div>
          <h2 className="text-2xl font-semibold text-ink-50 mb-6">ISO 27001 Cross-Reference</h2>
          <div className="overflow-hidden rounded-xl border border-ink-800 bg-ink-900/40">
            <table className="w-full text-left text-sm">
              <thead className="border-b border-ink-800 bg-ink-900/60">
                <tr>
                  <th className="px-4 py-3 font-mono text-xs uppercase tracking-wider text-ink-400">ISO</th>
                  <th className="px-4 py-3 font-mono text-xs uppercase tracking-wider text-ink-400">SOC2</th>
                  <th className="px-4 py-3 font-mono text-xs uppercase tracking-wider text-ink-400">Description</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-ink-800">
                {isoMapping.map((m) => (
                  <tr key={m.iso}>
                    <td className="px-4 py-3 font-mono text-cyan-400">{m.iso}</td>
                    <td className="px-4 py-3 font-mono text-emerald-400 text-xs">{m.soc2}</td>
                    <td className="px-4 py-3 text-ink-300 text-xs">{m.desc}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        <div>
          <h2 className="text-2xl font-semibold text-ink-50 mb-6">Evidence Collection</h2>
          <div className="rounded-xl border border-ink-800 bg-ink-900/40 p-6">
            <p className="text-ink-300 text-sm mb-4">
              After <code className="font-mono text-cyan-400">terraform apply</code>, extract evidence with:
            </p>
            <pre className="rounded-lg bg-ink-950/80 p-4 text-xs font-mono text-ink-100 overflow-x-auto">
{`$ terraform output -json compliance_report | jq .

{
  "CC6.1": {
    "control": "CC6.1 — Logical access security",
    "status": "COMPLIANT",
    "resource_id": "/subscriptions/.../roleDefinitions/...",
    "evidence": "Custom RBAC roles with zero wildcard permissions..."
  },
  ...
}`}
            </pre>
            <p className="mt-4 text-xs text-ink-400">
              Machine-readable. Re-runnable. Versioned in state.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
