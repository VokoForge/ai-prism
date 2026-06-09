#!/usr/bin/env bash
# scripts/rex_daily_post.sh
# Rex 自动起草一篇 day-NN 的草稿
set -euo pipefail

DAY="${1:-$(date -u +%d)}"
TOPIC="${2:-generic}"
OUT="posts/day-${DAY}-${TOPIC}.md"

echo "[rex] day=${DAY} topic=${TOPIC} -> ${OUT}"

# 1. 渲染模板
mkdir -p posts
if [[ ! -f references/templates/day-NN.md.tmpl ]]; then
  echo "[rex] template missing, abort" >&2; exit 1
fi
sed "s/{DAY}/${DAY}/g; s/{TOPIC}/${TOPIC}/g" \
  references/templates/day-NN.md.tmpl > "${OUT}"

# 2. 调 Brain 2 生成中英双版
if [[ -n "${BRAIN_API_KEY:-}" ]]; then
  python scripts/call_brain.py \
    --prompt "$(cat ${OUT})" \
    --brain=brain-2 \
    --output="${OUT}"
fi

echo "[rex] draft written to ${OUT}"
