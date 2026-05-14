import Link from "next/link";
import { Shield, Github } from "lucide-react";

const links = [
  { href: "/modules/", label: "Modules" },
  { href: "/compliance/", label: "Compliance" },
  { href: "/architecture/", label: "Architecture" },
  { href: "/standards/", label: "Standards" },
];

export function Nav() {
  return (
    <header className="sticky top-0 z-50 border-b border-ink-800/60 bg-ink-950/60 backdrop-blur-xl">
      <nav className="mx-auto flex h-16 max-w-7xl items-center justify-between px-6">
        <Link href="/" className="flex items-center gap-2.5 group">
          <div className="relative">
            <Shield className="h-6 w-6 text-cyan-400 transition group-hover:scale-110" />
            <div className="absolute inset-0 blur-md bg-cyan-400/50 -z-10 animate-glow" />
          </div>
          <span className="font-semibold tracking-tight text-ink-50">
            Zero-Trust Pack
          </span>
          <span className="hidden sm:inline-block ml-1 rounded-full bg-cyan-400/10 px-2 py-0.5 text-[10px] font-mono uppercase tracking-widest text-cyan-400 border border-cyan-400/20">
            v1.0
          </span>
        </Link>

        <ul className="hidden md:flex items-center gap-1">
          {links.map((link) => (
            <li key={link.href}>
              <Link
                href={link.href}
                className="rounded-md px-3 py-1.5 text-sm text-ink-300 transition hover:text-ink-50 hover:bg-ink-800/50"
              >
                {link.label}
              </Link>
            </li>
          ))}
        </ul>

        <a
          href="https://github.com/Solirius/zero-trust-compliance-pack"
          className="flex items-center gap-2 rounded-md border border-ink-700 bg-ink-800/50 px-3 py-1.5 text-sm text-ink-100 transition hover:border-cyan-400/40 hover:bg-ink-800"
        >
          <Github className="h-4 w-4" />
          <span className="hidden sm:inline">GitHub</span>
        </a>
      </nav>
    </header>
  );
}
