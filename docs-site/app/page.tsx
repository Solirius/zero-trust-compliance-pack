import Link from "next/link";
import { ArrowRight, Shield, Key, Lock, Eye, Server, CheckCircle2, Zap, GitBranch, Sparkles } from "lucide-react";
import { CodeBlock } from "@/components/code-block";

const modules = [
  { icon: Key, name: "Secrets Rotation", controls: ["CC6.2"], desc: "Azure Key Vault Premium with HSM-backed keys, automated rotation, audit logging.", accent: "cyan" },
  { icon: Shield, name: "IAM Least-Privilege", controls: ["CC6.1", "CC6.3"], desc: "Custom RBAC roles with zero wildcards. Deny assignments block dangerous operations.", accent: "emerald" },
  { icon: Lock, name: "KMS Encryption", controls: ["CC6.6", "CC6.7"], desc: "Customer-managed RSA-4096 keys. TLS 1.2 minimum. Disk encryption sets.", accent: "amber" },
  { icon: Eye, name: "Compliance Checks", controls: ["CC7.1", "CC7.2", "CC8.1"], desc: "Azure Policy mapped to SOC2. Activity log alerts. Drift detection.", accent: "cyan" },
  { icon: Server, name: "VM Compliance", controls: ["CIS L1"], desc: "CIS Level 1 benchmark checks. SSH hardening, encryption, system updates.", accent: "emerald" },
];

const stats = [
  { value: "8", label: "SOC2 Controls" },
  { value: "5", label: "Modules" },
  { value: "0", label: "Stored Credentials" },
  { value: "<90s", label: "Deploy Time" },
];

export default function Home() {
  return (
    <>
      {/* HERO */}
      <section className="relative overflow-hidden border-b border-ink-800/60">
        <div className="absolute inset-0 bg-grid opacity-40" />
        <div className="absolute inset-0 bg-gradient-to-b from-transparent via-transparent to-ink-950" />
        <div className="relative mx-auto max-w-7xl px-6 pt-24 pb-32">
          <div className="inline-flex items-center gap-2 rounded-full border border-cyan-400/20 bg-cyan-400/5 px-3 py-1 text-xs font-mono uppercase tracking-widest text-cyan-400 mb-8 animate-fade-up">
            <Sparkles className="h-3 w-3" />
            v1.0 · Multi-cloud · Azure-first
          </div>

          <h1 className="text-5xl md:text-7xl font-bold tracking-tighter text-ink-50 max-w-4xl leading-[1.05] animate-fade-up">
            Zero-trust security,{" "}
            <span className="bg-gradient-to-r from-cyan-400 via-emerald-400 to-cyan-400 bg-[length:200%_auto] bg-clip-text text-transparent animate-gradient-x">
              one terraform apply.
            </span>
          </h1>

          <p className="mt-6 max-w-2xl text-lg md:text-xl text-ink-300 animate-fade-up">
            A drop-in Terraform module that delivers secret rotation, least-privilege IAM,
            customer-managed encryption, and SOC2 compliance evidence to any Azure landing zone —
            in under 90 seconds, with zero stored credentials.
          </p>

          <div className="mt-10 flex flex-wrap items-center gap-4 animate-fade-up">
            <Link
              href="/modules/"
              className="group inline-flex items-center gap-2 rounded-lg bg-cyan-400 px-5 py-3 text-sm font-medium text-ink-950 transition hover:bg-cyan-300 glow-cyan"
            >
              Explore Modules
              <ArrowRight className="h-4 w-4 transition group-hover:translate-x-0.5" />
            </Link>
            <a
              href="https://github.com/Solirius/zero-trust-compliance-pack"
              className="inline-flex items-center gap-2 rounded-lg border border-ink-700 bg-ink-900/50 px-5 py-3 text-sm font-medium text-ink-100 transition hover:border-cyan-400/40 hover:bg-ink-800"
            >
              <GitBranch className="h-4 w-4" />
              View Source
            </a>
          </div>

          <div className="mt-16 grid gap-6 sm:grid-cols-4 max-w-3xl animate-fade-up">
            {stats.map((s) => (
              <div key={s.label} className="rounded-lg border border-ink-800 bg-ink-900/40 p-4">
                <div className="font-mono text-3xl font-bold text-cyan-400">{s.value}</div>
                <div className="mt-1 text-xs uppercase tracking-wider text-ink-400">{s.label}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* QUICK START */}
      <section className="relative border-b border-ink-800/60 py-24">
        <div className="mx-auto max-w-7xl px-6">
          <div className="grid gap-12 lg:grid-cols-2 lg:items-center">
            <div>
              <div className="text-xs uppercase tracking-widest text-cyan-400 mb-3">
                Quick Start
              </div>
              <h2 className="text-4xl font-bold tracking-tight text-ink-50">
                Three lines.<br />Full compliance.
              </h2>
              <p className="mt-4 text-lg text-ink-300">
                Drop this into any Terraform configuration. The module handles
                secrets, IAM, encryption, and compliance evidence with secure defaults.
                You opt into permissiveness, never out of security.
              </p>
              <ul className="mt-8 space-y-3">
                {[
                  "Validated inputs — bad config rejected at plan time",
                  "Zero wildcards in any RBAC role",
                  "HSM-backed keys with automated rotation",
                  "Azure Policy mapped to 8 SOC2 controls",
                  "OIDC federation — no stored credentials",
                ].map((item) => (
                  <li key={item} className="flex items-start gap-3 text-ink-200">
                    <CheckCircle2 className="mt-0.5 h-5 w-5 flex-shrink-0 text-emerald-400" />
                    <span>{item}</span>
                  </li>
                ))}
              </ul>
            </div>

            <CodeBlock
              title="main.tf"
              lang="hcl"
              code={`module "zero_trust" {
  source = "github.com/Solirius/zero-trust-compliance-pack"

  project_name        = "my-landing-zone"
  environment         = "production"
  resource_group_name = azurerm_resource_group.main.name

  # Secure defaults — opt INTO permissiveness
  enable_secrets_rotation    = true
  enable_iam_least_privilege = true
  enable_kms_encryption      = true
  enable_compliance_checks   = true

  tags = {
    team        = "platform"
    cost_center = "1234"
  }
}

output "compliance_report" {
  value = module.zero_trust.compliance_report
}`}
            />
          </div>
        </div>
      </section>

      {/* MODULES GRID */}
      <section className="relative border-b border-ink-800/60 py-24">
        <div className="mx-auto max-w-7xl px-6">
          <div className="max-w-2xl mb-12">
            <div className="text-xs uppercase tracking-widest text-cyan-400 mb-3">
              Module Inventory
            </div>
            <h2 className="text-4xl font-bold tracking-tight text-ink-50">
              Five modules. One contract.
            </h2>
            <p className="mt-4 text-lg text-ink-300">
              Every module follows the same interface — validated inputs, secure
              defaults, and a <code className="font-mono text-cyan-400">compliance_status</code> output
              that aggregates into a single SOC2 report.
            </p>
          </div>

          <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
            {modules.map((m) => {
              const Icon = m.icon;
              return (
                <Link
                  href="/modules/"
                  key={m.name}
                  className="group relative overflow-hidden rounded-xl border border-ink-800 bg-ink-900/40 p-6 transition hover:border-cyan-400/30 hover:bg-ink-900/70"
                >
                  <div className="absolute inset-0 bg-gradient-to-br from-cyan-400/0 to-cyan-400/0 transition group-hover:from-cyan-400/[0.03] group-hover:to-emerald-400/[0.03]" />
                  <div className="relative">
                    <div className="flex items-center justify-between mb-4">
                      <Icon className="h-7 w-7 text-cyan-400" />
                      <div className="flex gap-1.5">
                        {m.controls.map((c) => (
                          <span
                            key={c}
                            className="rounded-full bg-emerald-400/10 px-2 py-0.5 text-[10px] font-mono text-emerald-400 border border-emerald-400/20"
                          >
                            {c}
                          </span>
                        ))}
                      </div>
                    </div>
                    <h3 className="text-lg font-semibold text-ink-50">{m.name}</h3>
                    <p className="mt-2 text-sm text-ink-300 leading-relaxed">{m.desc}</p>
                    <div className="mt-4 inline-flex items-center gap-1 text-xs text-ink-400 transition group-hover:text-cyan-400">
                      Read more
                      <ArrowRight className="h-3 w-3 transition group-hover:translate-x-0.5" />
                    </div>
                  </div>
                </Link>
              );
            })}
          </div>
        </div>
      </section>

      {/* PIPELINE FLOW */}
      <section className="relative border-b border-ink-800/60 py-24">
        <div className="mx-auto max-w-7xl px-6">
          <div className="max-w-2xl mb-12">
            <div className="text-xs uppercase tracking-widest text-cyan-400 mb-3">
              Pipeline Flow
            </div>
            <h2 className="text-4xl font-bold tracking-tight text-ink-50">
              GitOps. OIDC. Zero credentials.
            </h2>
            <p className="mt-4 text-lg text-ink-300">
              Every deployment authenticates to Azure via GitHub OIDC federation.
              No client secrets, no long-lived tokens, no manual approval gates.
            </p>
          </div>

          <div className="grid gap-4 md:grid-cols-4">
            {[
              { step: "01", title: "Push to branch", desc: "Open a PR to dev or main" },
              { step: "02", title: "Validate", desc: "fmt · validate · tfsec · checkov" },
              { step: "03", title: "Plan", desc: "OIDC auth · plan posted to PR" },
              { step: "04", title: "Apply", desc: "Merge to main · auto-deploy" },
            ].map((s, i) => (
              <div key={s.step} className="relative rounded-xl border border-ink-800 bg-ink-900/40 p-6">
                {i < 3 && (
                  <div className="hidden md:block absolute -right-2 top-1/2 -translate-y-1/2 z-10">
                    <ArrowRight className="h-4 w-4 text-cyan-400/40" />
                  </div>
                )}
                <div className="font-mono text-xs text-cyan-400 mb-2">{s.step}</div>
                <h3 className="font-semibold text-ink-50">{s.title}</h3>
                <p className="mt-1 text-sm text-ink-400">{s.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="relative py-24">
        <div className="mx-auto max-w-7xl px-6">
          <div className="relative overflow-hidden rounded-2xl border border-ink-800 bg-gradient-to-br from-ink-900 via-ink-900 to-ink-950 p-12 md:p-16">
            <div className="absolute inset-0 bg-grid opacity-30" />
            <div className="absolute -top-24 -right-24 h-64 w-64 rounded-full bg-cyan-400/10 blur-3xl" />
            <div className="absolute -bottom-24 -left-24 h-64 w-64 rounded-full bg-emerald-400/10 blur-3xl" />
            <div className="relative max-w-2xl">
              <Zap className="h-10 w-10 text-cyan-400 mb-6" />
              <h2 className="text-4xl md:text-5xl font-bold tracking-tight text-ink-50">
                Deploy in under 90 seconds.
              </h2>
              <p className="mt-4 text-lg text-ink-300">
                Stop hand-rolling security for every landing zone. This pack handles
                rotation, RBAC, encryption, and audit evidence as one module.
              </p>
              <div className="mt-8 flex flex-wrap gap-4">
                <Link
                  href="/modules/"
                  className="inline-flex items-center gap-2 rounded-lg bg-cyan-400 px-5 py-3 text-sm font-medium text-ink-950 transition hover:bg-cyan-300"
                >
                  Browse Modules
                  <ArrowRight className="h-4 w-4" />
                </Link>
                <Link
                  href="/compliance/"
                  className="inline-flex items-center gap-2 rounded-lg border border-ink-700 bg-ink-800/50 px-5 py-3 text-sm font-medium text-ink-100 transition hover:border-cyan-400/40 hover:bg-ink-800"
                >
                  SOC2 Matrix
                </Link>
              </div>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
