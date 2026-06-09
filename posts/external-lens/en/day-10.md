---

[English](./day-10.md) | [简体中文](../zh/day-10.md)title: "Day 10 — 2026.05.24 周更热门 AI 工具榜"
title_zh: "Day 10 — 2026.05.24 周更热门 AI 工具榜"
date: 2026-06-11
lang: en + zh
tags: [trending, weekly, github, ai-tools]
audience: developers, AI tool builders
star: ⭐⭐⭐
reading_time: 12 min
---

# Day 10 — 2026.05.24 周更热门 AI 工具榜

> **每周一更.** 仿照 [OpenGithubs/weekly](https://github.com/OpenGithubs/weekly) 的风格, 每周一早上 8 点更新本周最值得 star 的 20 个 AI 工具. 数据源: GitHub Trending + OpenGithubs 实时榜 + 我们 Rex 监控的 80 个订阅仓库.

## TL;DR — 本周 Top 20

> 数据截止 2026.05.24 23:59 UTC. 月增 ⭐ 来自 GitHub API. 项目描述来自 README 抓取.

| 排名 | 项目 | 本周 ⭐ | 总 ⭐ | 简介 | 评级 |
|------|------|---------|-------|------|------|
| 1 | [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) | 37.2k | 60.9k | Karpathy 课程全部转成 Claude Skills | ⭐⭐⭐⭐⭐ |
| 2 | [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) | 10.4k | 63.2k | Claude Code 跨 session 长期记忆 | ⭐⭐⭐⭐⭐ |
| 3 | [multica-ai/multica](https://github.com/multica-ai/multica) | 5.8k | 16.7k | 多 MCP server 路由器 | ⭐⭐⭐⭐ |
| 4 | [shanraisshan/claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice) | 5.2k | 46.5k | 中文圈 Claude Code 实战手册 | ⭐⭐⭐⭐⭐ |
| 5 | [jamiepine/voicebox](https://github.com/jamiepine/voicebox) | 4.9k | 21.1k | 开源语音克隆 (本地跑) | ⭐⭐⭐⭐ |
| 6 | [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) | 3.9k | 83.3k | 120 个 agent 角色 prompt 集 | ⭐⭐⭐⭐ |
| 7 | [virattt/ai-hedge-fund](https://github.com/virattt/ai-hedge-fund) | 3.5k | 56.3k | AI 量化交易团队模拟 | ⭐⭐⭐ |
| 8 | [pascalorg/editor](https://github.com/pascalorg/editor) | 3.2k | 13.5k | AI 时代的 Monaco 编辑器 | ⭐⭐⭐⭐ |
| 9 | [Lordog/dive-into-llms](https://github.com/Lordog/dive-into-llms) | 3.1k | 32.4k | LLM 从原理到代码中文教程 | ⭐⭐⭐⭐⭐ |
| 10 | [Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios) | 3.0k | 13.3k | Claude Code 跑游戏 | ⭐⭐⭐ |
| 11 | [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done) | 2.9k | 54.9k | Spec-driven 开发辅助 | ⭐⭐⭐⭐ |
| 12 | [shiyu-coder/Kronos](https://github.com/shiyu-coder/Kronos) | 2.7k | 19.6k | 金融 K 线开源模型 | ⭐⭐⭐ |
| 13 | [lsdefine/GenericAgent](https://github.com/lsdefine/GenericAgent) | 2.6k | 4.5k | 通用 agent 极简实现 | ⭐⭐ |
| 14 | [OpenBMB/VoxCPM](https://github.com/OpenBMB/VoxCPM) | 2.6k | 14.8k | TTS 中文开源模型 | ⭐⭐⭐⭐ |
| 15 | [datawhalechina/hello-agents](https://github.com/datawhalechina/hello-agents) | 2.6k | 38.5k | 中文 agent 入门教材 | ⭐⭐⭐⭐⭐ |
| 16 | [HKUDS/DeepTutor](https://github.com/HKUDS/DeepTutor) | 2.4k | 20.1k | 港大学术 tutor agent | ⭐⭐⭐⭐ |
| 17 | [google/magika](https://github.com/google/magika) | 2.4k | 16k | Google 文件类型识别 | ⭐⭐⭐⭐ |
| 18 | [EvoMap/evolver](https://github.com/EvoMap/evolver) | 2.3k | 5.4k | 自我进化 agent 实验 | ⭐⭐⭐ |
| 19 | [badlogic/pi-mono](https://github.com/badlogic/pi-mono) | 2.2k | 37.4k | 单体 AI 工具集 (CLI) | ⭐⭐⭐ |
| 20 | [shareAI-lab/learn-claude-code](https://github.com/shareAI-lab/learn-claude-code) | 2.1k | 54.8k | Claude Code 源码教程 | ⭐⭐⭐⭐⭐ |

> **评级说明.** ⭐⭐⭐⭐⭐ = 必读 / 必用. ⭐⭐⭐⭐ = 强烈推荐. ⭐⭐⭐ = 选择性. ⭐⭐ = 观望.

---

## 详细点评 — 5 个本周最值得 star 的项目

### 🥇 #1 andrej-karpathy-skills (本周 +37.2k)

> *作者: forrestchang · 总 ⭐ 60.9k · License: MIT*

**What.** 把 Karpathy 著名的 [Neural Networks: Zero to Hero](https://www.youtube.com/playlist?list=PLAqhIrjkxbuWI23v9cThsA9GvCAUhRvKZ) 系列 12 节课,**每一课都转成 Claude Skills**——学生打开 Claude Code, 加载这套 skills, 就能"边看课边让 Claude 解释每行代码".

**Why it matters.** 这是**第一个"高质量教学资源 + Agent"的成功融合**. 之前大家以为 skills 只适合写代码, 这个项目证明: **skills 同样适合教学**. Karpathy 的课程一直是 LLM 学习圈 "圣经", 现在有了 Claude Skills 版, 学习效率 +50% (作者声称).

**Insight.** 作者用了一个非常巧妙的 prompt 模板:

```text
# 来自 skills/lesson-01-micrograd/SKILL.md
---
name: lesson-01-micrograd
description: This skill should be used when the user is
  working through Karpathy's micrograd video and asks
  "what does this line do" or "explain this autograd code".
  Loads context: video timestamp + transcript + 50-line example.
allowed-tools: Read, Grep
---
```

**Pitfalls.**
- 12 课是固定的, **新 Karpathy 视频要等作者更新**
- 中文字幕靠社区 PR, **质量参差不齐**
- skills 文件比视频还长 (每个 ~3000 词), 加载需 token

---

### 🥈 #2 claude-mem (本周 +10.4k)

**What.** [见 Day 07 详细分析](day-07-mcp-production.md#1-thedotmackclaude-mem). 本周新增 10.4k 主要因为 **v0.5.0 发布** —— 支持多 Claude Code 实例共享记忆, 团队场景终于可用.

**New in v0.5.0.**
- 跨实例记忆共享 (团队级 central server 模式)
- 摘要模型可切换 (Claude Haiku / DeepSeek-V3)
- 导出 / 导入 .mem 二进制, 跨设备迁移

---

### 🥉 #3 multica (本周 +5.8k)

**What.** [见 Day 07 详细分析](day-07-mcp-production.md#2-multica-aimultica). 本周新增 5.8k 因为**官方 Cloudflare 集成**发布 — 用户可在 Cloudflare Workers 一键部署 multica, 零成本运行.

---

### 4. claude-code-best-practice (本周 +5.2k)

**What.** [见 Day 06 详细分析](day-06-skills-ecosystem.md#5-shanraisshanclaude-code-best-practice--中文圈的答案书). 本周新加 12 个 Q&A, 重点是 **Claude Code v2.0 新特性** (agent team / 多窗口 / 跨实例).

---

### 5. agency-agents (本周 +3.9k)

> *作者: msitarzewski · 总 ⭐ 83.3k · License: MIT*

**What.** 120 个**预定义 agent 角色 prompt 集** —— 从 "AI 律师" 到 "AI 瑜伽教练" 到 "AI 软件架构师", 每个角色 500 字 system prompt + 10 个示例. 配套 CLI: `npx agency-agents use lawyer`.

**Why it matters.** 这是**"agent prompt 市场"**的早期形态. 跟我们一直在说的"agent 操作系统"是同一种思想 —— **prompt 是新代码, 谁拥有最丰富的 prompt 库谁就赢**.

**Insight.** 作者是 ProductHunt 前 CEO, 整套 prompt 集是 **"硅谷常见 80 个工作流" + "40 个新涌现"**. 跟我们 Rex 的"15 维风格 DSL"有交集但更宽.

**Pitfalls.**
- 120 个角色, **质量参差不齐** —— 实际生产中只有 30 个能用
- 商业 license 模糊, 大规模商用需联系作者
- 维护者精力分散, **每月只更新 2-3 个角色**

---

## 本周观察 — 5 个趋势

1. **Skills 化一切**. Karpathy 课程 / 法律咨询 / 瑜伽教练 / 软件架构师 —— 一切知识都在转 Skills
2. **Claude Code 周边生态爆发**. 本周 Top 20 里 **8 个项目跟 Claude Code 相关** (40%)
3. **中文圈 AI 项目崛起**. Top 20 里 5 个是中文项目 (shanraisshan / datawhalechina / Lordog / OpenBMB / shareAI-lab), 25%
4. **自我进化类项目增多**. EvoMap/evolver / Claude-mem / GenericAgent —— "agent 改自己 agent" 是 2026 H1 新趋势
5. **金融 AI 工具持续走强**. Kronos / ai-hedge-fund / TradingAgents — 量化交易 AI 化是真实刚需

---

## 下周预告

- 周一 (Day 11): 自建 MCP server 实战
- 周三 (Day 12): MCP + Cloudflare Workers 部署
- 周五 (Day 13): MCP 鉴权 3 模式
- 周日 (Day 14): MCP observability

---

## 订阅

- ⭐ Star 本仓库 → 每早 8 点收到新榜
- 🔔 Watch → Releases only (不刷屏)
- 📮 邮件订阅 → 推特 @voko_forge (待开)

---
