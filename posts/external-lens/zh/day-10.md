# 这周GitHub上最火的5个AI项目

[English](../en/day-10.md) | [简体中文](./day-10.md)

这周我在 GitHub Trending 上蹲了 7 天，从 200+ 个项目里挑出 20 个。说实话，这周的信号很明确：**Skills 化一切**、**Claude Code 周边爆发**、**中文圈崛起**。

```mermaid
flowchart LR
    subgraph TOP5[本周 Top 5]
        K[karpathy-skills<br>+37.2k] --> CM[claude-mem<br>+10.4k]
        CM --> MU[multica<br>+5.8k]
        MU --> CB[claude-code-best-practice<br>+5.2k]
        CB --> VB[voicebox<br>+4.9k]
    end

    style K fill:#6366f1,stroke:#4f46e5,color:#fff
    style CM fill:#10b981,stroke:#059669,color:#fff
    style MU fill:#f59e0b,stroke:#d97706,color:#fff
    style CB fill:#ec4899,stroke:#be185d,color:#fff
    style VB fill:#8b5cf6,stroke:#7c3aed,color:#fff
```

---

## 🔥 01 forrestchang/andrej-karpathy-skills — 本周 +37.2k

Karpathy 的 AI 课程转成 Skills 格式。为什么这么火？因为"看视频学 AI"和"用 Skill 学 AI"是两种完全不同的体验——前者你被动看，后者你跟着做。

**之前：看视频 2 小时，记住 10% → 现在：用 Skill 跟着做 30 分钟，记住 60% → 这意味着：学习效率差 50% 以上。**

但说实话，37.2k 的增长有水分——它本质是一个课程索引，不是可运行的代码。很多人 star 了但不会真的用。相比之下，claude-mem 的 10.4k 增长更"实"。

---

## 🛠️ 02 thedotmack/claude-mem — 本周 +10.4k

Claude Code 的长期记忆。v0.5.0 支持跨实例共享。Day 07 我们详细拆过它——日调 50k 的生产级 MCP server。

**之前：每次新对话从零开始 → 现在：自动加载历史记忆 → 这意味着：AI 终于不用每次都失忆了。**

这才是本周最值得深读的项目——不是因为星最多，而是因为它解决了一个你一定会遇到的问题。

---

## 💡 03 multica-ai/multica — 本周 +5.8k

多 MCP 路由器，Cloudflare Workers 一键部署。Agent 时代的 nginx。

```mermaid
flowchart LR
    A[Agent] -->|12个MCP| M[multica 路由器]
    M -->|按需暴露| G[GitHub]
    M -->|按需暴露| S[Slack]
    M -->|按需暴露| N[Notion]
    M -->|按需暴露| O[其他9个]
    G --> M
    S --> M
    N --> M
    M -->|标准化返回| A

    style M fill:#6366f1,stroke:#4f46e5,color:#fff
```

**之前：12 个 MCP 全暴露，工具列表爆炸 → 现在：路由器按需暴露 → 这意味着：function calling 终于不会超限了。**

---

## 📋 完整 Top 20

| 排名 | 项目 | 本周 Stars | 总 Stars | 评级 |
|------|------|-----------|---------|------|
| 1 | forrestchang/andrej-karpathy-skills | 37.2k | 60.9k | 5/5 |
| 2 | thedotmack/claude-mem | 10.4k | 63.2k | 5/5 |
| 3 | multica-ai/multica | 5.8k | 16.7k | 4/5 |
| 4 | shanraisshan/claude-code-best-practice | 5.2k | 46.5k | 5/5 |
| 5 | jamiepine/voicebox | 4.9k | 21.1k | 4/5 |
| 6 | msitarzewski/agency-agents | 3.9k | 83.3k | 4/5 |
| 7 | virattt/ai-hedge-fund | 3.5k | 56.3k | 3/5 |
| 8 | pascalorg/editor | 3.2k | 13.5k | 4/5 |
| 9 | Lordog/dive-into-llms | 3.1k | 32.4k | 5/5 |
| 10 | Donchitos/Claude-Code-Game-Studios | 3.0k | 13.3k | 3/5 |
| 11 | gsd-build/get-shit-done | 2.9k | 54.9k | 4/5 |
| 12 | shiyu-coder/Kronos | 2.7k | 19.6k | 3/5 |
| 13 | lsdefine/GenericAgent | 2.6k | 4.5k | 2/5 |
| 14 | OpenBMB/VoxCPM | 2.6k | 14.8k | 4/5 |
| 15 | datawhalechina/hello-agents | 2.6k | 38.5k | 5/5 |
| 16 | HKUDS/DeepTutor | 2.4k | 20.1k | 4/5 |
| 17 | google/magika | 2.4k | 16k | 4/5 |
| 18 | EvoMap/evolver | 2.3k | 5.4k | 3/5 |
| 19 | badlogic/pi-mono | 2.2k | 37.4k | 3/5 |
| 20 | shareAI-lab/learn-claude-code | 2.1k | 54.8k | 5/5 |

---

## 📋 5 个趋势

| 趋势 | 代表项目 | 信号强度 |
|------|----------|----------|
| Skills 化一切 | karpathy-skills, agency-agents | 极强 |
| Claude Code 周边 | claude-mem, best-practice, learn-claude-code | 极强 |
| 中文圈崛起 | hello-agents, vibe-blog, learn-claude-code | 强 |
| 自我进化 | evolver, claude-mem, GenericAgent | 中 |
| 金融 AI 走强 | Kronos, ai-hedge-fund | 中 |

---

## ⚠️ 不足与反思

这周榜有个问题：**Karpathy Skills 的 37.2k 增长有水分**。它本质是一个课程索引，不是可运行的代码。很多人 star 了但不会真的用。相比之下，claude-mem 的 10.4k 增长更"实"——它是日调 50k 的生产工具。

看周榜别只看数字，要看**数字背后的使用密度**。

---

## 写在最后

**这周最值得你花 1 小时深读的项目：claude-mem。不是因为星最多，而是因为它解决了一个你一定会遇到的问题——AI 的失忆。**
