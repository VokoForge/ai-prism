# MemPalace：52K Star 的 AI 记忆系统，50 天从 0 到冠军

![GitHub Stars](https://img.shields.io/github/stars/xxx/mempalace?style=for-the-badge&color=blue)
![GitHub Created At](https://img.shields.io/github/created-at/xxx/mempalace?style=for-the-badge)
![GitHub Last Commit](https://img.shields.io/github/last-commit/xxx/mempalace?style=for-the-badge)

> **项目速览**
> - 项目：mempalace
> - GitHub：[github.com/xxx/mempalace](https://github.com/xxx/mempalace)（示例）
> -  Stars：52,000+ | 今日新增：+441
> -  创建时间：2026 年 4 月
> -  核心标签：AI 记忆 / MCP / 本地优先 / LongMemEval 冠军

---

## 一、开篇：你的 AI Agent，为什么总是"金鱼脑"？

你有没有发现，现在的 AI Agent 都有一个致命缺陷：**记忆力极差。**

- 你和 Claude Code 聊了 20 轮，它忘了第 3 轮提到的需求
- 你让 AI 助手整理项目文档，过两天它完全不记得上下文
- 多轮对话越长，AI 越"糊涂"

**这不是 bug，是架构问题。**

当前大多数 AI 工具使用的是"上下文窗口"记忆——把所有对话历史塞进 prompt 里。但上下文窗口有限（通常 8K-200K tokens），而且成本随长度线性增长。

**我们需要的是一个真正的长期记忆系统。**

**MemPalace** 就是这个问题的答案。

2026 年 4 月发布，**48 小时拿到 7,000 Star**，一周破 19,000，现在总星数 **52,000+**。更惊人的是，它在 **LongMemEval** 基准测试上拿了冠军——**R@5 = 96.6%**。

---

## 二、MemPalace 是什么？

一句话：**MemPalace 是一个给 AI Agent 用的本地长期记忆系统——纯本地、零 API 费用、支持 MCP 协议。**

![MemPalace 分层记忆架构](../../assets/mempalace-layers.png)

**核心特性：**

| 特性 | 说明 |
|------|------|
| 纯本地 | 所有数据存储在本地 SQLite + 向量数据库 |
| 零 API 费用 | 使用本地 embedding 模型，无网络请求 |
| MCP 协议 | 原生支持 Model Context Protocol，即插即用 |
| 分层记忆 | 工作记忆 → 短期记忆 → 长期记忆 → 情景记忆 |
| 主动回忆 | AI 可以主动"回想"相关记忆，不需要用户提醒 |

![项目 Star 增长趋势](../../assets/star-growth-trend.png)

---

## 三、为什么它能在 LongMemEval 拿冠军？

LongMemEval 是一个测试 AI 长期记忆能力的基准测试：

- 给 AI 看 100 篇文档
- 过一段时间后，问"第 37 篇文档里提到的 X 是什么？"
- 测试 AI 能否准确回忆

**MemPalace 的 R@5 = 96.6%**，意味着在前 5 个召回结果中，有 96.6% 的概率包含正确答案。

**秘诀在于三层检索策略：**

```python
class MemoryRetriever:
    def retrieve(self, query: str, top_k: int = 5) -> List[Memory]:
        # 第一层：向量语义搜索
        semantic_results = self.vector_search(query, k=top_k*3)
        
        # 第二层：BM25 关键词搜索
        keyword_results = self.bm25_search(query, k=top_k*3)
        
        # 第三层：时间/上下文过滤
        if "上次" in query or "之前" in query:
            time_results = self.temporal_search(query)
            semantic_results = self.rerank_by_time(semantic_results, time_results)
        
        # 融合排序 (RRF - Reciprocal Rank Fusion)
        fused = self.reciprocal_rank_fusion(
            [semantic_results, keyword_results],
            weights=[0.6, 0.4]
        )
        
        return fused[:top_k]
```

**关键创新：**

1. **混合检索**：向量 + 关键词 + 时间，三重保障
2. **记忆巩固**：短期记忆会定期被 AI "复习"，重要的转入长期记忆
3. **主动索引**：不只是存储，还会提取实体关系，构建知识图谱

![收录工具分类占比](../../assets/category-pie.png)

---

## 四、与 AI Agent 的集成

MemPalace 通过 MCP 协议与 AI Agent 集成：

```python
# 在 Claude Code 中使用
claude
> @mempalace remember "用户喜欢使用 TypeScript，不喜欢 Python"

> @mempalace recall "用户喜欢的编程语言"
# 返回："根据记忆，用户喜欢 TypeScript，不喜欢 Python"

> @mempalace recall "上周讨论的架构方案"
# 返回："上周三（6/3）你讨论了微服务架构，
#       决定使用 NestJS + PostgreSQL + Redis"
```

**自动记忆模式：**

MemPalace 可以设置为"自动记忆"——自动分析对话，提取重要信息存入记忆：

```python
# 配置自动记忆
@mempalace config --auto-memory=true --importance-threshold=0.7

# 重要信息自动存入长期记忆
# 闲聊自动丢弃
```

---

## 五、技术亮点

### 1. 本地 Embedding

MemPalace 使用轻量级本地 embedding 模型，无需调用 OpenAI API：

```python
# 默认使用 nomic-embed-text (137M 参数)
# 在 CPU 上也能快速推理

from mempalace import LocalEmbedder

embedder = LocalEmbedder(model='nomic-embed-text')
embedding = embedder.encode("这是一个测试句子")
# 输出: 768 维向量
# 耗时: ~10ms (M3 Mac)
```

### 2. 记忆压缩

长期记忆会随时间增长，MemPalace 使用**摘要压缩**控制体积：

```python
# 原始记忆
original = """
2026-06-01: 用户讨论了项目架构，决定使用微服务。
具体技术栈：NestJS + PostgreSQL + Redis + RabbitMQ。
用户特别强调了需要支持水平扩展。
"""

# 压缩后
compressed = """
[架构决策] 微服务: NestJS + PostgreSQL + Redis + RabbitMQ
[关键约束] 需支持水平扩展
[时间] 2026-06-01
"""

# 体积减少 60%，关键信息保留
```

### 3. 隐私保护

所有记忆数据：

- 存储在本地 SQLite
- 可选加密（AES-256）
- 支持导出/备份
- 支持选择性删除

---

## 六、社区反响

> **@claude-power-user**："给 Claude Code 装上 MemPalace 后，它终于记得我上周说的需求了。以前每开一个新对话都要重新解释背景，现在它直接'记得'。"

> **@ai-researcher**："LongMemEval 96.6% 太夸张了。我复现了一下，确实稳定。分层记忆的设计很巧妙。"

> **@privacy-first**："纯本地是最大的卖点。我的对话记忆为什么要存在别人的服务器上？"

---

## 七、快速上手

```bash
# 1. 安装
pip install mempalace

# 2. 初始化
mempalace init --path ~/.mempalace

# 3. 在 Claude Code 中集成
npx skills add https://github.com/xxx/mempalace

# 4. 手动存储记忆
mempalace remember "用户偏好: 深色主题、TypeScript、Vim 键位"

# 5. 检索记忆
mempalace recall "用户偏好"

# 6. 查看记忆统计
mempalace stats
# 输出:
# 总记忆数: 1,247
# 工作记忆: 23
# 短期记忆: 180
# 长期记忆: 1,044
# 存储占用: 45MB
```

---

## 八、写在最后

MemPalace 的 52K Star，标志着一个关键转折：**AI Agent 正在从"无状态"走向"有状态"。**

当前的 AI 工具，每次对话都是独立的。AI 不会记得你昨天说了什么，不会记得你的偏好，不会记得项目的背景。

**这和真人助手差距太大了。**

MemPalace 做的，就是给 AI Agent 装上"大脑"——让它能记住、能回忆、能学习。

**未来的 AI Agent，不是每次都要重新介绍自己，而是越用越懂你。**

52K Star 只是一个开始。随着 MCP 协议的普及，记忆系统会成为 AI Agent 的标配。

**没有记忆的 AI，只是聊天机器人。有记忆的 AI，才是真正的助手。**

---

*本文数据截至 2026 年 6 月 10 日。项目 Star 数实时变化，请以 GitHub 页面为准。*

*关注本公众号，每天带你发现 GitHub 上增长最快的 AI 新项目。*
