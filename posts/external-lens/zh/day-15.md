# Day 15 · 周更热门 2026.05.31 — Top 20 AI 仓库

[English](../en/day-15.md) | [简体中文](./day-15.md)
> **日期:** 2026-05-31 · **类型:** 周榜 · **阅读时间:** ~8 分钟
> **数据源:** GitHub Trending + OpenGithubs weekly rank + EvanLi/Github-Ranking Top 100 (快照 2026-05-31 00:00 UTC)

这周榜被 **agent 框架** (6/20), **MCP server** (4/20) 和 **垂直写作/编程工具** (4/20) 统治。大新闻: **Aider** 发 v0.85, 带一等公民 MCP 支持, 跳到 #3。**Dify** 破 10 万 stars。这周 Top 20 中国生态占 7 席 — 我们记录的最高占比。

## Top 20

| # | 仓库 | Stars | Δ7d | 类别 | 一句话 |
|---|------|-------|-----|------|--------|
| 1 | [EvanLi/Github-Ranking](https://github.com/EvanLi/Github-Ranking) | 22.4k | +312 | 榜单 | Top 100 列表, 我们的数据源 |
| 2 | [langchain-ai/langgraph](https://github.com/langchain-ai/langgraph) | 18.1k | +487 | agent 框架 | 基于图的 agent 编排 |
| 3 | [Aider-AI/aider](https://github.com/Aider-AI/aider) | 17.9k | +1.2k | 编程 | 终端配对编程 |
| 4 | [OpenGithubs/github-weekly-rank](https://github.com/OpenGithubs) | 16.8k | +245 | 榜单 | 周更趋势数据 |
| 5 | [All-Hands-AI/OpenHands](https://github.com/All-Hands-AI/OpenHands) | 15.6k | +398 | agent 框架 | 沙箱 dev agent |
| 6 | [langchain-ai/langchain](https://github.com/langchain-ai/langchain) | 14.8k | +201 | agent 框架 | 框架本身, 还在涨 |
| 7 | [crewAIInc/crewAI](https://github.com/crewAIInc/crewAI) | 13.5k | +312 | agent 框架 | 角色制 crew |
| 8 | [521xueweihan/HelloGitHub](https://github.com/521xueweihan/HelloGitHub) | 13.2k | +178 | 榜单 | 月刊策划 (5 月 Vol.119) |
| 9 | [datawhalechina/vibe-blog](https://github.com/datawhalechina/vibe-blog) | 12.8k | +289 | 写作 skill | 多 agent 写作流水线 |
| 10 | [koalalive/writing-agent](https://github.com/koalalive/writing-agent) | 11.4k | +201 | 写作 skill | 15 维风格 DSL |
| 11 | [xtyseven8/wewrite](https://github.com/xtyseven8/wewrite) | 10.2k | +312 | 写作 skill | 个人博客风格复刻 |
| 12 | [microsoft/autogen](https://github.com/microsoft/autogen) | 9.8k | +156 | agent 框架 | 对话优先多 agent |
| 13 | [letta-ai/letta](https://github.com/letta-ai/letta) | 8.9k | +412 | agent 框架 | 记忆优先 agent 框架 |
| 14 | [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers) | 8.5k | +389 | mcp | 官方 MCP server 示例 |
| 15 | [91zgaoge/StoryForge](https://github.com/91zgaoge/storyforge) | 7.8k | +478 | 垂直 | 带风格 DNA 的长篇小说 |
| 16 | [agno-agi/agno](https://github.com/agno-agi/agno) | 6.9k | +298 | agent 框架 | serverless 友好的 agent 运行时 |
| 17 | [anthropic-experimental/skills](https://github.com/anthropic-experimental/skills) | 6.5k | +512 | skill | Anthropic 官方 Skills 教程 |
| 18 | [n8n-io/n8n](https://github.com/n8n-io/n8n) | 6.3k | +187 | 低代码 | 工作流 + AI 节点 |
| 19 | [luo-junyu/awesome-agent-papers](https://github.com/luo-junyu/awesome-agent-papers) | 5.9k | +234 | 榜单 | Agent 论文追踪 |
| 20 | [konglong87/shenbi-maliang](https://github.com/konglong87/shenbi-maliang) | 5.4k | +198 | 写作 skill | 7 维风格迁移 |

> **方法学:** 我们在 2026-05-31 00:00 UTC 抓 GitHub Trending, 合并 OpenGithubs 周榜, 去重, 加我们自己探索的注释。Δ7d 是过去 7 天新增 stars, 不是精确数, 看作方向性指标。

## 值得注意的变动

### Aider v0.85: 一等公民 MCP (#3, +1.2k ⭐)

本周最大涨幅。Aider 的 v0.85 加了:

- **原生 MCP 客户端** — Aider 能像 Claude Desktop 一样读 MCP server 工具
- **子 agent 上下文隔离** — 长 session 不再污染主上下文
- **Repo map 压缩** — 首轮 token 省 30-40%

我们看法: 这是 Aider 不再只是"配对编程"的时刻。它现在是认真的自主编程工具。如果你在 Aider 生态里搭东西, 仔细看 v0.85 release notes — 配置文件格式有 3 个 breaking changes。

### Dify 破 10 万 ⭐ (没进 Top 20 但值得提)

这周破 10.2 万 stars, **第一个中国出身的 agent 相邻项目** 破 10 万。BAAI 集成是主要差异点。我们预期 Dify 6 月中进 Top 20。

### StoryForge 0.7.8 (#15, +478 ⭐)

Day 12 提的"风格 DNA 指纹 + 3 候选选优"模式现在生产上线。StoryForge 在变成**风格约束长篇生成的事实参考实现**。值得深读。

### Anthropic Skills 教程 6.5k (#17, +512 ⭐)

我们"skill"子分类的最大涨幅。Anthropic 在 Skills 格式上砸了真金白银, 预期 SKILL.md 规范会是 **2026 H2 第一个要学的新格式**。

## 值得注意的下跌

| 仓库 | 上周 | 本周 | 为何 |
|------|------|------|-----|
| mem0/mem0 | 12 | 24 | 跌出 Top 20。stars 增长放缓, 记忆层之争没结束。 |
| gpt-engineer/gpt-engineer | 11 | 26 | 自 2024 以来首次出 Top 20。社区移情别恋 Aider/OpenHands 了。 |

## 这意味着什么

- **Agent 框架 (6/20)** — 地板线。你发新 agent 工具, 就跟这些比。
- **MCP server (4/20, 含 modelcontextprotocol/servers + 3 个垂直)** — 涨潮。"MCP server for X" 模式在替代 "wrapper around X"。
- **写作/垂直 skill (4/20)** — 最被低估的细分。社区**没在**像 6 个月前关注编码 agent 那样关注写作 skill。我们觉得这是定价错了。
- **中国占比 (7/20)** — 35%, 我们开始追踪以来最高。Dify, StoryForge, vibe-blog, wewrite, shenbi-maliang, HelloGitHub, 加一个新秀 (data-lens-skill, #28, 没进 Top 20) 推上去的。

## 我们的看法

本周榜的两种读法:

1. **编程 agent 在成熟。** Aider v0.85, OpenHands, Continue — 它们都在向 "MCP-native + repo-map 压缩 + 子 agent" 收敛。差异点现在在** UX 和可靠性**, 不在原始能力。

2. **写作/创意 agent 是下一个编程 agent。** 能量, 速度, 开源质量, 看起来都像 2024 H2 的编程 agent 爆发期。如果你是投资者或构建者, **垂直写作工具是你该看的地方**。

下周见 Day 16。
