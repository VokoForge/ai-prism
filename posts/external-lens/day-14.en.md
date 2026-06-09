# Day 14 · State of AI Agents, 2026 H1: 5 Scenarios, 16 Projects Worth Knowing

> **Date:** 2026-05-29 · **Category:** Landscape · **Difficulty:** All levels
> **Read time:** ~14 min

Twice a year we publish a "state of" map. This is the H1 2026 edition. We picked **16 representative projects** across **5 scenarios** that a working developer should at least know the name of. The goal is not to rank them (Day 09 and 13 do that) — the goal is to give you a mental map so the next time someone drops a name you know where to slot it.

## How we picked

Three filters, in order:

1. **Active in 2025-2026** — at least one significant release in the last 6 months.
2. **>1k GitHub stars OR >1k PyPI/npm weekly downloads** — proved utility, not hype.
3. **Different design point** — we don't include 4 langgraph-forks.

The 16 are listed below. We deliberately mix big and small: the small ones are where the design lessons live.

![agents-landscape](assets/day-14-agents-landscape.svg)

## The 5 scenarios

```
┌────────────────────┐  ┌────────────────────┐  ┌────────────────────┐
│ 1. Local execution │  │ 2. Autonomous task │  │ 3. Multi-agent     │
│ (single user,      │  │    (long horizon,  │  │    (teams of       │
│  single machine)   │  │     self-directed) │  │     specialists)   │
└────────────────────┘  └────────────────────┘  └────────────────────┘
┌────────────────────┐  ┌────────────────────┐
│ 4. Low-code /      │  │ 5. Vertical /      │
│    Visual (no code │  │    domain-specific │
│    or minimal)     │  │    (writer, code,  │
│                    │  │     research…)     │
└────────────────────┘  └────────────────────┘
```

Why 5? It's the smallest partition where each scenario has at least 3 representatives and they're clearly distinct in design. Any 4-scenario map merges "autonomous" and "multi-agent" and loses the lesson; any 6-scenario map splits "vertical" artificially.

---

## Scenario 1 — Local execution (4 projects)

The "runs on your laptop" tier. The user is the agent's only stakeholder.

| Project | One-liner | Why it matters |
|---------|-----------|----------------|
| **OpenHands** | Sandboxed dev agent in Docker | Only mainstream framework that treats code execution as a security boundary |
| **Aider** | Terminal-pair AI coding | The benchmark for "what good pair-programming UX feels like" |
| **Continue** | VS Code / JetBrains extension | The most extensible IDE-side agent (open-source, MCP-native) |
| **Cline** | VS Code extension with MCP | Most aggressive MCP adopter in the IDE space |

**The lesson of this tier:** local agents win on **latency and trust** — the user sees every action, the sandbox is one container, and the loop is tight (sub-second per tool call). The ceiling is "what one human can review in a session".

## Scenario 2 — Autonomous task (3 projects)

The "I give you a goal, you come back in 2 hours" tier.

| Project | One-liner | Why it matters |
|---------|-----------|----------------|
| **OpenAI Deep Research** | Multi-step research with citation chain | Proved that "long horizon + tool use + verification" works at scale |
| **Manus** | Generalist cloud agent (closed-beta) | The Chinese answer to Deep Research; first to ship "computer use" in production |
| **Forge** (vieko) | Outcome-driven orchestration | Defines success as a *spec*, not a procedure — cleanest contract we've seen |

**The lesson of this tier:** the design bottleneck is no longer the LLM; it's **the verification loop**. Forge's "spec as a contract, agent decides how" pattern is the most promising direction. Manus showed the world that computer-use is deployable (with caveats).

## Scenario 3 — Multi-agent (3 projects)

The "team of specialists" tier. Roles, hand-offs, sometimes conflict.

| Project | One-liner | Why it matters |
|---------|-----------|----------------|
| **LangGraph** | Graph-based orchestration | Industry-standard; the "k8s of agent graphs" |
| **CrewAI** | Role-based crews | Lowest learning curve; opinionated about agent-as-person |
| **AutoGen** (Microsoft) | Conversation-first | Best OpenTelemetry story; best for academic research |

**The lesson of this tier:** "multi-agent" ≠ "more agents". The wins come from **clear role boundaries** and **explicit hand-off protocols**, not from spawning more LLMs. The 3 frameworks diverge on those two axes only; the rest is implementation detail.

## Scenario 4 — Low-code / Visual (3 projects)

The "non-developer can build it" tier.

| Project | One-liner | Why it matters |
|---------|-----------|----------------|
| **n8n** | Workflow automation with AI nodes | 70k+ stars; the de facto OSS alternative to Zapier/Make with native LLM steps |
| **Flowise** | Visual LangChain builder | Best for prototyping RAG apps in an afternoon |
| **Dify** | LLMOps platform with visual pipeline | Strongest in the Chinese market; ships BAAI embeddings out of the box |

**The lesson of this tier:** visual builders did NOT kill framework-based development. They serve **non-developer builders** (PMs, designers, ops) and the same workflow often gets re-built in code for production. Treat them as the "design tool" stage, not the "deploy" stage.

## Scenario 5 — Vertical / domain-specific (3 projects)

The "agent that does ONE thing well" tier. The hottest growth area.

| Project | One-liner | Why it matters |
|---------|-----------|----------------|
| **StoryForge** | Long-form fiction writing with style DNA | Most mature 7-stage creative workflow; 52 classic author styles |
| **NOVIX** | Multi-agent novel writing with context engineering | Best in class for long-form continuity; wiki-import for fanfiction |
| **DeepResearch-style agents** | "Read 50 papers, write a survey" | The first vertical to ship to >1M users; still rough edges |

**The lesson of this tier:** the future of agents is **vertical**, not horizontal. The generalists (Day 13) provide the substrate; the verticals (Day 14) are where the value gets captured. Expect every "AI X" startup in 2026-2027 to be a vertical agent with a thin generalist shell.

---

## Cross-cutting observations

### 1. MCP is now table stakes

**13 of the 16** projects above support MCP either natively or via a first-party adapter. The 3 that don't (OpenAI Deep Research, Manus, Aider) have it on the roadmap. The protocol wars of 2025 (MCP vs OpenAI function-calling vs Anthropic tool-use) ended: **MCP won the local-tools layer**. Function-calling is still the wire format for hosted APIs.

### 2. Skills are the new plugins

**8 of the 16** have a "skills" or "extensions" mechanism (LangGraph tools, CrewAI tools, Continue's slash commands, StoryForge methodology plugins). Skills beat raw code-as-config because they're **model-readable** — the model loads the skill description and decides when to use it. The same shift that made functions beat raw strings in 2023 is now happening at the package level.

### 3. Memory is the unsolved problem

Of the 16, only **Letta, StoryForge, and NOVIX** have a serious answer to "remember across sessions". Everyone else resets. The industry will fix this in 2026 H2, but right now if you want a 30-day conversation you'll build it yourself.

### 4. The Chinese ecosystem is leading on UX

**Manus, Dify, StoryForge, and the data-lens-skill ecosystem** all ship UX that the English-speaking ecosystem hasn't matched. This is partly because Chinese users tolerate complexity earlier (MCP, multi-agent), and partly because the Chinese LLM stack (Qwen, DeepSeek, Doubao) has been aggressively agent-tuned.

## What we left out (and why)

- **Bolt, v0, Lovable** — they are wrappers around proprietary model stacks; not much design lesson.
- **Devin** — closed source; we can't review the internals.
- **Smol-developer, AutoGPT (original)** — abandoned or in maintenance mode; not representative of 2026.
- **BabyAGI** — historically important; design superseded.
- **GenericAgent** — strong on context engineering but low adoption; watch this space.

## Our take

If you are **starting a new agent project in 2026.05**, the path is: pick a vertical (Scenario 5), build on a generalist substrate (Scenario 3), expose via MCP so any host can use it, ship Skills so the model can use it well, and treat memory as your moat. The horizontal agents will commoditize; the verticals with proprietary data + memory will not.

---
