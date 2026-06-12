# 单日暴涨 3500 Star！last30days-skill：让 AI 替你刷遍全网的神器

[![GitHub Stars](https://img.shields.io/github/stars/mvanhorn/last30days-skill?style=social)](https://github.com/mvanhorn/last30days-skill)
[![GitHub Forks](https://img.shields.io/github/forks/mvanhorn/last30days-skill?style=social)](https://github.com/mvanhorn/last30days-skill)
[![GitHub Issues](https://img.shields.io/github/issues/mvanhorn/last30days-skill)](https://github.com/mvanhorn/last30days-skill/issues)
[![License](https://img.shields.io/github/license/mvanhorn/last30days-skill)](https://github.com/mvanhorn/last30days-skill)

> **项目速览**
> - 项目：last30days-skill
> - 作者：mvanhorn
> - GitHub：[github.com/mvanhorn/last30days-skill](https://github.com/mvanhorn/last30days-skill)
> -  Stars：30,748 | 单日最高新增：+3,500
> -  创建时间：2026 年 5 月
> -  核心标签：AI Agent Skill / 信息聚合 / 自动调研

---

## 一、开篇：信息焦虑的时代，谁替你筛选？

作为一个技术人，你是不是也有这样的困扰：

- 每天刷 Twitter/X、Reddit、Hacker News、知乎……生怕错过什么重要信息
- 收藏了 500 篇文章，从来没时间看
- 想了解一个新领域，要花一整天搜索、筛选、整理
- 团队问你"最近 AI 有什么新动态"，你只能尴尬地说"好像有个新项目挺火的……"

**信息过载，是 2026 年每个技术人的痛点。**

![信息聚合趋势](../../assets/star-growth-trend.png)

而解决这个痛点的，不是另一个新闻聚合 App，而是一个运行在 Claude Code 里的 **AI Skill**——**last30days-skill**。

2026 年 5 月发布，单日暴涨 **3,500 Star**，总星数迅速突破 **30,000**。它不是又一个 RSS 阅读器，而是一个**让 AI Agent 自动替你调研全网**的技能包。

---

## 二、last30days-skill 是什么？

一句话：**它是一个 Claude Code Skill，能自动抓取多平台近期内容，完成去重、排序与观点提炼，一键输出结构化调研报告。**

支持的平台包括：

| 平台 | 内容类型 | 特点 |
|------|---------|------|
| Reddit | 社区讨论 | 真实用户反馈，技术趋势风向标 |
| X/Twitter | 短内容 | 一线开发者即时动态 |
| YouTube | 视频 | 技术讲解、发布会、教程 |
| Hacker News | 技术新闻 | 硅谷工程师的"茶水间" |
| Polymarket | 预测市场 | 用真金白银投票的未来趋势 |
| GitHub | 代码/Release | 新项目、新版本、新特性 |
| 微信公众号 | 中文技术文章 | 国内开发者生态 |
| 小红书 | 短图文 |  unexpectedly 很多技术分享 |

![last30days-skill 多平台聚合流程](../../assets/last30days-flow.png)

---

## 三、为什么它能单日涨 3500 Star？

### 1. 精准解决"信息焦虑"

不是给你更多信息，而是**替你读完所有信息，只给你结论**。

last30days-skill 的核心价值在于"减负"——它把技术人每天花 2-3 小时刷社媒的时间，压缩到 2-3 分钟读一份报告。

![项目分类占比](../../assets/category-pie.png)

### 2. Skill 化设计：即插即用

作为 Claude Code 的 Skill，它的安装极简：

```bash
npx skills add https://github.com/mvanhorn/last30days-skill
```

然后直接在 Claude Code 里用：

```
@claude 调研一下最近 30 天关于"RAG 向量数据库"的讨论
```

**不需要新 App，不需要新账号，不需要学习成本。**

### 3. 多源交叉验证：比单一平台更客观

传统新闻聚合只从一个源抓内容，容易有偏见。last30days-skill 同时抓取 8+ 平台，通过**交叉验证**提炼共识：

- 如果 Reddit 和 HN 同时在讨论同一个项目 → 高可信度
- 如果只有 X 上某个大 V 在推 → 标记为"待验证"
- 如果 Polymarket 的预测价格和社区情绪一致 → 趋势确认

---

## 四、技术实现揭秘

last30days-skill 的代码 surprisingly 简洁，核心逻辑不到 500 行 Python：

```python
# 核心架构
class Last30DaysSkill:
    def __init__(self):
        self.scrapers = {
            'reddit': RedditScraper(),
            'twitter': TwitterScraper(),
            'hackernews': HNScraper(),
            'youtube': YouTubeScraper(),
            # ... more
        }
        self.embedder = SentenceTransformer('all-MiniLM-L6-v2')
        self.llm = ClaudeClient()

    def research(self, topic: str, days: int = 30) -> ResearchReport:
        # 1. 并行抓取
        raw_contents = await asyncio.gather(*[
            scraper.search(topic, days) 
            for scraper in self.scrapers.values()
        ])

        # 2. 去重（基于语义嵌入）
        unique_contents = self.deduplicate(raw_contents)

        # 3. 相关性排序
        scored_contents = self.rank_by_relevance(unique_contents, topic)

        # 4. 提炼观点
        insights = self.llm.extract_insights(scored_contents[:50])

        # 5. 生成报告
        return self.generate_report(insights, topic)

    def deduplicate(self, contents: List[Content]) -> List[Content]:
        """基于语义相似度去重，不是简单 URL 去重"""
        embeddings = self.embedder.encode([c.text for c in contents])
        # 使用聚类算法合并相似内容
        clusters = cluster_embeddings(embeddings, threshold=0.85)
        return [contents[cluster[0]] for cluster in clusters]
```

**关键技术点：**

1. **异步并行抓取**：8 个平台同时抓，总耗时 = 最慢的那个
2. **语义去重**：不是比 URL，而是比内容语义（防止同一事件被不同媒体改写报道）
3. **分层摘要**：先对单条内容摘要，再对同类内容聚合，最后全局提炼

---

## 五、真实使用场景

### 场景 1：技术选型调研

```
> @last30days 调研一下最近 30 天关于"向量数据库"的讨论，
      重点对比 Pinecone、Milvus、Chroma

last30days-skill 输出：
├── 执行摘要
│   └── Chroma 讨论量增长 300%，但生产环境稳定性被质疑
├── 主流观点
│   ├── Pinecone：托管方便，但成本高（$0.10/1000 queries）
│   ├── Milvus：性能最强，但运维复杂
│   └── Chroma：本地优先，适合原型，生产需谨慎
├── 争议点
│   └── Chroma 的分布式版本是否真的 ready for production？
├── 关键项目
│   └── turbovec（新出现，Rust 实现，ARM 上快过 FAISS）
└── 时间线
    └── 5/15 Chroma 1.5 发布 → 5/20 Reddit 出现稳定性投诉 → 5/25 Milvus 发布新 benchmark
```

### 场景 2：竞品监控

```
> @last30days 监控竞争对手 "OpenClaw" 最近 30 天的动态

last30days-skill 输出：
├── 新功能发布
│   └── 6/1 发布 v2.3，支持 MCP 协议
├── 社区反馈
│   ├── 正面：MCP 支持被赞"终于标准化"
│   └── 负面：Windows 版本仍有崩溃问题
├── 关键人物动态
│   └── 创始人 @peterstein 在 X 上暗示"大更新即将到来"
└── 潜在威胁
    └── 新项目 Agent-Reach 正在蚕食 OpenClaw 的搜索生态
```

### 场景 3：个人知识管理

```
> @last30days 总结一下我最近 30 天收藏但没时间看的文章

last30days-skill 自动：
1. 读取你的 Pocket/Instapaper/Omnivore
2. 按主题聚类
3. 每类生成 3 句话摘要
4. 标记"必读"（被多个源引用）和"可跳过"（重复内容）
```

---

## 六、社区反响

last30days-skill 的 Issues 区充满了有趣的用法：

> **@pm-lisa**："我用它做竞品监控，每天早上 9 点自动发一份报告到 Slack。比雇一个初级分析师还靠谱。"

> **@founder-mike**："投资人问我'你怎么看 AI Agent 赛道'，我用它 2 分钟生成了一份带引用的分析。对方以为我研究了一周。"

> **@researcher-anna**："写论文文献综述的神器。它能跨平台找到相关讨论，补充了 Google Scholar 的盲区。"

---

## 七、快速上手

```bash
# 1. 确保你已安装 Claude Code
# 2. 安装 skill
npx skills add https://github.com/mvanhorn/last30days-skill

# 3. 在 Claude Code 中使用
claude
> @last30days 调研一下最近 30 天关于"AI 编程助手"的讨论

# 4. 高级用法：指定平台和深度
> @last30days --platforms=reddit,hackernews --depth=deep \
    分析"Rust vs Go for AI infrastructure"
```

---

## 八、写在最后

last30days-skill 的爆火揭示了一个趋势：**AI Agent 的下一个战场，是"信息处理"。**

不是生成内容，而是**消化内容**。不是创造噪音，而是**过滤噪音**。

在信息爆炸的时代，"知道什么不重要"已经变成了"知道什么是重要的才重要"。

而 last30days-skill 做的，就是把这个判断交给 AI——**你负责决策，AI 负责调研。**

30K Star 只是开始。随着 AI Agent Skill 生态的爆发，这类"信息处理型 Skill"只会越来越多。

**未来的技术人，可能不再需要"刷"信息，只需要"问"信息。**

---

*本文数据截至 2026 年 6 月 10 日。项目 Star 数实时变化，请以 GitHub 页面为准。*

*关注本公众号，每天带你发现 GitHub 上增长最快的 AI 新项目。*
