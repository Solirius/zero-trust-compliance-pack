import { Shield } from "lucide-react";

export function Footer() {
  return (
    <footer className="border-t border-ink-800/60 bg-ink-950/40 mt-20">
      <div className="mx-auto max-w-7xl px-6 py-12">
        <div className="grid gap-8 md:grid-cols-4">
          <div>
            <div className="flex items-center gap-2 mb-3">
              <Shield className="h-5 w-5 text-cyan-400" />
              <span className="font-semibold text-ink-50">Zero-Trust Pack</span>
            </div>
            <p className="text-sm text-ink-400">
              Military-grade SOC2 compliance for Azure landing zones.
            </p>
          </div>
          <div>
            <h4 className="text-xs uppercase tracking-widest text-ink-500 mb-3">Modules</h4>
            <ul className="space-y-2 text-sm">
              <li><a href="/modules/" className="text-ink-300 hover:text-cyan-400">Secrets Rotation</a></li>
              <li><a href="/modules/" className="text-ink-300 hover:text-cyan-400">IAM Least-Privilege</a></li>
              <li><a href="/modules/" className="text-ink-300 hover:text-cyan-400">KMS Encryption</a></li>
              <li><a href="/modules/" className="text-ink-300 hover:text-cyan-400">Compliance Checks</a></li>
            </ul>
          </div>
          <div>
            <h4 className="text-xs uppercase tracking-widest text-ink-500 mb-3">Resources</h4>
            <ul className="space-y-2 text-sm">
              <li><a href="/compliance/" className="text-ink-300 hover:text-cyan-400">SOC2 Matrix</a></li>
              <li><a href="/standards/" className="text-ink-300 hover:text-cyan-400">Engineering Standards</a></li>
              <li><a href="https://github.com/Solirius/zero-trust-compliance-pack/wiki" className="text-ink-300 hover:text-cyan-400">Wiki</a></li>
            </ul>
          </div>
          <div>
            <h4 className="text-xs uppercase tracking-widest text-ink-500 mb-3">Team</h4>
            <ul className="space-y-2 text-sm text-ink-300">
              <li>Ayo — Principal</li>
              <li>Owen — Engineer</li>
              <li>Philip Afrane — Engineer</li>
            </ul>
          </div>
        </div>
        <div className="mt-10 pt-6 border-t border-ink-800 text-xs text-ink-500 flex justify-between">
          <span>© 2026 Solirius Technology</span>
          <span className="font-mono">v1.0.0 · main</span>
        </div>
      </div>
    </footer>
  );
}
