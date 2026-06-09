#!/usr/bin/env bash
# scripts/rex_review.sh
# 5 条 checklist 自动校验
set -euo pipefail

FAIL=0

if [[ $# -eq 0 ]]; then
  set -- posts/*.md docs/*.md
fi

for f in "$@"; do
  echo "[review] $f"

  # 1. 中英对照 (只对 posts/* 强制)
  if [[ "$f" == posts/* ]]; then
    if ! grep -qE '## 中文版' "$f" || ! grep -qE '## English Version' "$f"; then
      echo "  ✗ Missing bilingual sections (posts/ required)"
      FAIL=1
    fi
  fi

  # 2. 脱敏
  if grep -E 'hawkingye|github_pat_[0-9A-Z]{20,}' "$f" >/dev/null 2>&1; then
    echo "  ✗ Found token / personal ref"
    FAIL=1
  fi
  # mindapex-crop 只在"不公开"上下文中允许
  if grep -E 'mindapex-crop' "$f" >/dev/null 2>&1; then
    if ! grep -E 'mindapex-crop' "$f" | grep -qE '(不公开|闭源|不开源|内部)'; then
      echo "  ✗ mindapex-crop ref not in 'closed-source' context"
      FAIL=1
    fi
  fi

  # 3. 字数 600-1500 (posts/) 或 100+ (docs/)
  WORDS=$(wc -w < "$f" | tr -d ' ')
  if [[ "$f" == posts/* ]]; then
    if [[ "$WORDS" -lt 600 || "$WORDS" -gt 4000 ]]; then
      echo "  ⚠ posts/ word count $WORDS outside 600-4000 range"
    fi
  else
    if [[ "$WORDS" -lt 100 ]]; then
      echo "  ⚠ docs/ word count $WORDS < 100"
    fi
  fi

  # 4. SVG 引用
  for img in $(grep -oE '!\[[^]]*\]\([^)]+\)' "$f" | grep -oE '\(.*\)' | tr -d '()'); do
    if [[ "$img" =~ ^https?:// ]]; then
      echo "  ✗ External image ref: $img"
      FAIL=1
    fi
    if [[ "$img" =~ \.png$ ]] || [[ "$img" =~ \.jpg$ ]]; then
      echo "  ⚠ Non-SVG image: $img (SVG preferred)"
    fi
  done

done

if [[ $FAIL -ne 0 ]]; then
  echo "[review] FAIL"
  exit 1
fi
echo "[review] PASS"
