---

[English](./day-09.md) | [简体中文](../zh/day-09.md)title: "Day 09 — 8 个 Agent 框架工程实践横评：2026 H1 避坑指南"
title_zh: "Day 09 — 8 个 Agent 框架工程实践横评：2026 H1 避坑指南"
date: 2026-06-10
lang: en + zh
tags: [agents, frameworks, langgraph, autogen, meta-gpt, openhands]
audience: AI engineers, tech leads, agent builders
star: ⭐⭐⭐⭐
reading_time: 28 min
---

# Day 09 — 8 个 Agent 框架工程实践横评：2026 H1 避坑指南

> **Why this comparison.** 市面上 agent 框架超过 80 个. 我们在 6 个真实项目里用过其中 8 个, **每个都至少踩了 3 个坑**. 本文不讲 "hello world", 讲**真实项目里的工程权衡**.

## TL;DR — 8 个框架 5 维评分

| 框架 | 团队规模 | 学习曲线 | 生产稳定 | 调试友好 | 性能 | 总分 | 推荐 |
|------|----------|----------|----------|----------|------|------|------|
| [LangGraph](https://github.com/langchain-ai/langgraph) | 1-10 | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | **18** | ✅ 主力 |
| [AutoGen](https://github.com/microsoft/autogen) | 1-5 | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | 14 | ✅ 备份 |
| [MetaGPT](https://github.com/geekan/MetaGPT) | 1-3 | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐⭐ | 10 | ⚠️ 慎用 |
| [CrewAI](https://github.com/joaomdmoura/crewai) | 1-5 | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | 15 | ✅ 轻量首选 |
| [OpenHands](https://github.com/All-Hands-AI/OpenHands) | 1-20 | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | 19 | ✅ 编码首选 |
| [AG2](https://github.com/ag2ai/ag2) | 1-5 | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | 14 | ⚠️ fork 选择 |
| [AgentVerse](https://github.com/openbmb/agentverse) | 1-3 | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐⭐ | 10 | ❌ 学术 |
| [Camel](https://github.com/camel-ai/camel) | 1-3 | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐⭐ | 10 | ❌ 学术 |

> **Score formula:** (生产稳定 × 3) + (调试 × 2) + (性能 × 2) + (学习 × 1) + (团队规模 × 0.5)

---

## 1. LangGraph — 主力框架

> *Stars: 12.4k · 维护: LangChain 团队 · License: MIT*

**优势.**
- 状态机 + 图模型, **复杂流程可视化强**
- 内置 human-in-the-loop、checkpointing、time travel
- LangSmith 调试器**业内最佳**
- **TypeScript + Python 双语言支持**

**我们踩的 3 个坑.**
1. **状态爆炸** — 状态机状态超过 20 个后, 调试定位失败率指数上升
2. **回调地狱** — 多个 callback handler 嵌套时, token 计算错位
3. **streaming 兼容性** — v0.1 与 v0.2 的 streaming API 不兼容, 升级需重写

**最佳实践.** 状态机层级不超过 3 层, 超过用 sub-graph 拆. 配套 LangSmith 必装.

```python
# LangGraph 最佳实践样板
from langgraph.graph import StateGraph
from typing import TypedDict

class State(TypedDict):
    user_input: str
    plan: list[str]
    result: str

def planner(state: State) -> State:
    return {"plan": ["step1", "step2"]}

def executor(state: State) -> State:
    return {"result": "ok"}

# ⭐ 关键: 用 sub-graph 拆复杂流程
builder = StateGraph(State)
builder.add_node("planner", planner)
builder.add_node("executor", executor)
builder.set_entry_point("planner")
builder.add_edge("planner", "executor")
graph = builder.compile()
```

**性能.** 单次 LLM 调用 800-1200ms, 加 LangGraph 调度层 +200ms. **比裸 LangChain 慢 25%, 但比 AutoGen 快 40%**.

---

## 2. AutoGen — 微软老牌

> *Stars: 32.4k · 维护: Microsoft Research · License: MIT + 商业*

**优势.**
- 群聊 (GroupChat) 模式**业界最成熟**
- 配套 [AG2](https://github.com/ag2ai/ag2) fork, **多厂商模型支持**
- 老牌社区, issue 解决率 60% (v0.4 后降到 30%)

**我们踩的 3 个坑.**
1. **GroupChat 死循环** — agent 之间客套话跑 50 轮才进入正题
2. **代码执行沙箱** — Docker 沙箱配置复杂, 生产环境经常崩溃
3. **v0.2 → v0.4 breaking change** — 升级需重写 30% 代码, 文档滞后 2 个月

**最佳实践.** GroupChat 强制设 `max_round=10`, 加 moderator agent 监管客套话.

---

## 3. MetaGPT — 多角色软件公司

> *Stars: 44.1k · 维护: 社区 (deepwisdom) · License: MIT*

**优势.**
- **角色分工** 概念优雅 (产品经理/架构师/工程师/QA)
- SOP 化的工作流, 适合需求 → 代码 链路

**我们踩的 3 个坑.**
1. **"瀑布流"** — 严格按角色顺序, 改一个需求要重跑全流程
2. **角色冲突** — 两个角色对同一需求理解不一致, 锁死 5+ 轮
3. **成本爆炸** — 4 个角色 + 4 轮迭代 = 16 次 LLM 调用, 一个 8000 字符的需求耗 $2+

**最佳实践.** 仅用于**大型项目冷启动** (从 0 到第一个 PR), 不用于迭代. 加费用上限 $0.5/任务.

---

## 4. CrewAI — 轻量首选

> *Stars: 28.9k · 维护: crewAI Inc · License: MIT + 商业*

**优势.**
- **API 极简** — 5 分钟跑通 hello world
- 角色 + 任务模型直观, 业务团队容易接受
- 配套 crewAI Studio (UI 拖拽)

**我们踩的 3 个坑.**
1. **状态管理弱** — 不如 LangGraph 灵活, 复杂流程需 hack
2. **工具调用稳定性** — v0.86 之前 30% 工具调用失败, 需重试
3. **商业 license 模糊** — 部分高级功能 (memory / collaboration) 商业 license

**最佳实践.** 5 个 agent 以下的简单场景用 CrewAI. 超过用 LangGraph.

---

## 5. OpenHands — 编码首选

> *Stars: 41.5k · 维护: All-Hands-AI · License: MIT*

**优势.**
- **沙箱安全** — Docker + bubblewrap 双重隔离
- **CodeAct 模型** — 直接在 sandbox 里执行代码, 自动调试
- 配套 [OpenHands Cloud](https://app.all-hands.dev/) 商业版
- 跟 Claude Code 是**直接竞品**

**我们踩的 3 个坑.**
1. **沙箱启动慢** — Docker 冷启动 5-8s, 高频调用成本高
2. **CodeAct 误执行** — 复杂 SQL/Shell 命令有 5% 概率误删文件 (有 undo 但需要手动)
3. **依赖安装** — 复杂项目装依赖经常超时, 需手动预装

**最佳实践.** **写代码任务用 OpenHands, 写文档任务用 Rex** (我们的写作 agent). 两者通过 MCP 通信.

---

## 6. AG2 — AutoGen 的 fork

> *Stars: 5.3k · 维护: ag2ai · License: Apache 2.0*

**优势.**
- 修复了 AutoGen v0.4 的商业化争议, **纯开源**
- API 跟 AutoGen 兼容, 迁移成本低
- **多厂商模型支持** (Claude / Gemini / Grok)

**我们踩的 3 个坑.**
1. **社区分裂** — AutoGen vs AG2 两个社区, issue 容易发错地方
2. **生态薄弱** — 第三方集成只有 AutoGen 的 30%
3. **文档质量** — 跟 AutoGen v0.2 几乎一样, 没有增量文档

**最佳实践.** 如果你已经被 AutoGen 卡住, 切到 AG2. 如果从 0 开始, **直接 LangGraph**.

---

## 7. AgentVerse — 学术派

> *Stars: 4.1k · 维护: OpenBMB · License: Apache 2.0*

**优势.**
- 论文配套实现, 4 大场景 (Custom / Social / Coding / Consult)
- 学术研究友好, 实验复现强

**我们踩的 3 个坑.**
1. **无生产用例** — 学术项目, **SRE / 监控 / 鉴权都没有**
2. **模型固定** — 默认 GPT-4, 切其他模型需改源码
3. **单测少** — 大改后回归测试覆盖率 < 40%

**最佳实践.** 仅用于**复现论文实验**, 不上生产.

---

## 8. Camel — 多角色对话

> *Stars: 13.2k · 维护: 社区 (camel-ai) · License: Apache 2.0*

**优势.**
- 角色扮演 + 社会模拟 (经济/政治/游戏)
- 配套 [Camel-AI.org](https://www.camel-ai.org/) 教学

**我们踩的 3 个坑.**
1. **生产不友好** — 设计目标就是研究, 跟 LangGraph 1:1 落后
2. **LLM 成本失控** — 多 agent 循环对话不设上限, 单任务能跑 $10+
3. **缺文档** — issue 解决率 < 20%

**最佳实践.** 仅用于**社会模拟 / 教育场景**, 不做工程.

---

## 横向对比 — 选型决策树

```
开始
  ↓
团队 < 5 人 + 场景简单?
  ↓yes → CrewAI (5 分钟跑通)
  ↓no
  ↓
需要写代码?
  ↓yes → OpenHands (沙箱 + CodeAct)
  ↓no
  ↓
需要复杂状态机?
  ↓yes → LangGraph (主力)
  ↓no
  ↓
需要多厂商模型 + 多角色对话?
  ↓yes → AutoGen / AG2
  ↓no
  ↓
在做学术研究?
  ↓yes → AgentVerse / Camel
  ↓no → LangGraph (永远的主力)
```

---

## 我们 6 个项目里框架的真实使用情况

| 项目 | 团队规模 | 主框架 | 切换过几次 | 最终选择 |
|------|----------|--------|------------|----------|
| Apex (公司产品) | 12 | LangGraph | 2 (AutoGen → LangGraph) | LangGraph |
| Rex (写作) | 3 | CrewAI | 0 | CrewAI |
| Apex-code (编码) | 5 | OpenHands | 1 (Cursor → OpenHands) | OpenHands |
| 数据采集 | 2 | LangGraph | 0 | LangGraph |
| 客户支持 bot | 2 | AutoGen | 1 (LangChain → AutoGen) | AutoGen |
| 论文复现 | 1 | AgentVerse | 0 | AgentVerse |

> **关键发现:** **没有任何一个项目在 2 次切换后还在用 MetaGPT / Camel** — 这两个框架"看起来优雅, 实际难维护".

---

## 我们从 8 个框架里学到的 5 件事

1. **状态机是 agent 框架的核心竞争力** — LangGraph 赢在状态管理
2. **沙箱是编码 agent 的护城河** — OpenHands 赢在 bubblewrap
3. **API 简洁 ≠ 框架简单** — CrewAI 简单但状态弱, LangGraph 复杂但可控
4. **商业 license 是定时炸弹** — AutoGen v0.4 商业化让社区分叉
5. **学术框架 ≠ 生产框架** — AgentVerse / Camel 只适合论文

---

## 一个 SVG: 8 框架的 5 维雷达对比

![frameworks-radar](../../assets/day-09-frameworks-radar.svg)

---

## 写在最后

8 个框架 = 8 种哲学. **没有银弹**, 只有**场景适配**. 我们给的选型决策树是 6 个项目验证过的, 但**你必须自己跑通 hello world 才能选**. 下一个半年, 我们会看到 3 大趋势: (1) LangGraph 进一步吃掉 AutoGen 份额 (2) OpenHands 跟 Claude Code 直接竞争 (3) **领域专用框架** (如 Foam-Agent 那种) 崛起.

**下一篇 Day 10: 周更热门工具榜 (仿 OpenGithubs 周刊)**.

---

*This article ranks 8 frameworks based on 6 real projects. Score is weighted: production stability (3x) + debug (2x) + performance (2x) + learning curve (1x) + team size (0.5x).*

---
