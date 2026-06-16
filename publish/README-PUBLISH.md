# 自动发布指南

## 当前环境限制说明

Wechatsync CLI 在服务器环境中**无法直接运行**，因为它需要：
1. Chrome/Edge 浏览器扩展（必须在本地浏览器安装）
2. 浏览器中已登录各平台账号
3. 扩展与 CLI 的实时通信

---

## 方案A：本地浏览器自动化（推荐）

使用 Playwright 自动控制浏览器完成发布。

### 安装依赖

```bash
cd github-trending-articles-2026/publish
npm install playwright
npx playwright install chromium
```

### 运行发布脚本

```bash
node auto-publish-browser.js
```

### 首次使用流程

1. **脚本会自动打开浏览器窗口**
2. **手动登录各平台**（扫码或密码登录）
3. **脚本自动填写**文章标题、正文、封面图、话题标签
4. **保存为草稿**，您检查无误后手动点击发布

### 脚本功能

- ✅ 自动填写标题和正文
- ✅ 自动上传封面图（PNG格式）
- ✅ 自动添加话题标签
- ✅ 支持6大平台：微信公众号、知乎、掘金、微博、头条、CSDN
- ✅ 保存为草稿模式（安全，不会误发）

---

## 方案B：Wechatsync 官方扩展（需本地安装）

### 安装步骤

1. 访问 https://www.wechatsync.com/#install
2. 安装 Chrome/Edge 扩展
3. 在扩展设置中启用「同步桥接」
4. 复制 MCP Token
5. 在浏览器中登录各平台账号

### 使用命令

```bash
# 设置 Token
export WECHATSYNC_TOKEN="7f7393c4-11af-45c2-aa2f-ad6f8e6e3202"

# 发布文章1
cd github-trending-articles-2026
wechatsync sync publish/article11/wechat/openclaw-wechat.md \
    -p "wechat,zhihu,juejin,weibo,toutiao,csdn" \
    --title "248K Star！黄仁勋说它是'下一个Linux'，60天刷新GitHub纪录！" \
    --cover article11/images/cover.png

# 发布文章2
wechatsync sync publish/article15/wechat/prompts-leak-wechat.md \
    -p "wechat,zhihu,juejin,weibo,toutiao,csdn" \
    --title "20K Star！撕开AI的遮羞布，所有大模型的'底层剧本'全泄露！" \
    --cover article15/images/cover.png
```

---

## 方案C：纯手动复制粘贴

直接复制各平台适配的 Markdown 文件内容：

| 平台 | 文章1路径 | 文章2路径 |
|------|----------|----------|
| 微信公众号 | `publish/article11/wechat/openclaw-wechat.md` | `publish/article15/wechat/prompts-leak-wechat.md` |
| 知乎 | `publish/article11/zhihu/openclaw-zhihu.md` | `publish/article15/zhihu/prompts-leak-zhihu.md` |
| 掘金 | `publish/article11/juejin/openclaw-juejin.md` | `publish/article15/juejin/prompts-leak-juejin.md` |
| 微博 | `publish/article11/weibo/openclaw-weibo.md` | `publish/article15/weibo/prompts-leak-weibo.md` |
| 头条 | `publish/article11/toutiao/openclaw-toutiao.md` | `publish/article15/toutiao/prompts-leak-toutiao.md` |
| CSDN | `publish/article11/csdn/openclaw-csdn.md` | `publish/article15/csdn/prompts-leak-csdn.md` |

封面图位置：
- 文章1：`article11/images/cover.png`
- 文章2：`article15/images/cover.png`

---

## 话题标签速查

### 文章1：OpenClaw
- **微信公众号**：#OpenClaw #AI助手 #开源 #GitHub #黄仁勋 #Rust
- **知乎**：OpenClaw, AI助手, 开源项目, GitHub Trending, 终端工具, Rust
- **掘金**：OpenClaw, AI, 开源, CLI, Rust, 效率工具
- **微博**：#OpenClaw #AI助手 #开源 #GitHub #黄仁勋
- **头条**：OpenClaw, AI助手, 开源, GitHub, 黄仁勋, 科技创新
- **CSDN**：OpenClaw, AI助手, 开源, CLI, Rust, 终端工具

### 文章2：System Prompts Leaks
- **微信公众号**：#AI安全 #提示词泄露 #ChatGPT #Claude #大模型 #GPT5
- **知乎**：AI安全, 提示词工程, ChatGPT, Claude, 大模型, 系统提示词
- **掘金**：AI安全, Prompt, ChatGPT, Claude, 大模型, 开源
- **微博**：#AI安全 #提示词泄露 #ChatGPT #Claude #大模型
- **头条**：AI安全, 提示词泄露, ChatGPT, Claude, 大模型, 科技创新
- **CSDN**：AI安全, 提示词, ChatGPT, Claude, 大模型, 系统提示词

---

## 发布后检查清单

- [ ] 检查各平台草稿箱，确认文章已入库
- [ ] 确认封面图显示正常
- [ ] 检查话题标签是否正确
- [ ] 确认排版无错乱
- [ ] 首小时内积极回复评论，提升推荐权重
