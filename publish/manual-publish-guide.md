# 手动发布指南

由于 Wechatsync CLI 需要浏览器扩展配合，请在本地机器上按以下步骤操作。

---

## 第一步：安装 Wechatsync 扩展

1. 访问 https://www.wechatsync.com/#install
2. 安装 Chrome/Edge 扩展
3. 在扩展设置中启用 MCP 连接，复制 Token
4. 在各平台（知乎、掘金、微信公众号等）登录账号

---

## 第二步：设置环境变量

```bash
export WECHATSYNC_TOKEN="你的token"
```

---

## 第三步：执行发布命令

### 文章1：OpenClaw

```bash
cd github-trending-articles-2026

wechatsync sync publish/article11/wechat/openclaw-wechat.md \
    -p "wechat,zhihu,juejin,weibo,toutiao,csdn" \
    --title "248K Star！黄仁勋说它是'下一个Linux'，60天刷新GitHub纪录！" \
    --cover article11/images/cover.png
```

**各平台手动优化建议：**

| 平台 | 发布前调整 |
|------|-----------|
| 微信公众号 | 封面图用 `article11/images/cover.png`，话题标签添加 `#OpenClaw #AI助手 #开源 #GitHub #黄仁勋` |
| 知乎 | 标题可改为"为什么OpenClaw能在60天内拿下24万Star？"，添加话题"OpenClaw, AI助手, 开源项目" |
| 掘金 | 标题用"开源AI助手OpenClaw：248K Star的终端革命"，标签选"OpenClaw, AI, 开源, CLI, Rust" |
| 微博 | 精简为短文案 + 配图，话题 `#OpenClaw #AI助手 #开源 #黄仁勋` |
| 头条 | 标题用"炸裂！60天24万星，这个开源AI助手让黄仁勋都坐不住了" |
| CSDN | 标题用"OpenClaw深度解析：248K Star的开源AI终端助手"，标签"OpenClaw, AI助手, Rust" |

---

### 文章2：System Prompts Leaks

```bash
wechatsync sync publish/article15/wechat/prompts-leak-wechat.md \
    -p "wechat,zhihu,juejin,weibo,toutiao,csdn" \
    --title "20K Star！撕开AI的遮羞布，所有大模型的'底层剧本'全泄露！" \
    --cover article15/images/cover.png
```

**各平台手动优化建议：**

| 平台 | 发布前调整 |
|------|-----------|
| 微信公众号 | 封面图用 `article15/images/cover.png`，话题标签 `#AI安全 #提示词泄露 #ChatGPT #Claude` |
| 知乎 | 标题"大模型的'人格'全是演出来的？System Prompts泄露事件深度解析"，话题"AI安全, 提示词工程, ChatGPT" |
| 掘金 | 标题"系统提示词泄露全解析：GPT-5、Claude的'灵魂'只是一段文本"，标签"AI安全, Prompt, ChatGPT, Claude" |
| 微博 | 短文案 + 话题 `#AI安全 #提示词泄露 #ChatGPT #大模型` |
| 头条 | 标题"惊天泄露！GitHub 20K Star项目曝光：所有大模型的'灵魂'只是一段文本" |
| CSDN | 标题"系统提示词泄露技术分析：GPT-5、Claude底层逻辑全曝光"，标签"AI安全, 提示词, ChatGPT, Claude" |

---

## 第四步：发布后检查

- [ ] 检查各平台草稿箱，确认文章已入库
- [ ] 确认封面图显示正常
- [ ] 手动添加话题标签（各平台界面操作）
- [ ] 设置定时发布（如需非立即发布）
- [ ] 首小时内积极回复评论，提升推荐权重

---

## 备选方案：纯手动复制粘贴

如果 Wechatsync 扩展安装失败，可直接复制各平台的 `.md` 文件内容手动发布：

- `publish/article11/wechat/openclaw-wechat.md` → 微信公众号
- `publish/article11/zhihu/openclaw-zhihu.md` → 知乎
- `publish/article11/juejin/openclaw-juejin.md` → 掘金
- `publish/article11/weibo/openclaw-weibo.md` → 微博
- `publish/article11/toutiao/openclaw-toutiao.md` → 头条
- `publish/article11/csdn/openclaw-csdn.md` → CSDN

文章2同理，对应 `publish/article15/` 目录下的文件。
