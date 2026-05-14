import type { Metadata } from "next";
import "./globals.css";
import { Nav } from "@/components/nav";
import { Footer } from "@/components/footer";

export const metadata: Metadata = {
  title: "Zero-Trust Secrets & Compliance Pack",
  description:
    "One terraform apply. Instant SOC2 compliance. Zero stored credentials. A drop-in Terraform module for Azure landing zones.",
  metadataBase: new URL("https://solirius.github.io/zero-trust-compliance-pack/"),
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en">
      <body className="antialiased">
        <Nav />
        <main className="relative">{children}</main>
        <Footer />
      </body>
    </html>
  );
}
