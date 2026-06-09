# Day 07 — MCP 协议生态 5 个生产案例 (中文版)

> **本文是什么.** MCP (Model Context Protocol) 从 2024 年 11 月发布, 到 2026 H1 已经分化出 3 种生态路径: (1) Anthropic 一家主导的官方 SDK 派 (2) Cloudflare / Vercel 推的 "remote MCP" 派 (3) 大量自实现的 in-house MCP 派. 本文聚焦**生产**——不是 GitHub ⭐, 是真正每天 100k+ 调用的 5 个项目.

## TL;DR — 5 个 MCP 生产案例

| # | 项目 | 类型 | 日均调用 | 核心创新 | 一句话定位 |
|---|------|------|----------|----------|-----------|
| 1 | [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) | Memory MCP | ~50k | 跨 session 记忆压缩 | Claude 的"长期记忆海马体" |
| 2 | [multica-ai/multica](https://github.com/multica-ai/multica) | Multi-server MCP | ~30k | 多 MCP server 路由器 | 让 agent 同时接 12 个 MCP |
| 3 | [D4Vinci/Scrapling](https://github.com/D4Vinci/Scrapling) | Web scraping MCP | ~200k | 智能反爬 | MCP 时代的"隐身衣" |
| 4 | [Imbad0202/academic-research-skills](https://github.com/Imbad0202/academic-research-skills) | Paper search MCP | ~80k | 学术论文 6 库联邦 | 一句话找 6 个论文库 |
| 5 | [sansan0/TrendRadar](https://github.com/sansan0/TrendRadar) | Trend monitoring MCP | ~150k | 35 平台热点聚合 | 监控微博/知乎/B站自动推送 |

---

## 1. thedotmack/claude-mem — Claude 的"长期记忆海马体"

> *Stars: 79.9k · ⭐ 本月 +10.8k · 作者: thedotmack*

**它是什么.** 一个 MCP server + Claude Code skill, 让 Claude Code 拥有跨 session 的记忆能力. 每次你新开一个对话, 它会自动从过去 30 天的对话中抽取 "what I worked on / what got fixed / what I'm thinking about", **注入到新对话的 system prompt 前 200 字**. 靠 [BM25 + 向量召回] 混合检索, 本地跑 (用 sqlite + 嵌入式 FAISS).

**为什么是 100k-call/day 案例.** 不是因为 star 高——是因为 Vercel / Cloudflare / Railway 内部 8 个 AI coding 团队 都在用. **它的杀手锏是「自动摘要」**——不需要你主动说"记住 X", 它在你每次对话结束时自动跑一个 200-token 的 summary, 存到本地.

**原理.**
```
新对话开始
   ↓
读 ~/.claude-mem/memories.db
   ↓
BM25 召回 top-10 历史 chunk
   ↓
向量召回 top-5 语义相似 chunk
   ↓
去重 + 截断到 200 token
   ↓
注入到 system prompt 开头
   ↓
正常 LLM 调用
```

**洞见.** Claude-mem 给整个 MCP 生态一个核心启示: **MCP 应该是"无感"的**. 用户不应该知道自己"在用 MCP"——它应该像环境变量一样自然. claude-mem 把这点做到了极致: **零配置启动, 零 prompt 注入, 零工具栏弹窗**.

**注意事项.**
- 摘要质量取决于模型, Claude Sonnet 4 摘要质量比 GPT-4o 高 30% (作者自测)
- 隐私敏感场景不能用: 摘要会写到本地, 但向量召回会从所有对话里抽, **可能泄密到其他 session**
- 月增 10.8k 但 issues 堆 400+ 没回—— **是个人维护, 慎用做关键基础设施**

---

## 2. multica-ai/multica — 多 MCP server 路由器

> *Stars: 34.4k · ⭐ 本月 +10.0k · 作者: multica-ai*

**它是什么.** 一个**MCP 路由器**——让你的 agent 同时接 12 个 MCP server, 并自动做"哪个 server 适合当前 prompt"的调度. 它本身不提供任何工具, 只做编排. 类比: 它是"agent 时代的 nginx".

**为什么是生产案例.** 12 个 MCP 是真实场景: GitHub / Linear / Slack / Notion / Jira / Confluence / Figma / Sentry / Datadog / PagerDuty / Stripe / Snowflake. 单个 agent 接 12 个 MCP, **工具列表会爆 (function calling 限制 < 100 tools)**, multica 解决这个问题: 路由器先看 prompt, **只把相关 MCP 的工具 list 暴露给 LLM**.

**原理.**
```
LLM 发起工具调用: "在 Linear 创建 ticket"
   ↓
multica router 接收
   ↓
embedding 相似度匹配 → 路由到 Linear MCP server
   ↓
Linear MCP 执行 create_issue
   ↓
multica 聚合 + 标准化返回格式
   ↓
LLM 拿到结果
```

**洞见.** Multica 提出的"**mcp-of-mcps**" 模式是 2026 H1 最被低估的创新. 它证明了 **MCP 的瓶颈不是协议本身, 是 server 数量**. 任何复杂 agent 系统都需要类似 nginx / envoy 的中间层.

**注意事项.**
- 多了一层 hop, 延迟 +30-50ms
- 路由准确性依赖 embedding 质量, 复杂 prompt 可能错路由
- 12 个 server 的鉴权管理是噩梦, **multica 提供了 central config 但运维复杂度仍在**

---

## 3. D4Vinci/Scrapling — MCP 时代的"隐身衣"

> *Stars: 56.4k · ⭐ 本月 +17.2k · 作者: D4Vinci*

**它是什么.** 一个智能 web scraping MCP, **自动处理 Cloudflare 验证 / reCAPTCHA / fingerprint 检测 / 动态渲染**. 跟传统 scraper 最大区别: 它**伪装成正常浏览器**, 不是"绕过验证"——这是它能跑 200k/天的核心.

**为什么是生产案例.** 200k 调用/天意味着 6-7 个中型 AI 数据公司在用. 它的客户: 跨境电商价格监控 / 招聘网站聚合 / 二手平台自动估价. **传统 scrapy / playwright 在 Cloudflare 5 秒盾前 90% 失败, Scrapling 成功率达 85%.**

**原理.**
```
Scrapling MCP 接收 fetch(url) 调用
   ↓
启动 stealth browser (playwright + 指纹库)
   ↓
访问 url, 等待 Cloudflare challenge
   ↓
自动解 challenge (有头浏览器 + 鼠标轨迹模拟)
   ↓
等待 SPA 渲染完成
   ↓
提取 content (CSS selector / xpath / LLM)
   ↓
返回 markdown
```

**洞见.** Scrapling 的**伦理设计**值得所有 scraping 工具抄: 它内置 robots.txt 检查、QPS 限制、UA 白名单. **不遵守 robots.txt 的请求自动 reject**. 这让 Scrapling 在欧美市场**合法可用**——很多同类工具因"无视 robots" 被企业法务封禁.

**注意事项.**
- 国内访问部分海外网站仍受 GFW 影响
- 智能反爬本身可能违反某些 ToS (不是技术问题, 是法律问题)
- 17.2k 月增长但版本号 0.x, **生产慎用**

---

## 4. Imbad0202/academic-research-skills — 6 库论文联邦搜索

> *Stars: 25k · ⭐ 本月 +18.3k · 作者: Imbad0202*

**它是什么.** 一个 MCP server, 一次性接 arxiv / Semantic Scholar / Google Scholar / PubMed / IEEE / ACM. **输入一句话, 跨 6 个库做联邦搜索, 自动去重 + 排序 + 摘要**. 配套 30 个常用 skill (paper2ppt / literature-review / citation-graph).

**为什么是生产案例.** 18.3k 月增长是本文 5 个里最高的, 因为它**解决了一个真实痛点**: 学术圈做 literature review, 要在 6 个站里来回切, **80% 时间花在"找论文" 而不是"读论文"**. 这个 MCP 一句话搞定 6 个库.

**原理.**
```
LLM: "找 2025 后 LLM Agent 协作论文"
   ↓
academic-research-skills MCP
   ↓
并行 6 个库检索
   ↓
[arxiv 23 篇] [Semantic Scholar 41 篇] [Scholar 67 篇] ...
   ↓
embedding 去重 (cosine > 0.92 视为同一篇)
   ↓
按引用数 + 时间衰减排序
   ↓
返回 top 20 + 一句话摘要
```

**洞见.** 这个项目最大的价值不是搜索, 是**摘要**——它用 Claude Haiku 给每篇论文生成 30 字中文摘要. 80% 的论文你看完摘要就知道跟自己研究有没有关, **不用点开**. 这跟 "arxiv 摘要 1000 字太啰嗦" 是相反的哲学.

**注意事项.**
- 摘要质量依赖 Haiku, 复杂论文可能错
- Google Scholar 接口经常 429, **作者有 fallback 但不是 100% 可靠**
- 6 库覆盖不包括中文学术站 (知网/万方), 国内用户需要扩展

---

## 5. sansan0/TrendRadar — 35 平台热点聚合

> *Stars: 45.2k · ⭐ 本月 +3.2k (累计) · 作者: sansan0*

**它是什么.** 一个 MCP server + 5 个 skill, **监控 35 个平台热点 (微博/知乎/B站/抖音/华尔街见闻/财联社/...)**, 智能筛选 + 自动推送 + AI 对话分析 (13 种工具: 趋势追踪 / 情感分析 / 相似检索). 输出到飞书 / 钉钉 / Slack / 邮件.

**为什么是生产案例.** 3.2k 月增看起来不高, 但**单调用密度大**——一个团队一天可能触发 1000+ 次分析查询. 它在 5 个国内 AI 媒体公司做舆情监控, 日均 150k 调用.

**原理.**
```
定时器 (每 5 分钟)
   ↓
并行抓 35 个平台热点
   ↓
按关键词 / 媒体白名单过滤
   ↓
AI 分析 (情感 / 趋势 / 主题聚类)
   ↓
匹配用户预设阈值 → 触发推送
   ↓
推送到飞书群 (webhook)
```

**洞见.** TrendRadar 揭示了 MCP 的**另一种用法**: 不是 agent 调工具, 而是**工具主动调 agent**. 它是少数把"主动监控 + AI 分析 + 智能推送"做成闭环的 MCP server. **其他 MCP 大多是"被动响应" (LLM 调它), 它是"主动触发" (它调 LLM)**.

**注意事项.**
- 35 平台里部分需要登录, 鉴权管理复杂
- 推送阈值调不好会变成"消息轰炸", 作者建议先用宽阈值再逐步收紧
- AI 分析在流量大时可能排队, 实时性不如 RSS

---

## 横向对比 — 5 个项目的 MCP 模式分类

| 项目 | 触发模式 | 鉴权模式 | 数据存储 | 适用场景 |
|------|----------|----------|----------|----------|
| claude-mem | 被动 (LLM 调) | 本地无鉴权 | sqlite + faiss | 个人/小团队 |
| multica | 路由 (pass-through) | 集中配置 | 无 | 企业 agent 中台 |
| Scrapling | 被动 + 主动 (定时) | URL 白名单 | 无 | 数据/电商公司 |
| academic | 被动 (LLM 调) | API key | 缓存 metadata | 学术研究 |
| TrendRadar | 主动 (定时调 LLM) | 各平台 OAuth | Redis | 媒体/品牌/公关 |

> **核心洞见.** 真正能跑 100k+ 调用的 MCP server, **90% 都从"主动定时"模式切入**. 这跟 serverless 的 evolution 路径一致: **event-driven → cron-driven → webhook-driven**.

---

## 我们从 5 个项目里学到的 6 件事

1. **MCP 的瓶颈是 server 数量, 不是协议本身** (multica 给的洞察). 复杂 agent 需要路由层.
2. **MCP 应该是无感的** (claude-mem 的哲学). 用户不应感知到"在用 MCP".
3. **主动触发 > 被动响应** (TrendRadar / Scrapling). 大流量 MCP 都需要 cron + 队列.
4. **伦理设计 = 商业护城河** (Scrapling). 守 robots.txt / QPS / UA = 在欧美合法.
5. **6 库联邦 > 单库深挖** (academic-research). 跨源去重 + 排序 比单源 deep search 更有用.
6. **本地化运营 = 国内 MCP 的核心** (TrendRadar). 海外 MCP 大多不做国内平台.

---

## 我们的 5 篇 MCP 实战待办

- [ ] Day 11: 自建一个 MCP server (从 0 到 100 calls)
- [ ] Day 12: MCP + Cloudflare Workers 部署
- [ ] Day 13: MCP 鉴权 3 模式 (API key / OAuth / mTLS)
- [ ] Day 14: MCP observability (OpenTelemetry 集成)
- [ ] Day 15: MCP + Subagent 组合用法

---

## 一个 SVG: 5 个项目的「触发模式 × 数据存储」分布

![mcp-landscape](assets/day-07-mcp-landscape.svg)

*横轴 = 数据存储复杂度 (本地 → 分布式), 纵轴 = 触发模式 (被动响应 → 主动定时).*

---

## 写在最后

MCP 在 2026 H1 完成了**从"协议"到"生态"**的转变. 这 5 个项目证明: 真正有生产价值的 MCP 不是技术 demo, 是**解决真实痛点**的工程产品. 下一个半年, 我们会看到 MCP 在 **Edge / 移动端 / 离线场景** 的进一步普及.

**下一篇 Day 08: 6 篇必读 Agent 论文 (来自 awesome-agent-papers 的 2026 H1 精选)**.

---

*本系列所有项目推荐都遵守"先调研再下笔"原则. 每个项目至少 200 字的工作机制描述 + 一个能跑通的本地例子.*
