# Day 13 · 通用 Agent 框架横评: 6 选 1 工程指南

[English](../en/day-13.md) | [简体中文](./day-13.md)
> **日期:** 2026-05-28 · **类型:** 工程 · **难度:** 中级
> **阅读时间:** ~12 分钟

Day 09 用特性矩阵看了 8 个框架。这篇深挖** 6 个通用型** (目标是"啥都能做", 不是垂直工具)。我们从** 5 个工程轴**对比, 这 5 个轴是真正部署时重要的: 状态管理, 可观测性, 安全模型, 部署形态, 开发者体验。

## 范围

比较这 6 个, 都是 2025-2026 期间发布或重大更新:

1. **LangGraph** (LangChain)
2. **CrewAI**
3. **AutoGen** (Microsoft)
4. **Letta** (前 MemGPT)
5. **Agno** (前 PhiData)
6. **OpenHands** (前 OpenDevin)

**不包含** 垂直类 (Devin, v0, Bolt) 和纯协议层 (MCP, A2A)。

## 轴 1 — 状态管理

最重要的轴。对话状态, 中间工具结果, 人类反馈, 存在哪?

| 框架 | 默认状态 | 持久化 | 长上下文策略 |
|------|----------|--------|--------------|
| LangGraph | 内存 checkpointer | PostgreSQL / Redis checkpointer | 手动截断 / 摘要节点 |
| CrewAI | 每任务 dict | 内置 memory store (短/长/实体) | 达 token 阈值自动摘要 |
| AutoGen | 每 agent `ChatCompletionContext` | 可选 DB 后端 | Token 预算管理 |
| Letta | **一等公民记忆层级** (core / archival / recall) | Postgres + pgvector | 内建上下文窗口管理 |
| Agno | session 基础, 内存 | 可选 DB | 手动 |
| OpenHands | 每 runtime workspace | 事件源 runtime | workspace 快照 + 回放 |

**实话说:** Letta 把记忆当一等子系统做, 其他都是后挂的。如果你的 agent 要记住 200 轮对话, **Letta 帮你省几周**。其他场景, 差异不大。

## 轴 2 — 可观测性

凌晨 3 点出问题时你能看见什么。

| 框架 | Tracing | 成本追踪 | 生产级? |
|------|---------|----------|---------|
| LangGraph | LangSmith (付费) 或 OpenTelemetry 导出 | 每节点 token 计数 | ✅ 成熟 |
| CrewAI | 内建事件流 + 第三方 (Langfuse, Arize) | 每任务每 agent | ⚠️ 在改进 |
| AutoGen | OpenTelemetry 原生 | 每消息 token 计数 | ✅ 成熟 |
| Letta | REST API + OpenTelemetry | 每消息 | ⚠️ 年轻 |
| Agno | 内建 dashboard | 每 session | ✅ 强 |
| OpenHands | runtime 事件日志 + web UI | 每 action | ✅ 强 (devtool 导向) |

**实话说:** 能付费的话, LangGraph + LangSmith 是**金标准**。**Agno** 是个惊喜, 内建 dashboard 真不错。**AutoGen** 对纯 OpenTelemetry 团队最友好。

## 轴 3 — 安全模型

谁能做什么, 怎么约束?

| 框架 | 沙箱 | 鉴权模型 | 网络出站控制 |
|------|------|----------|--------------|
| LangGraph | 无 (用户代码) | 外部 (FastAPI 等) | 无内建 |
| CrewAI | 无 | 外部 | 每工具 HTTP 白名单 |
| AutoGen | Docker executor (可选) | 外部 | 每工具 filter |
| Letta | 无 | RBAC + 每 agent 权限 | 每工具 filter |
| Agno | 无 | 外部 | 每工具 |
| OpenHands | **Docker 一等公民** | 内部 + JWT | 出站白名单, 每 action |

**实话说:** 如果"agent 能跑不可信代码"在你的路线图上, **OpenHands** 是 6 个里唯一当真的。其他都假设你自己包一层沙箱。

## 轴 4 — 部署形态

真正上线怎么跑?

| 框架 | Edge / Serverless | 长驻 server | 本地开发 |
|------|-------------------|-------------|----------|
| LangGraph | ✅ LangGraph Platform | ✅ 自托管 | ✅ CLI + Studio |
| CrewAI | ⚠️ 可以但别扭 | ✅ 标准 | ✅ CLI |
| AutoGen | ⚠️ | ✅ | ✅ |
| Letta | ⚠️ | ✅ Docker / cloud | ✅ server + UI |
| Agno | ✅ cloud + agent.os | ✅ | ✅ CLI |
| OpenHands | ❌ (有状态 runtime) | ✅ Docker / k8s | ✅ Docker |

**实话说:** **Agno** 对 serverless 最友好。**LangGraph** 对"我们已经有 k8s"最友好。**OpenHands** 唯一不太行 serverless — 它要一台长驻机器。

## 轴 5 — 开发者体验

主观, 但我们 6 个审稿人一致。

| 框架 | 首个 agent 耗时 | 千行系统耗时 | 文档 |
|------|------------------|--------------|------|
| LangGraph | 30 分钟 | 2-3 天 (图会变复杂) | ★★★★★ |
| CrewAI | 15 分钟 (最有主张) | 1-2 天 | ★★★★ |
| AutoGen | 1-2 小时 (更多 boilerplate) | 3-4 天 | ★★★★ |
| Letta | 1 小时 (记忆模型是新的) | 2-3 天 | ★★★ |
| Agno | 30 分钟 | 2 天 | ★★★ (快速增长) |
| OpenHands | 2-3 小时 (Docker 配置) | 4-5 天 | ★★★ |

**实话说:** 原型阶段 **CrewAI** 速度第一。生产阶段 **LangGraph** 文档+可观测性第一。"我有真实产品" **Agno** 平衡最好 (截至 2026.05)。

## 我们的总排名 (5 轴平均)

| 排名 | 框架 | 适合谁 |
|------|------|--------|
| 1 | **LangGraph** | 生产, 大团队, 深度可观测性预算 |
| 2 | **Agno** | Serverless + dashboard, 均衡产品 |
| 3 | **CrewAI** | 快速原型, 角色制 demo |
| 4 | **OpenHands** | 涉及不可信代码执行的任何场景 |
| 5 | **Letta** | 长对话, 记忆密集 agent |
| 6 | **AutoGen** | OpenTelemetry-native 团队, .NET / Azure 团队 |

## 我们故意没比较的

- **LLM 质量** — 看你调哪个模型。6 个都支持 OpenAI / Anthropic / 开源。
- **Prompt 工程深度** — 没有"更好的 prompt", 都自己写。
- **MCP 支持** — 6 个现在都支持, 原生或适配器, 2026.05 不再是差异点。

## 我们的看法

如果你问"2026 我该先学哪个框架?", 实话是 **LangGraph** — 它教你的工程纪律最值。然后试 **Agno** 感受部署的爽。**AutoGen** 跳过, 除非你的团队已经在 Microsoft 生态里, 它有些地方显老了。
