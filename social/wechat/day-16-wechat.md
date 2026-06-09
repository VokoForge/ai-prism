# 向量检索的 Rust 革命 & Agent Skills 爆发临界点

![配图1](day-16-cover.svg)

你有没有想过，当你的 RAG 系统在千万级向量上延迟飙到秒级，瓶颈到底在哪里？

不是模型推理。

是检索。

---

## 🔥 TurboVec：一周涨 1600+ stars 的向量搜索火箭

TurboVec 用 Rust 重写了向量索引核心，搜索速度比 FAISS/HNSW **快 10-100 倍**。

7600+ ⭐，周增 1600+，Rust + Python 绑定，MIT 协议。

核心思路是"**量化即索引**"——不再维护独立的 HNSW 图结构，而是把量化码本直接当索引用。

省掉了图遍历的随机内存访问，CPU 缓存命中率飙升。

> 💡 **架构启示：有时候最好的优化不是更好的算法，而是更适合硬件的数据布局。**

就像 2015 年的 Redis 之于 MySQL——不是替代，而是在热路径上做专用加速。

如果你的 RAG 还在用默认的 FAISS flat index，该醒醒了。

---

## ⚡ CopilotKit：Agent UI 的 React 基础设施

搭过 Agent 前端的人都知道痛——流式输出、工具调用可视化、人机协作审批流，每个都要从零写。

CopilotKit 把这些抽象成 React 组件：`<CopilotChat>`、`<CopilotTask>`、`<CopilotAction>`，开箱即用。

单日 +613 ⭐。

架构上走的是"**前端即 Agent 控制面**"路线——LLM 的 tool call 通过 WebSocket 推到前端，前端渲染成可交互 UI。

> 💡 **2024 年卷 Agent 后端编排，2026 年卷的是 Agent 前端体验。Agent 的差异化不在"能做什么"，在"怎么让人参与"。**

---

## 📚 open-notebook：知识蒸馏的 Agent 工作台

单日 +783 ⭐，Python，Apache-2.0。

它把"读论文 → 提取洞察 → 生成笔记"做成了 **DAG 工作流**，每个节点可插拔替换 LLM 和 prompt。

核心是 Notebook DAG——你定义 source（PDF/URL/文件）、transform（摘要/对比/批判）、sink（Markdown/Anki 卡片/Notion）。

每个 transform 节点独立配置 model + temperature + system prompt，支持 A/B 对比。

> 💡 **这才是 RAG 应该有的样子——不是"检索+拼接"，而是"检索→理解→重构"。**

---

## 💀 AI 硬件的 GTM 深渊

京东最近搞了场 AI 硬件选秀，暴露了一个残酷现实：

**大部分 AI 硬件团队有技术有创意，但不会做商业化。**

一个做 AI 陪伴机器人的团队，产品 Demo 惊艳，但 3 个月只卖了 200 台。

定价 2999，用户心理价位 599。

不知道怎么建渠道、定价、做售后。硬件有库存压力、供应链风险、退货率。

> ⚠️ **AI 硬件的护城河不在模型，在供应链和渠道。技术团队做硬件，至少要配一个做过消费电子的合伙人。**

---

## 🎯 One More Thing

HN 上 HashiCorp 创始人 Mitchell Hashimoto 说当前有些公司"陷入了 AI 精神病"——不是 AI 有问题，是公司对 AI 的预期脱离现实。

这话刺耳但精准：

**把 AI 当银弹的组织，最后都会被银弹反噬。**

能活下来的，是那些把 AI 当螺丝刀的人——不炫技，只拧该拧的螺丝。

---

**2026 年的 AI 竞争，比的不是谁的模型大，而是谁的检索快、技能多、落地狠。**

👇 关注**AI棱镜**，每日 AI 洞见

---

*本文来自 AI棱镜 Day 16 · 外部棱镜系列*
