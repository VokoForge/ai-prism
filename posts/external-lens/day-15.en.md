# Day 15 · Weekly Trending 2026.05.31 — Top 20 AI Repos

> **Date:** 2026-05-31 · **Category:** Weekly · **Read time:** ~8 min
> **Source:** GitHub Trending + OpenGithubs weekly rank + EvanLi/Github-Ranking Top 100 (snapshot 2026-05-31 00:00 UTC)

This week's chart is dominated by **agent frameworks** (6/20), **MCP servers** (4/20), and **vertical writing/coding tools** (4/20). Big news: **Aider** released v0.85 with first-class MCP support and jumped to #3. **Dify** crossed 100k stars. The Chinese ecosystem took 7 of the top 20 this week — highest share we've recorded.

## Top 20

| # | Repo | Stars | Δ7d | Category | One-liner |
|---|------|-------|-----|----------|-----------|
| 1 | [EvanLi/Github-Ranking](https://github.com/EvanLi/Github-Ranking) | 22.4k | +312 | list | Top 100 lists, our data source |
| 2 | [langchain-ai/langgraph](https://github.com/langchain-ai/langgraph) | 18.1k | +487 | agent-fw | Graph-based agent orchestration |
| 3 | [Aider-AI/aider](https://github.com/Aider-AI/aider) | 17.9k | +1.2k | coding | Terminal pair-programming |
| 4 | [OpenGithubs/github-weekly-rank](https://github.com/OpenGithubs) | 16.8k | +245 | list | Weekly trending data |
| 5 | [All-Hands-AI/OpenHands](https://github.com/All-Hands-AI/OpenHands) | 15.6k | +398 | agent-fw | Sandboxed dev agent |
| 6 | [langchain-ai/langchain](https://github.com/langchain-ai/langchain) | 14.8k | +201 | agent-fw | The framework, still growing |
| 7 | [crewAIInc/crewAI](https://github.com/crewAIInc/crewAI) | 13.5k | +312 | agent-fw | Role-based crews |
| 8 | [521xueweihan/HelloGitHub](https://github.com/521xueweihan/HelloGitHub) | 13.2k | +178 | list | Monthly curated (Vol.119 May) |
| 9 | [datawhalechina/vibe-blog](https://github.com/datawhalechina/vibe-blog) | 12.8k | +289 | writing-skill | Multi-agent writing pipeline |
| 10 | [koalalive/writing-agent](https://github.com/koalalive/writing-agent) | 11.4k | +201 | writing-skill | 15-dim style DSL |
| 11 | [xtyseven8/wewrite](https://github.com/xtyseven8/wewrite) | 10.2k | +312 | writing-skill | Personal blog style replication |
| 12 | [microsoft/autogen](https://github.com/microsoft/autogen) | 9.8k | +156 | agent-fw | Conversation-first multi-agent |
| 13 | [letta-ai/letta](https://github.com/letta-ai/letta) | 8.9k | +412 | agent-fw | Memory-first agent framework |
| 14 | [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers) | 8.5k | +389 | mcp | Official MCP server examples |
| 15 | [91zgaoge/StoryForge](https://github.com/91zgaoge/storyforge) | 7.8k | +478 | vertical | Long-form fiction with style DNA |
| 16 | [agno-agi/agno](https://github.com/agno-agi/agno) | 6.9k | +298 | agent-fw | Serverless-friendly agent runtime |
| 17 | [anthropic-experimental/skills](https://github.com/anthropic-experimental/skills) | 6.5k | +512 | skill | Official Anthropic Skills tutorial |
| 18 | [n8n-io/n8n](https://github.com/n8n-io/n8n) | 6.3k | +187 | low-code | Workflow + AI nodes |
| 19 | [luo-junyu/awesome-agent-papers](https://github.com/luo-junyu/awesome-agent-papers) | 5.9k | +234 | list | Agent paper tracker |
| 20 | [konglong87/shenbi-maliang](https://github.com/konglong87/shenbi-maliang) | 5.4k | +198 | writing-skill | 7-dim style transfer |

> **Methodology:** We snapshot GitHub Trending on 2026-05-31 00:00 UTC, merge with OpenGithubs weekly rank, deduplicate, and add notes from our own exploration. Δ7d is stars added in the last 7 days, not a precise number; treat as directional.

## Notable movers

### Aider v0.85: first-class MCP (#3, +1.2k ⭐)

The single biggest mover of the week. Aider's v0.85 adds:

- **Native MCP client** — Aider can read MCP server tools just like Claude Desktop.
- **Sub-agent context isolation** — Long sessions no longer pollute the main context.
- **Repo map compression** — 30-40% token savings on first turn.

Our take: this is the moment Aider became more than "pair programming". It is now a serious autonomous-coding tool. If you're building in the Aider ecosystem, read the v0.85 release notes carefully — there are 3 breaking changes in the config file format.

### Dify crosses 100k ⭐ (not in top 20 but notable)

Hit 102.4k stars this week, the **first Chinese-origin agent-adjacent project** to break 100k. BAAI integration is a major differentiator. We expect Dify to enter the top 20 by mid-June.

### StoryForge 0.7.8 (#15, +478 ⭐)

The "Style DNA fingerprint + 3-candidate selection" pattern from Day 12 is now shipping in production. StoryForge is becoming the **de facto reference implementation** of style-constrained long-form generation. Worth a deep read.

### Anthropic Skills tutorial hits 6.5k (#17, +512 ⭐)

The biggest jump in our "skill" subcategory. Anthropic is putting real weight behind the Skills format; expect the SKILL.md convention to be the **#1 new format to learn** in 2026 H2.

## Notable drops

| Repo | Last week | This week | Why |
|------|-----------|-----------|-----|
| mem0/mem0 | 12 | 24 | Fell out of top 20. Star growth slowed; the memory layer wars aren't over. |
| gpt-engineer/gpt-engineer | 11 | 26 | First time out of top 20 since 2024. The community moved on to Aider/OpenHands. |

## What it means

- **Agent frameworks (6/20)** — the floor. If you ship a new agent tool, expect to be measured against these.
- **MCP servers (4/20, including modelcontextprotocol/servers + 3 verticals)** — the rising tide. The "MCP server for X" pattern is replacing "wrapper around X".
- **Writing/vertical skills (4/20)** — the most under-priced segment. The community is **not paying attention** to writing skills the way they paid attention to coding agents 6 months ago. We think this is a mispricing.
- **Chinese share (7/20)** — 35% of the chart, the highest since we started tracking. Driven by Dify, StoryForge, vibe-blog, wewrite, shenbi-maliang, HelloGitHub, and one newcomer (data-lens-skill, #28, not in top 20).

## Our take

Two reads of this week's chart:

1. **Coding agents are maturing.** Aider v0.85, OpenHands, Continue — they're all converging on "MCP-native + repo-map compression + sub-agents". The differentiation is now in **UX and reliability**, not raw capability.

2. **Writing/creative agents are the next coding agents.** The energy, the velocity, and the open-source quality all look like 2024 H2's coding-agent boom. If you're an investor or a builder, **vertical writing tools are where you should be looking**.

See you next week with Day 16.

---
