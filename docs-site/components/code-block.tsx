import { cn } from "@/lib/utils";

interface CodeBlockProps {
  code: string;
  lang?: string;
  className?: string;
  title?: string;
}

// Lightweight HCL/bash highlighter — runs at build time
function highlight(code: string, lang: string): string {
  const lines = code.split("\n");
  return lines
    .map((line) => {
      let out = line
        .replace(/(#.*$)/g, '<span class="tok-comment">$1</span>')
        .replace(/"([^"]*)"/g, '<span class="tok-string">"$1"</span>');

      if (lang === "hcl" || lang === "terraform") {
        out = out.replace(
          /\b(resource|module|variable|output|provider|terraform|locals|data|count|for_each|sensitive|type|description|default|validation|condition|error_message)\b/g,
          '<span class="tok-keyword">$1</span>'
        );
        out = out.replace(
          /\b(string|number|bool|list|map|set|object|tuple|any|null|true|false)\b/g,
          '<span class="tok-attr">$1</span>'
        );
      } else if (lang === "bash" || lang === "shell") {
        out = out.replace(
          /^\s*(\$|>)/,
          '<span class="tok-attr">$1</span>'
        );
        out = out.replace(
          /\b(terraform|az|gh|git|export|cd|chmod|jq|curl)\b/g,
          '<span class="tok-fn">$1</span>'
        );
      } else if (lang === "yaml") {
        out = out.replace(
          /^([\s-]*)([a-zA-Z_-]+):/gm,
          '$1<span class="tok-attr">$2</span>:'
        );
      }

      return out;
    })
    .join("\n");
}

export function CodeBlock({ code, lang = "hcl", className, title }: CodeBlockProps) {
  const html = highlight(code.trim(), lang);
  return (
    <div className={cn("rounded-lg border border-ink-800 bg-ink-950/80 overflow-hidden", className)}>
      {title && (
        <div className="flex items-center justify-between border-b border-ink-800 bg-ink-900/60 px-4 py-2">
          <div className="flex items-center gap-2">
            <div className="flex gap-1.5">
              <span className="h-2.5 w-2.5 rounded-full bg-rose-500/70" />
              <span className="h-2.5 w-2.5 rounded-full bg-amber-500/70" />
              <span className="h-2.5 w-2.5 rounded-full bg-emerald-500/70" />
            </div>
            <span className="ml-2 text-xs font-mono text-ink-400">{title}</span>
          </div>
          <span className="text-xs font-mono uppercase tracking-wider text-ink-500">
            {lang}
          </span>
        </div>
      )}
      <pre className="overflow-x-auto p-4 text-sm leading-relaxed">
        <code
          className="font-mono text-ink-100"
          dangerouslySetInnerHTML={{ __html: html }}
        />
      </pre>
    </div>
  );
}
