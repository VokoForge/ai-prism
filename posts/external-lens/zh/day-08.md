# Day 08 — 6 篇必读 Agent 论文 (中文版)

[English](../en/day-08.md) | [简体中文](./day-08.md)
> **为什么做这份清单.** 2026 H1 (1-6 月) 在 arxiv 上跟"Agent"相关的论文已超 3,200 篇. 但大多数是 demo 套壳或微调. 真正推动领域边界的只有 ~30 篇. 我们精选 6 篇, **每篇都改变了我们做项目的某个具体决策**.

## 一图速览

| # | 论文 | 发布 | 一句话贡献 | 为什么我们读了 |
|---|------|------|------------|----------------|
| 1 | [Why Do Multi-Agent LLM Systems Fail?](https://arxiv.org/abs/2503.13657) | 2025-03 | MAST 失败分类法 | 改了我们 agent 团队的失败模式枚举 |
| 2 | [A Survey of AI Agent Protocols](https://arxiv.org/abs/2504.16736) | 2025-04 | MCP / A2A / ANP 对比 | 给 MCP 选型提供路线图 |
| 3 | [AgentRxiv](https://arxiv.org/abs/2503.18102) | 2025-03 | Agent 共享 preprint 框架 | 启发"知识图谱联邦" |
| 4 | [Multiagent Finetuning](https://arxiv.org/abs/2501.05707) | 2025-01 | Self-improvement 多链推理 | 验证"多 agent 投票"有效性 |
| 5 | [A Survey of LLM Agent Self-Improvement](https://arxiv.org/abs/2503.21460) | 2025-03 | Self-evolution 4 大模式 | 改了我们 Rex 调度器降级链 |
| 6 | [Foam-Agent](https://arxiv.org/abs/2505.04997) | 2025-05 | 领域专用 agent 三件套 | 让我们放弃"通用 agent"幻想 |

---

## 1. Why Do Multi-Agent LLM Systems Fail? (MAST)

> *arXiv: 2503.13657 · 2025-03 · 作者: Cem Anil 等 (Princeton / Anthropic)*

**它做了什么.** 7 位作者花了 4 个月, 在 7 个 popular multi-agent 框架上跑 100+ 个 task, 手动分析 500+ 个失败 case, 提炼出 **14 类失败模式 (MAST taxonomy)**. 配套开源了 500+ 标注数据.

**核心洞见.**
> **"Multi-agent 失败 60% 来自沟通问题, 40% 来自任务理解问题——但传统调试只关注 40%."**

翻译: 大多数多 agent 失败不是"模型不够强", 是"agent 之间说不清". 跟我们实践一致——Rex 调度器 80% 的兜底逻辑是"agent 卡死时强制介入", 不是"模型换更好的".

**对我们的影响.**
- 之前: agent 失败 → 看 log → 修 prompt
- 现在: agent 失败 → 先查 MAST taxonomy → 定位类别 → 修调度逻辑

**复用价值.** 论文配套的标注数据是"金标准"——可以拿来做"agent 失败自动检测模型". 我们的 5-checklist review 脚本里加了 MAST classifier.

---

## 2. A Survey of AI Agent Protocols

> *arXiv: 2504.16736 · 2025-04 · 作者: 20+ 来自 CMU / Microsoft / Google DeepMind*

**它做了什么.** 第一次系统对比 **MCP / A2A / ANP** 三大 agent 通信协议. 从延迟、吞吐量、鉴权、扩展性、可观测性 5 维评分.

**核心洞见.**
> **"MCP 是 2025 的事实标准, A2A 是 2026 的潜在标准, ANP 是 2027 的开放标准."**

翻译: 如果你今天选 MCP, 未来 2 年内不用换; 如果你今天选 ANP, 准备好跟 Google 竞争; 如果你今天选 A2A, 押注 Google 赢.

**对我们的影响.**
- 主体用 MCP, 内部子 agent 用 A2A (Google 推广), 实验性用 ANP (开源)

---

## 3. AgentRxiv

> *arXiv: 2503.18102 · 2025-03 · 作者: Samuel Schmidgall 等 (Johns Hopkins)*

**它做了什么.** 一个**agent 之间的预印本共享平台**——多个研究 agent 把实验结果写成结构化 markdown, 存到 shared server. 接入 AgentRxiv 的 agent 解决新问题速度**快 2.3 倍**.

**核心洞见.**
> **"agent 之间的引用比 agent 之间的对话更有价值."**

翻译: agent 需要"引用"才能避免重复劳动. AgentRxiv 给的不是 chat room, 是个**带版本控制的实验记录库**.

**对我们的影响.** 重要决策写**结构化 experiment log**, 存到 `references/experiments/`, 其他 agent 启动时先 grep 这个目录.

---

## 4. Multiagent Finetuning

> *arXiv: 2501.05707 · 2025-01 · 作者: Princeton NLP group*

**它做了什么.** 4 个 agent 在同一 prompt 下生成不同 reasoning chain, 互相评分, 取 top-K 做 self-finetuning. 在 4 个 benchmark 上平均 +6.2 pt.

**核心洞见.**
> **"Agent 多样性 = 推理质量的护城河. 同质 agent 投票 < 异质 agent 投票."**

翻译: 不要让 4 个一样的 GPT-4 投票, 让 GPT-4 + Claude + Gemini + DeepSeek 投票.

**对我们的影响.** Rex 调度器在 Brain 2/3 降级时, 自动切到下一个异质 brain.

---

## 5. Self-Improvement Survey

> *arXiv: 2503.21460 (扩展综述) · 2025-03*

**它做了什么.** 综述 200+ 论文, 总结 LLM agent self-improvement 的 4 大模式: prompt self-refinement / memory consolidation / tool acquisition / workflow evolution.

**核心洞见.**
> **"Self-improvement 的目标不是 AGI, 是 agent 越来越像这个特定用户."**

**对我们的影响.** session 结束自动跑 3 件 self-improvement: 写 experiment log + 提取偏好 + 装载到下次 session.

---

## 6. Foam-Agent

> *arXiv: 2505.04997 · 2025-05*

**它做了什么.** 第一个"**领域专用 agent**"的成功案例——把 OpenFOAM (CFD 工具) 包装成 agent, 自然语言描述"机翼 0.6 马赫下的升力", 自动跑 3 个 case + 出报告.

**核心洞见.**
> **"领域专用 agent 的护城河不是 LLM, 是工具 + 数据 + 物理模型三件套."**

**对我们的影响.** 转向"领域专用 agent"——我们 Rex 是写作专用, 不试图让它做编程/财务/销售.

---

## 一个 SVG: 6 篇论文的影响力 × 可复现性

![papers-map](../../assets/day-08-papers-map.svg)

---

## 写在最后

2026 H1 是 Agent 论文**从"技术 demo"到"系统科学"**的转折点. 这 6 篇论文证明: agent 不再是"会聊天的程序", 是**有失败模式、有通信协议、有自进化能力、有领域护城河**的工程系统.

**下一篇 Day 09: 8 个 Agent 框架工程实践横评**.
