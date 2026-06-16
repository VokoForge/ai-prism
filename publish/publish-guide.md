# 发布操作指南

## 1. GitHub 提交（已完成本地提交）

本地仓库已初始化并提交，包含 95 个文件。需要您手动推送到远程：

```bash
# 在您的本地机器上执行：
git clone https://github.com/VokoForge/ai-prism.git
cd ai-prism

# 或者如果您已有仓库：
git remote add origin https://github.com/VokoForge/ai-prism.git
git push -u origin main
```

**提交内容：**
- 20 篇完整文章（article01-20）
- 60 张 SVG 配图（20 封面 + 40 正文图）
- 14 个多平台适配版本（2篇 x 7平台）
- Wechatsync 同步配置

---

## 2. Wechatsync 定时发布配置

### 安装 Wechatsync CLI

```bash
npm install -g @wechatsync/cli
```

### 文章1：OpenClaw（今天 09:00 发布）

**微信公众号：**
```bash
wechatsync sync publish/article11/wechat/openclaw-wechat.md -p wechat --title "248K Star！黄仁勋说它是'下一个Linux'，60天刷新GitHub纪录！"
```

**知乎：**
```bash
wechatsync sync publish/article11/zhihu/openclaw-zhihu.md -p zhihu --title "为什么OpenClaw能在60天内拿下24万Star？深度解析开源AI助手的现象级爆发"
```

**掘金：**
```bash
wechatsync sync publish/article11/juejin/openclaw-juejin.md -p juejin --title "开源AI助手OpenClaw：248K Star的终端革命，从安装到实战" --tags "OpenClaw,AI,开源,CLI,Rust,效率工具"
```

**微博：**
```bash
wechatsync sync publish/article11/weibo/openclaw-weibo.md -p weibo
```

**头条：**
```bash
wechatsync sync publish/article11/toutiao/openclaw-toutiao.md -p toutiao --title "炸裂！60天24万星，这个开源AI助手让黄仁勋都坐不住了"
```

**CSDN：**
```bash
wechatsync sync publish/article11/csdn/openclaw-csdn.md -p csdn --title "OpenClaw深度解析：248K Star的开源AI终端助手，Rust性能实测" --tags "OpenClaw,AI助手,开源,CLI,Rust,终端工具"
```

---

### 文章2：System Prompts Leaks（今天 09:00 发布）

**微信公众号：**
```bash
wechatsync sync publish/article15/wechat/prompts-leak-wechat.md -p wechat --title "20K Star！撕开AI的遮羞布，所有大模型的'底层剧本'全泄露！"
```

**知乎：**
```bash
wechatsync sync publish/article15/zhihu/prompts-leak-zhihu.md -p zhihu --title "大模型的'人格'全是演出来的？System Prompts泄露事件深度解析"
```

**掘金：**
```bash
wechatsync sync publish/article15/juejin/prompts-leak-juejin.md -p juejin --title "系统提示词泄露全解析：GPT-5、Claude的'灵魂'只是一段文本" --tags "AI安全,Prompt,ChatGPT,Claude,大模型,开源"
```

**微博：**
```bash
wechatsync sync publish/article15/weibo/prompts-leak-weibo.md -p weibo
```

**头条：**
```bash
wechatsync sync publish/article15/toutiao/prompts-leak-toutiao.md -p toutiao --title "惊天泄露！GitHub 20K Star项目曝光：所有大模型的'灵魂'只是一段文本"
```

**CSDN：**
```bash
wechatsync sync publish/article15/csdn/prompts-leak-csdn.md -p csdn --title "系统提示词泄露技术分析：GPT-5、Claude底层逻辑全曝光" --tags "AI安全,提示词,ChatGPT,Claude,大模型,系统提示词"
```

---

## 3. 封面图选择

### 文章1：OpenClaw

| 平台 | 封面图建议 |
|------|-----------|
| 微信公众号 | 使用 article11/images/cover.svg（AI大脑突破星标榜） |
| 知乎 | 同上，知乎支持 SVG 直接显示 |
| 掘金 | 同上 |
| 微博 | 建议将 SVG 转为 PNG（微博不支持 SVG），或使用文章内截图 |
| 头条 | 建议将 SVG 转为 PNG，或使用项目 GitHub 页面截图 |
| CSDN | 同上 |

**SVG 转 PNG 命令：**
```bash
# 使用 ImageMagick 或在线工具转换
convert article11/images/cover.svg article11-cover.png
```

### 文章2：System Prompts Leaks

| 平台 | 封面图建议 |
|------|-----------|
| 微信公众号 | 使用 article15/images/cover.svg（撕开幕布露出提示词） |
| 知乎 | 同上 |
| 掘金 | 同上 |
| 微博 | 建议转为 PNG，或使用泄露提示词的截图 |
| 头条 | 建议转为 PNG |
| CSDN | 同上 |

---

## 4. 话题标签汇总

### 文章1：OpenClaw

| 平台 | 话题标签 |
|------|---------|
| 微信公众号 | #OpenClaw #AI助手 #开源 #GitHub #黄仁勋 #Linux #Rust #SamAltman |
| 知乎 | OpenClaw, AI助手, 开源项目, GitHub Trending, 终端工具, Rust, 黄仁勋 |
| 掘金 | OpenClaw, AI, 开源, CLI, Rust, 效率工具, 终端革命 |
| 微博 | #OpenClaw #AI助手 #开源 #GitHub #黄仁勋 #SamAltman #科技 #Linux |
| 头条 | OpenClaw, AI助手, 开源, GitHub, 黄仁勋, 科技创新, Rust |
| CSDN | OpenClaw, AI助手, 开源, CLI, Rust, 终端工具, 性能优化 |

### 文章2：System Prompts Leaks

| 平台 | 话题标签 |
|------|---------|
| 微信公众号 | #AI安全 #提示词泄露 #ChatGPT #Claude #大模型 #GitHub #GPT5 #透明化 |
| 知乎 | AI安全, 提示词工程, ChatGPT, Claude, 大模型, 系统提示词, AI透明化 |
| 掘金 | AI安全, Prompt, ChatGPT, Claude, 大模型, 开源, 提示词注入 |
| 微博 | #AI安全 #提示词泄露 #ChatGPT #Claude #大模型 #GitHub #科技 #AI透明化 |
| 头条 | AI安全, 提示词泄露, ChatGPT, Claude, 大模型, 科技创新, GPT5 |
| CSDN | AI安全, 提示词, ChatGPT, Claude, 大模型, 系统提示词, 安全研究 |

---

## 5. 发布后首小时运营SOP

**0-15分钟：**
- [ ] 自己先阅读一遍，检查格式错误
- [ ] 分享到 3-5 个相关技术社群（AI交流群、开源社区、Rust群等）
- [ ] 在评论区先发一条引导性评论（"你觉得 OpenClaw 能超越 Linux 吗？" / "你之前猜到大模型的'人格'是演出来的吗？"）

**15-30分钟：**
- [ ] 回复前 3 条评论（算法奖励早期互动）
- [ ] 观察阅读量增长趋势

**30-60分钟：**
- [ ] 继续回复评论，保持互动
- [ ] 如果数据好，准备第二波分享到更多社群

---

## 6. 注意事项

1. **Wechatsync 需要浏览器登录态**：首次使用前，确保已在浏览器中登录各平台账号
2. **封面图格式**：微博、头条、CSDN 等平台可能不支持 SVG，需提前转为 PNG
3. **定时发布**：Wechatsync 默认草稿模式，建议先手动发布一篇测试，确认无误后再批量同步
4. **发布时间**：今天 09:00 已过，建议改为明天 09:00 或今天下午 14:00
