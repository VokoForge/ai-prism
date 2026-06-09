# 6个框架我全试了，只有2个能上生产

[English](../en/day-13.md) | [简体中文](./day-13.md)

Day 09 用特性矩阵看了 8 个框架。这篇深挖**6 个通用型**（目标是"啥都能做"，不是垂直工具）。我从**5 个工程轴**对比——这 5 个轴是真正部署时重要的：状态管理，可观测性，安全模型，部署形态，开发者体验。

说实话，6 个框架里只有 2 个我敢上生产：**LangGraph** 和 **Agno**。

```mermaid
flowchart TB
    subgraph PROD[能上生产]
        LG[LangGraph<br>状态管理5 可观测性5<br>安全2 部署4 体验4]
        AG[Agno<br>状态3 可观测4<br>安全2 部署5 体验4]
    end
    subgraph MAYBE[勉强能上]
        CR[CrewAI<br>状态2 可观测3<br>安全2 部署3 体验5]
        OH[OpenHands<br>状态3 可观测4<br>安全5 部署2 体验2]
    end
    subgraph NOPROD[不能上生产]
        LT[Letta<br>状态5 可观测3<br>安全3 部署3 体验3]
        AU[AutoGen<br>状态3 可观测4<br>安全3 部署3 体验3]
    end

    style LG fill:#6366f1,stroke:#4f46e5,color:#fff
    style AG fill:#6366f1,stroke:#4f46e5,color:#fff
    style CR fill:#f59e0b,stroke:#d97706,color:#fff
    style OH fill:#f59e0b,stroke:#d97706,color:#fff
    style LT fill:#94a3b8,stroke:#64748b,color:#fff
    style AU fill:#94a3b8,stroke:#64748b,color:#fff
```

---

## 🔥 01 状态管理 — 最重要的轴

对话状态，中间工具结果，人类反馈，存在哪？

**Letta** 把记忆当一等子系统做（core / archival / recall 三层），其他都是后挂的。如果你的 agent 要记住 200 轮对话，**Letta 帮你省几周**。其他场景，差异不大。

**LangGraph** 的 checkpointer 机制（内存 / PostgreSQL / Redis）是最灵活的，但需要你手动设计状态结构。

**CrewAI** 的 memory store 看起来方便，但复杂场景下不够灵活。

**之前：状态全放内存，重启就丢 → 现在：LangGraph checkpointer 持久化到 PostgreSQL → 这意味着：agent 终于能"断点续传"了。**

说白了，状态管理就是 agent 的"存档功能"——没有存档，你敢让 agent 跑 2 小时的任务吗？

---

## 🛠️ 02 可观测性 — 凌晨 3 点出问题时你能看见什么

能付费的话，**LangGraph + LangSmith** 是金标准。每节点 token 计数，时间线追踪，成本分析，一键复现。

**Agno** 是个惊喜——内建 dashboard 真不错，不用接第三方就能看到每个 session 的运行状态。

**AutoGen** 对纯 OpenTelemetry 团队最友好，原生支持。

```mermaid
flowchart LR
    subgraph 付费方案
        LG[LangGraph + LangSmith<br>金标准 一键复现]
    end
    subgraph 免费方案
        AG[Agno 内建 dashboard<br>零成本 够用]
        AU[AutoGen + OpenTelemetry<br>原生支持 需配置]
    end

    style LG fill:#6366f1,stroke:#4f46e5,color:#fff
    style AG fill:#10b981,stroke:#059669,color:#fff
    style AU fill:#f59e0b,stroke:#d97706,color:#fff
```

**之前：agent 出错只能看 print log → 现在：LangSmith 时间线追踪 → 这意味着：调试时间从 2 小时降到 10 分钟。**

---

## 💡 03 安全模型 — 谁能做什么，怎么约束

如果"agent 能跑不可信代码"在你的路线图上，**OpenHands** 是 6 个里唯一当真的——Docker + bubblewrap 双重隔离。

其他都假设你自己包一层沙箱。说实话，这不够。2026 年的 agent 会越来越多地执行代码，安全模型会变成选型的决定性因素。

**之前：agent 直接在宿主机跑代码 → 现在：OpenHands Docker 双重隔离 → 这意味着：终于不用提心吊胆了。**

---

## 📋 5 维评分表 & 总排名

| 框架 | 状态管理 | 可观测性 | 安全模型 | 部署形态 | 开发者体验 | 能上生产？ |
|------|----------|----------|----------|----------|------------|-----------|
| **LangGraph** | 5 | 5 | 2 | 4 | 4 | 能 |
| **Agno** | 3 | 4 | 2 | 5 | 4 | 能 |
| CrewAI | 2 | 3 | 2 | 3 | 5 | 勉强 |
| OpenHands | 3 | 4 | 5 | 2 | 2 | 特定场景 |
| Letta | 5 | 3 | 3 | 3 | 3 | 看场景 |
| AutoGen | 3 | 4 | 3 | 3 | 3 | 显老了 |

**部署形态：** Agno 对 serverless 最友好。LangGraph 对"我们已经有 k8s"最友好。OpenHands 唯一不太行 serverless——它要一台长驻机器。

**开发者体验：** 原型阶段 CrewAI 速度第一（15 分钟跑通）。生产阶段 LangGraph 文档 + 可观测性第一。"我有真实产品" Agno 平衡最好。

---

## ⚠️ 不足与反思

6 个框架都有一个共同的盲区：**MCP 支持**。2026.05 所有框架都声称支持 MCP，但支持质量参差不齐——有的只是适配器层，有的有原生支持。这不是差异点了，但实现质量差异很大。

另外，**没有框架认真解决"成本控制"**。LangGraph 有 token 计数，但没有预算硬上限。CrewAI 有每任务成本追踪，但没有自动降级。这是 2026 H2 必须补上的短板。

---

## 写在最后

如果你问"2026 我该先学哪个框架？"，实话是 **LangGraph**——它教你的工程纪律最值。然后试 **Agno** 感受部署的爽。**AutoGen** 跳过，除非你的团队已经在 Microsoft 生态里。

**框架不是信仰，是工具。能上生产的才是好框架，不能上生产的再优雅也是玩具。**
