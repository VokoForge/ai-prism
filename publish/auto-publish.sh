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

    # 微信公众号
    echo "🔄 同步到微信公众号..."
    wechatsync sync publish/article11/wechat/openclaw-wechat.md \
        -p wechat \
        --title "248K Star！黄仁勋说它是'下一个Linux'，60天刷新GitHub纪录！" \
        --cover article11/images/cover.png \
        --schedule "$DATE $TIME" \
        || echo "⚠️ 微信公众号同步失败"

    # 知乎
    echo "🔄 同步到知乎..."
    wechatsync sync publish/article11/zhihu/openclaw-zhihu.md \
        -p zhihu \
        --title "为什么OpenClaw能在60天内拿下24万Star？深度解析开源AI助手的现象级爆发" \
        --topics "OpenClaw,AI助手,开源项目,GitHub Trending,终端工具,Rust,黄仁勋" \
        --schedule "$DATE $TIME" \
        || echo "⚠️ 知乎同步失败"

    # 掘金
    echo "🔄 同步到掘金..."
    wechatsync sync publish/article11/juejin/openclaw-juejin.md \
        -p juejin \
        --title "开源AI助手OpenClaw：248K Star的终端革命，从安装到实战" \
        --tags "OpenClaw,AI,开源,CLI,Rust,效率工具" \
        --schedule "$DATE $TIME" \
        || echo "⚠️ 掘金同步失败"

    # 微博
    echo "🔄 同步到微博..."
    wechatsync sync publish/article11/weibo/openclaw-weibo.md \
        -p weibo \
        --schedule "$DATE $TIME" \
        || echo "⚠️ 微博同步失败"

    # 头条
    echo "🔄 同步到头条..."
    wechatsync sync publish/article11/toutiao/openclaw-toutiao.md \
        -p toutiao \
        --title "炸裂！60天24万星，这个开源AI助手让黄仁勋都坐不住了" \
        --schedule "$DATE $TIME" \
        || echo "⚠️ 头条同步失败"

    # CSDN
    echo "🔄 同步到CSDN..."
    wechatsync sync publish/article11/csdn/openclaw-csdn.md \
        -p csdn \
        --title "OpenClaw深度解析：248K Star的开源AI终端助手，Rust性能实测" \
        --tags "OpenClaw,AI助手,开源,CLI,Rust,终端工具" \
        --schedule "$DATE $TIME" \
        || echo "⚠️ CSDN同步失败"
}

# 文章2: System Prompts Leaks
publish_article15() {
    echo ""
    echo "📢 发布文章2: System Prompts Leaks (20K Star)"
    echo "------------------------------------------"

    # 微信公众号
    echo "🔄 同步到微信公众号..."
    wechatsync sync publish/article15/wechat/prompts-leak-wechat.md \
        -p wechat \
        --title "20K Star！撕开AI的遮羞布，所有大模型的'底层剧本'全泄露！" \
        --cover article15/images/cover.png \
        --schedule "$DATE $TIME" \
        || echo "⚠️ 微信公众号同步失败"

    # 知乎
    echo "🔄 同步到知乎..."
    wechatsync sync publish/article15/zhihu/prompts-leak-zhihu.md \
        -p zhihu \
        --title "大模型的'人格'全是演出来的？System Prompts泄露事件深度解析" \
        --topics "AI安全,提示词工程,ChatGPT,Claude,大模型,系统提示词,AI透明化" \
        --schedule "$DATE $TIME" \
        || echo "⚠️ 知乎同步失败"

    # 掘金
    echo "🔄 同步到掘金..."
    wechatsync sync publish/article15/juejin/prompts-leak-juejin.md \
        -p juejin \
        --title "系统提示词泄露全解析：GPT-5、Claude的'灵魂'只是一段文本" \
        --tags "AI安全,Prompt,ChatGPT,Claude,大模型,开源" \
        --schedule "$DATE $TIME" \
        || echo "⚠️ 掘金同步失败"

    # 微博
    echo "🔄 同步到微博..."
    wechatsync sync publish/article15/weibo/prompts-leak-weibo.md \
        -p weibo \
        --schedule "$DATE $TIME" \
        || echo "⚠️ 微博同步失败"

    # 头条
    echo "🔄 同步到头条..."
    wechatsync sync publish/article15/toutiao/prompts-leak-toutiao.md \
        -p toutiao \
        --title "惊天泄露！GitHub 20K Star项目曝光：所有大模型的'灵魂'只是一段文本" \
        --schedule "$DATE $TIME" \
        || echo "⚠️ 头条同步失败"

    # CSDN
    echo "🔄 同步到CSDN..."
    wechatsync sync publish/article15/csdn/prompts-leak-csdn.md \
        -p csdn \
        --title "系统提示词泄露技术分析：GPT-5、Claude底层逻辑全曝光" \
        --tags "AI安全,提示词,ChatGPT,Claude,大模型,系统提示词" \
        --schedule "$DATE $TIME" \
        || echo "⚠️ CSDN同步失败"
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
echo "   □ 检查话题标签是否正确"
echo "   □ 首小时内积极回复评论"
echo ""
