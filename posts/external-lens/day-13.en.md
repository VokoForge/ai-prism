# Day 13 · General-Purpose Agent Frameworks: 6-Way Engineering Review

> **Date:** 2026-05-28 · **Category:** Engineering · **Difficulty:** Intermediate
> **Read time:** ~12 min

Day 09 looked at 8 frameworks by feature matrix. This post goes deeper on **6 general-purpose** frameworks (the ones that aim to "do anything" — not vertical tools). We compare them on **5 engineering axes** that matter when you actually deploy: state management, observability, security model, deployment surface, and developer ergonomics.

## Scope

We compare these 6, all released or significantly updated in 2025-2026:

1. **LangGraph** (LangChain)
2. **CrewAI**
3. **AutoGen** (Microsoft)
4. **Letta** (formerly MemGPT)
5. **Agno** (ex-PhiData)
6. **OpenHands** (formerly OpenDevin)

We **exclude** domain-specific ones (Devin, v0, Bolt) and pure protocol layers (MCP, A2A).

## Axis 1 — State management

The single most important axis. Where does conversation state, intermediate tool results, and human feedback live?

| Framework | Default state | Persistence | Long-context strategy |
|-----------|---------------|-------------|------------------------|
| LangGraph | In-memory checkpointer | PostgreSQL / Redis checkpointers | Manual truncation, summarization nodes |
| CrewAI | Per-task dict | Built-in memory store (short / long / entity) | Auto-summarization at token threshold |
| AutoGen | Per-agent `ChatCompletionContext` | Optional DB backend | Token budget management |
| Letta | **First-class memory hierarchy** (core / archival / recall) | Postgres + pgvector | Built-in context window management |
| Agno | Session-based, in-memory | Optional DB | Manual |
| OpenHands | Per-runtime workspace | Event-sourced runtime | Workspace snapshot + replay |

**The honest take:** Letta treats memory as a first-class subsystem; everyone else bolts it on. If your agent needs to remember a 200-message conversation, **Letta will save you weeks**. For everything else, the differences are small.

## Axis 2 — Observability

What you can see when it goes wrong at 3am.

| Framework | Tracing | Cost tracking | Production-grade? |
|-----------|---------|---------------|-------------------|
| LangGraph | LangSmith (paid) or OpenTelemetry export | Per-node token counters | ✅ Mature |
| CrewAI | Built-in event stream + 3rd party (Langfuse, Arize) | Per-task, per-agent | ⚠️ Improving |
| AutoGen | OpenTelemetry native | Per-message token counts | ✅ Mature |
| Letta | REST API + OpenTelemetry | Per-message | ⚠️ Young |
| Agno | Built-in dashboard | Per-session | ✅ Strong |
| OpenHands | Runtime event log + web UI | Per-action | ✅ Strong (devtool focus) |

**The honest take:** LangGraph + LangSmith is the **gold standard** if you can pay. **Agno** is the surprise — built-in dashboard is genuinely good. **AutoGen** is best for pure OpenTelemetry shops.

## Axis 3 — Security model

Who can do what, and how do you constrain it?

| Framework | Sandboxing | Auth model | Network egress controls |
|-----------|-----------|------------|------------------------|
| LangGraph | None (user code) | External (FastAPI etc.) | None built-in |
| CrewAI | None | External | Per-tool HTTP allowlist |
| AutoGen | Docker executor (optional) | External | Per-tool filters |
| Letta | None | RBAC + per-agent permissions | Per-tool filters |
| Agno | None | External | Per-tool |
| OpenHands | **Docker first-class** | Internal + JWT | Egress allowlist, per-action |

**The honest take:** If "the agent can run untrusted code" is on your roadmap, **OpenHands** is the only one of these six that takes it seriously. Everyone else assumes you wrap them in your own sandbox.

## Axis 4 — Deployment surface

How do you actually run it in production?

| Framework | Edge / Serverless | Long-running server | Local dev |
|-----------|-------------------|---------------------|-----------|
| LangGraph | ✅ LangGraph Platform | ✅ Self-hosted | ✅ CLI + Studio |
| CrewAI | ⚠️ Possible but awkward | ✅ Standard | ✅ CLI |
| AutoGen | ⚠️ | ✅ | ✅ |
| Letta | ⚠️ | ✅ Docker / cloud | ✅ Server + UI |
| Agno | ✅ Cloud + agent.os | ✅ | ✅ CLI |
| OpenHands | ❌ (stateful runtime) | ✅ Docker / k8s | ✅ Docker |

**The honest take:** **Agno** is the friendliest for serverless. **LangGraph** is the friendliest for "we already have a Kubernetes cluster". **OpenHands** is the only one that doesn't really do serverless — it wants a long-running box.

## Axis 5 — Developer ergonomics

Subjective, but consistent across our 6 reviewers.

| Framework | Time-to-first-agent | Time-to-1000-LOC-system | Documentation |
|-----------|---------------------|--------------------------|----------------|
| LangGraph | 30 min | 2-3 days (graphs get complex) | ★★★★★ |
| CrewAI | 15 min (most opinionated) | 1-2 days | ★★★★ |
| AutoGen | 1-2 hours (more boilerplate) | 3-4 days | ★★★★ |
| Letta | 1 hour (memory model is new) | 2-3 days | ★★★ |
| Agno | 30 min | 2 days | ★★★ (growing fast) |
| OpenHands | 2-3 hours (Docker setup) | 4-5 days | ★★★ |

**The honest take:** For prototyping, **CrewAI** wins on speed-to-first-demo. For production, **LangGraph** wins on docs + observability. For "I have a real product", **Agno** has the best balance as of 2026.05.

## Our overall ranking (5-axis average)

| Rank | Framework | Best for |
|------|-----------|----------|
| 1 | **LangGraph** | Production, large teams, deep observability budget |
| 2 | **Agno** | Serverless + dashboard, balanced product |
| 3 | **CrewAI** | Rapid prototyping, role-based demos |
| 4 | **OpenHands** | Anything involving untrusted code execution |
| 5 | **Letta** | Long conversations, memory-heavy agents |
| 6 | **AutoGen** | OpenTelemetry-native shops, .NET / Azure shops |

## What we deliberately didn't compare

- **LLM quality** — depends on which model you call. All six work with OpenAI / Anthropic / open-source.
- **Prompt engineering depth** — none has a "better prompt" out of the box; you write your own.
- **MCP support** — all six now support it, native or via adapter. Not a differentiator in 2026.05.

## Our take

If you ask "which framework should I learn first in 2026?", the honest answer is **LangGraph** — for the engineering discipline it teaches you. Then try **Agno** for the deployment joy. Skip **AutoGen** unless your team is already in the Microsoft orbit; it shows its age in places.

---
