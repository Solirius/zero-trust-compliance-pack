# Zero-Trust Pack Docs Site

Next.js 15 static site showcasing the Zero-Trust Secrets & Compliance Pack.
Deployed to GitHub Pages on every push to `main`.

## Stack

- **Framework**: Next.js 15 with `output: 'export'` (static)
- **Styling**: Tailwind CSS 3 with custom security palette
- **Icons**: lucide-react
- **Deploy**: GitHub Actions → GitHub Pages

## Live

https://solirius.github.io/zero-trust-compliance-pack/

## Local Dev

```bash
cd docs-site
npm install
npm run dev
# open http://localhost:3000
```

## Build

```bash
GITHUB_PAGES=true npm run build
# Static export → out/
```

## Pages

| Route | Purpose |
|---|---|
| `/` | Hero, value prop, module grid, pipeline flow |
| `/modules` | Detailed module breakdown with code samples |
| `/compliance` | SOC2 control matrix + ISO 27001 mapping |
| `/architecture` | System diagram, repo layout, interface contract |
| `/standards` | Zero-trust principles, secure defaults, anti-patterns |

## Aesthetic

Dark mode only. Deep navy background with subtle grid and radial glows.
Cyan/emerald accent palette signaling security and trust.
Mono code with custom syntax highlighting (HCL, bash, YAML).
