# Example: Deploy zero-trust compliance pack into an Azure landing zone
#
# Usage:
#   cd examples/azure-landing-zone
#   terraform init
#   terraform plan
#   terraform apply

module "zero_trust" {
  source = "../../"

  project_name = "demo-landing-zone"
  environment  = "dev"
  location     = "West Europe"

  # Module toggles — disable any module independently
  enable_secrets_rotation    = true
  enable_iam_least_privilege = true
  enable_kms_encryption      = true
  enable_compliance_checks   = true

  tags = {
    team        = "security"
    cost_center = "hackathon"
  }
}

output "compliance_report" {
  value = module.zero_trust.compliance_report
}

output "compliance_summary" {
  value = module.zero_trust.compliance_summary
}
