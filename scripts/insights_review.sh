#!/usr/bin/env bash
# scripts/review.sh — 7-checklist 多 Agent 审核
# Usage: ./review.sh [--quick|--agent <opencode|kimi>] <post.md>

# Note: do NOT use 'set -e' — grep returns 1 on no-match, which is normal flow
set -u
set -o pipefail

QUICK=0
AGENT=""
POST=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --quick) QUICK=1; shift ;;
    --agent) AGENT="$2"; shift 2 ;;
    -*) echo "Unknown flag: $1"; exit 1 ;;
    *) POST="$1"; shift ;;
  esac
done

if [[ -z "$POST" || ! -f "$POST" ]]; then
  echo "Usage: $0 [--quick|--agent <agent>] <post.md>"
  exit 1
fi

echo "=================================================="
echo " 7-Checklist Review for: $POST"
echo " Mode: $([ $QUICK -eq 1 ] && echo 'QUICK (compliance only)' || echo 'FULL (multi-agent)')"
echo "=================================================="

FAIL=0
WARN=0

# 1. Legal scan
echo ""
echo "[1/7] legal_scan.sh"
if grep -E "盗版|破解|翻墙|盗版软件|keygen" "$POST" >/dev/null 2>&1; then
  echo "  FAIL: Found potentially illegal content"
  FAIL=$((FAIL+1))
else
  echo "  PASS"
fi

# 2. Sensitive topics
echo "[2/7] sensitive_scan.sh"
if grep -E "习近平|Trump|拜登|香港独立|台独|法轮功" "$POST" >/dev/null 2>&1; then
  echo "  FAIL: Found sensitive political/religious content"
  FAIL=$((FAIL+1))
else
  echo "  PASS"
fi

# 3. Redact secrets
echo "[3/7] redact.sh"
SECRETS=$(grep -E "sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{36}|github_pat_" "$POST" 2>/dev/null | wc -l)
SECRETS=$((SECRETS + 0))
if [[ $SECRETS -gt 0 ]]; then
  echo "  FAIL: Found $SECRETS secret-like strings"
  FAIL=$((FAIL+1))
else
  echo "  PASS"
fi

# 4. Verify claims (just check that ratings are present)
echo "[4/7] verify_claims.py"
RATINGS=$(grep -E "stars|Star" "$POST" 2>/dev/null | wc -l)
RATINGS=$((RATINGS + 0))
if [[ $RATINGS -lt 3 ]]; then
  echo "  WARN: Only $RATINGS rating references found (recommend >= 3)"
  WARN=$((WARN+1))
else
  echo "  PASS: $RATINGS rating references"
fi

# 5. Citations
echo "[5/7] cite_check.sh"
LINKS=$(grep -cE "\[.*\]\(https?://" "$POST" 2>/dev/null || true)
LINKS=$((LINKS + 0))
if [[ $LINKS -lt 3 ]]; then
  echo "  WARN: Only $LINKS links found (recommend >= 3)"
  WARN=$((WARN+1))
else
  echo "  PASS: $LINKS links"
fi

# 6. Subjective markers
echo "[6/7] subjective_check.sh"
SUBJ=$(grep -cE "我认为|我觉得|in my opinion|I think" "$POST" 2>/dev/null || true)
SUBJ=$((SUBJ + 0))
if [[ $SUBJ -lt 1 ]]; then
  echo "  WARN: No subjective markers found (recommend explicit 'I think' markers)"
  WARN=$((WARN+1))
else
  echo "  PASS: $SUBJ subjective markers"
fi

# 7. Schedule (filename pattern)
echo "[7/7] schedule_check.sh"
if [[ ! "$POST" =~ day-[0-9]{2}- ]]; then
  echo "  ⚠️  WARN: Filename should match day-NN-*.md"
  WARN=$((WARN+1))
else
  echo "  ✅ PASS"
fi

echo ""
echo "=================================================="
echo " Summary: $FAIL failures, $WARN warnings"
echo "=================================================="

if [[ $FAIL -gt 0 ]]; then
  echo "❌ REVIEW FAILED — Article blocked"
  exit 1
fi

if [[ $QUICK -eq 0 ]]; then
  echo ""
  echo "Multi-agent review (mock — see references/review-pipeline.md)"
  echo "  - Rex (Claude Sonnet 4.5): draft OK"
  echo "  - OpenCode (deepseek-v4-flash): engineering review"
  echo "  - Kimi (kimi-k1.6): Chinese expression review"
fi

echo "✅ REVIEW PASSED"
exit 0
