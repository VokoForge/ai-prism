#!/bin/bash
# Wechatsync 发布脚本 - 使用 MCP Token
# 使用方法: WECHATSYNC_TOKEN=xxx ./publish-with-token.sh

set -e

TOKEN=${WECHATSYNC_TOKEN:-"7f7393c4-11af-45c2-aa2f-ad6f8e6e3202"}

echo "=========================================="
echo "🚀 Wechatsync 自动发布脚本"
echo "Token: ${TOKEN:0:8}..."
echo "=========================================="

# 检查 wechatsync
if ! command -v wechatsync &> /dev/null; then
    echo "❌ 安装 wechatsync..."
    npm install -g @wechatsync/cli
fi

# 文章1: OpenClaw
echo ""
echo "📢 发布文章1: OpenClaw"
echo "------------------------------------------"
WECHATSYNC_TOKEN="$TOKEN" wechatsync sync \
    publish/article11/wechat/openclaw-wechat.md \
    -p "wechat,zhihu,juejin,weibo,toutiao,csdn" \
    --title "248K Star！黄仁勋说它是'下一个Linux'，60天刷新GitHub纪录！" \
    --cover article11/images/cover.png \
    || echo "⚠️ 文章1同步失败"

# 文章2: System Prompts Leaks
echo ""
echo "📢 发布文章2: System Prompts Leaks"
echo "------------------------------------------"
WECHATSYNC_TOKEN="$TOKEN" wechatsync sync \
    publish/article15/wechat/prompts-leak-wechat.md \
    -p "wechat,zhihu,juejin,weibo,toutiao,csdn" \
    --title "20K Star！撕开AI的遮羞布，所有大模型的'底层剧本'全泄露！" \
    --cover article15/images/cover.png \
    || echo "⚠️ 文章2同步失败"

echo ""
echo "=========================================="
echo "✅ 发布完成"
echo "=========================================="
