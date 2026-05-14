#!/usr/bin/env bash
set -euo pipefail

# Integration test: Full stack terraform apply from zero
# Validates all modules deploy, compliance outputs work, and toggles function.
#
# Prerequisites:
#   - az login completed
#   - terraform >= 1.5
#   - Repo root as working directory
#
# Usage:
#   chmod +x tests/integration.sh
#   ./tests/integration.sh

PROJECT="inttest"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

pass() { echo -e "${GREEN}✅ PASS${NC}: $1"; }
fail() { echo -e "${RED}❌ FAIL${NC}: $1"; exit 1; }

echo "=== Integration Test: Zero-Trust Compliance Pack ==="
echo ""

# ── Test 1: terraform init ──
echo "--- Test 1: terraform init ---"
terraform init -input=false || fail "terraform init"
pass "terraform init"

# ── Test 2: terraform validate ──
echo "--- Test 2: terraform validate ---"
terraform validate || fail "terraform validate"
pass "terraform validate"

# ── Test 3: terraform fmt ──
echo "--- Test 3: terraform fmt check ---"
terraform fmt -check -recursive || fail "terraform fmt — run 'terraform fmt -recursive' to fix"
pass "terraform fmt"

# ── Test 4: terraform plan (all modules enabled) ──
echo "--- Test 4: terraform plan (all modules) ---"
terraform plan \
  -var="project_name=${PROJECT}" \
  -input=false \
  -detailed-exitcode \
  -out=tfplan 2>&1 || {
    EXIT=$?
    if [ "$EXIT" -eq 2 ]; then
      pass "terraform plan — changes detected (expected)"
    else
      fail "terraform plan"
    fi
  }

# ── Test 5: terraform apply ──
echo "--- Test 5: terraform apply ---"
terraform apply -auto-approve tfplan || fail "terraform apply"
pass "terraform apply"

# ── Test 6: compliance_report output ──
echo "--- Test 6: compliance_report output ---"
REPORT=$(terraform output -json compliance_report 2>/dev/null)
if [ -z "$REPORT" ] || [ "$REPORT" = "{}" ]; then
  fail "compliance_report is empty"
fi

# Check we have at least 5 SOC2 controls
CONTROL_COUNT=$(echo "$REPORT" | jq 'keys | length')
if [ "$CONTROL_COUNT" -lt 5 ]; then
  fail "compliance_report has $CONTROL_COUNT controls, expected >= 5"
fi
pass "compliance_report — $CONTROL_COUNT controls"

# ── Test 7: compliance_summary output ──
echo "--- Test 7: compliance_summary output ---"
SUMMARY=$(terraform output -json compliance_summary 2>/dev/null)
TOTAL=$(echo "$SUMMARY" | jq '.total_controls')
if [ "$TOTAL" -lt 5 ]; then
  fail "compliance_summary total_controls = $TOTAL, expected >= 5"
fi
pass "compliance_summary — $TOTAL controls"

# ── Test 8: Module toggle — disable kms ──
echo "--- Test 8: Module toggle (disable kms_encryption) ---"
terraform plan \
  -var="project_name=${PROJECT}" \
  -var="enable_kms_encryption=false" \
  -input=false \
  -detailed-exitcode 2>&1 || {
    EXIT=$?
    if [ "$EXIT" -eq 2 ]; then
      pass "toggle plan — kms disabled, changes detected"
    else
      fail "toggle plan"
    fi
  }

# ── Test 9: No wildcards in modules ──
echo "--- Test 9: No wildcard permissions ---"
if grep -rq '"\\*"' modules/ --include='*.tf'; then
  fail "Wildcard permissions found in modules/"
fi
pass "zero wildcards in all modules"

# ── Test 10: All modules have compliance_status output ──
echo "--- Test 10: compliance_status outputs ---"
for mod in modules/*/; do
  name=$(basename "$mod")
  if ! grep -q 'compliance_status' "$mod/outputs.tf" 2>/dev/null; then
    fail "$name missing compliance_status output"
  fi
done
pass "all modules have compliance_status"

# ── Cleanup ──
echo ""
echo "--- Cleanup ---"
terraform destroy \
  -var="project_name=${PROJECT}" \
  -auto-approve || echo "⚠️ Destroy failed — manual cleanup may be needed"

rm -f tfplan

echo ""
echo "=== All tests passed ==="
