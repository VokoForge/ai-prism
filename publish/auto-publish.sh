#!/bin/bash
# 自动发布脚本 - Wechatsync 多平台同步
# 使用方法: ./auto-publish.sh [article11|article15|all]

set -e

ARTICLE=${1:-all}
DATE=$(date +%Y-%m-%d)
TIME="09:00"

echo "=========================================="
echo "🚀 GitHub Trending 文章自动发布脚本"
echo "日期: $DATE $TIME"
echo "=========================================="

# 检查 wechatsync 是否安装
if ! command -v wechatsync &> /dev/null; then
    echo "❌ wechatsync 未安装，正在安装..."
    npm install -g @wechatsync/cli
fi

# 文章1: OpenClaw
publish_article11() {
    echo ""
    echo "📢 发布文章1: OpenClaw (248K Star)"
    echo "------------------------------------------"

    # 微信公众号 + 知乎 + 掘金 + 微博 + 头条 + CSDN (wechatsync只支持这些参数)
    echo "🔄 同步到各平台..."
    wechatsync sync publish/article11/wechat/openclaw-wechat.md \
        -p "wechat,zhihu,juejin,weibo,toutiao,csdn" \
        --title "248K Star！黄仁勋说它是'下一个Linux'，60天刷新GitHub纪录！" \
        --cover article11/images/cover.png \
        || echo "⚠️ 同步失败，请检查浏览器插件是否已连接"
}

# 文章2: System Prompts Leaks
publish_article15() {
    echo ""
    echo "📢 发布文章2: System Prompts Leaks (20K Star)"
    echo "------------------------------------------"

    # 微信公众号 + 知乎 + 掘金 + 微博 + 头条 + CSDN
    echo "🔄 同步到各平台..."
    wechatsync sync publish/article15/wechat/prompts-leak-wechat.md \
        -p "wechat,zhihu,juejin,weibo,toutiao,csdn" \
        --title "20K Star！撕开AI的遮羞布，所有大模型的'底层剧本'全泄露！" \
        --cover article15/images/cover.png \
        || echo "⚠️ 同步失败，请检查浏览器插件是否已连接"
}

# 主逻辑
case $ARTICLE in
    article11)
        publish_article11
        ;;
    article15)
        publish_article15
        ;;
    all)
        publish_article11
        publish_article15
        ;;
    *)
        echo "用法: ./auto-publish.sh [article11|article15|all]"
        exit 1
        ;;
esac

echo ""
echo "=========================================="
echo "✅ 发布任务已提交！"
echo "=========================================="
echo ""
echo "📋 发布后检查清单:"
echo "   □ 检查各平台草稿箱确认文章已入库"
echo "   □ 确认封面图显示正常"
echo "   □ 手动添加话题标签（各平台要求不同）"
echo "   □ 首小时内积极回复评论"
echo ""
echo "⚠️  注意: Wechatsync 依赖浏览器插件，请确保:"
echo "   1. Chrome/Edge 已安装 Wechatsync 扩展"
echo "   2. 已在浏览器中登录各平台账号"
echo "   3. 插件处于连接状态"
echo ""
