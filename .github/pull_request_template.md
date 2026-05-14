## Summary
<!-- What does this PR do? One sentence. -->

## SOC2 Controls Affected
<!-- Which controls does this change affect? (CC6.1, CC6.2, CC6.3, CC6.6, CC6.7, CC7.1, CC7.2, CC8.1) -->

- [ ] N/A — no compliance impact

## Security Checklist

- [ ] All variables have `validation {}` blocks
- [ ] No hardcoded values or magic strings
- [ ] Secure defaults (Deny, Premium, purge protection enabled)
- [ ] `sensitive = true` on all secret outputs
- [ ] No wildcard (`*`) permissions in role definitions
- [ ] `compliance_status` output present (if module change)
- [ ] No secrets in Terraform state (`terraform show` checked)
- [ ] README updated (if module change)

## Terraform Plan

<details>
<summary>Click to expand plan output</summary>

```
<paste terraform plan output here>
```

</details>

## Testing

- [ ] `terraform fmt -check -recursive` passes
- [ ] `terraform validate` passes
- [ ] `tfsec .` — no HIGH/CRITICAL findings
- [ ] `terraform plan` runs without errors
- [ ] `terraform apply` tested (if applicable)
