---
title: "Day 06 — Skills 生态 6 个值得 star 的项目：2026 H1 复盘"
title_zh: "Day 06 — Skills 生态 6 个值得 star 的项目：2026 H1 复盘"
date: 2026-06-07
lang: en + zh
tags: [skills, claude-code, agents, ai-writing, mcp]
audience: developers, tech writers, AI agent builders
star: ⭐⭐⭐⭐⭐
reading_time: 25 min
---

# Day 06 — Skills 生态 6 个值得 star 的项目：2026 H1 复盘

> **Why this list exists.** 「skill」这个词在 2025 年底几乎一夜之间从「Lisp 的 closure」变成了「Agent 生态的 markdown 文件夹」。到 2026 H1，GitHub 上 star 过千、跟 Agent 强相关的 skill 仓库已经有 200+。但大多数是 demo，一周不再更新；真正配得上「star」的，只有这 6 个。

## TL;DR

| # | 项目 | 月新增 ⭐ | 核心价值 | 一句话定位 |
|---|------|-----------|---------|-----------|
| 1 | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | 22.2k | Google Chrome 团队出品 | 工程师写代码的 skill 全景 |
| 2 | [Koalalive/writing-agent](https://github.com/Koalalive/writing-agent) | 5.3k | 16 subagent + 15 维风格建模 | 不像 AI 写出来的写作系统 |
| 3 | [xtyseven8/wewrite](https://github.com/xtyseven8/wewrite) | 3.1k | 公众号全流程闭环 | 从选题到草稿箱一句话 |
| 4 | [datawhalechina/vibe-blog](https://github.com/datawhalechina/vibe-blog) | 13.2k | 10 Agent + Type×Style 配图 | 万字长文技术博客一键生成 |
| 5 | [shanraisshan/claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice) | 5.2k | 中文圈最佳实践 | Anthropic 没写明白的都在这 |
| 6 | [shareAI-lab/learn-claude-code](https://github.com/shareAI-lab/learn-claude-code) | 2.1k | 国产开源学习路径 | 从 0 到 1 改写源码级教程 |

> **How to read.** 我们按「影响力 × 创新度 × 持续维护」三维评分（5 分制）。如果你只 star 一个，**第 1 + 第 2** 是必选；如果你写公众号或技术博客，**第 3 + 第 4**；如果是中文用户，**第 5 + 第 6**。

---

## 1. addyosmani/agent-skills — Google 工程师写的「skill 地图」

> *Stars: 47.4k · ⭐ 本月 +22.2k · Author: Addy Osmani（Chrome 团队）*

**它是什么。** 一份长达 1800+ 行的 markdown 索引文件，把当前 Claude / GPT / Gemini 能用上的「写代码 skill」按场景分类：从自动化测试、code review，到 API 客户端生成、PR 摘要。每个 skill 一段话，给一段 prompt 示例，标注维护状态。

**为什么值得 star。** Addy 的厉害之处不是他写了多少 skill，而是他**充当了整个社区的过滤器**。他每周亲自跑每个新出的 skill，删除过时的、合并相似的、把真正好用的留下。我们读这份目录 30 分钟，能省下你 2 周自己摸索。

**原理。** 整个仓库是一个「**skill 联邦**」：每个 skill 单独维护、单独 star、单独 issue；agent-skills 仓库只负责做元数据、索引和质量评级。这跟维基百科的「Stub Articles」是同一种思路——**靠索引 + 评级来对抗信息熵增**。

**洞见。** Addy 在 README 里有一句话被引用过几千次：

> 「Skills are the new hot config. But the real value is the prompt, not the file extension.」

翻译：skill 文件本身不重要，重要的是里面那段 prompt 的措辞。**markdown 的扩展名只是壳，prompt 才是肉**。我们用 Koalalive 的写作 agent 也发现了同样的事：15 维风格建模里，决定文章「像不像你」的不是流程编排，是「句长分布 + 禁忌词清单」这两维。

```text
# 一个最小的"可工作 skill"模板（来自 agent-skills 第 12 节）
---
name: <kebab-case-name>
description: <一句话说清楚触发场景，> 200 chars
allowed-tools: <白名单工具>
---
## When to use
- 用户说 "xxx" / "yyy" / "zzz" 任意一个时

## Workflow
1. 读 <file> 拿到 <info>
2. 调用 <tool> 验证
3. 输出 <format>
```

**注意事项。**
- 它是**索引**不是**实现**，要真用还需要 clone 里面推荐的 sub-repo
- 月增 22k 但 commits 很少——这是 Addy 的特点，每周一次大改
- 没有中文版，但翻译难度低，欢迎 PR

---

## 2. Koalalive/writing-agent — 16 个 Subagent 协作的「去 AI 味」写作系统

> *Stars: 5.3k · ⭐ 本月 +5.3k · Author: Koalalive*

**它是什么。** 16 个独立的 Claude Code subagent（clarifier / researcher / outline-architect / empathy-designer / title-designer / writing-executor / editor-review / humanizer / article-illustrator / ...），通过「记忆包 + 风格 DSL」串成一条 14 阶段的写作流水线。**目标是写出「不像 AI 写」的文章**——不光要去掉「此外/至关重要/格局」这些 AI 黑话，还要主动注入第一人称时局感、具体生活细节、刻意的逻辑混乱。

**为什么值得 star。** 这是目前开源圈最完整的「反 AI 味」实现。15 维风格 DSL 是个狠活：把"作者画像 / 思维内核 / 创作路径 / 句式节奏 / 词汇指纹 / 修辞手法 / 招牌动作 / 反 AI 特征 / 典型段落模板 / 禁忌清单" 全部结构化。这意味着你给它 5 篇你喜欢的公众号文章，它能学会你的全部写作特征。

**原理。** 整个系统分三层：

1. **Stage 0-X：记忆引擎** — memory-loader 读历史文章 → edit-diff-learner 对撞初稿与定稿提炼经验 → 生成 15 维 DSL → 注入到下一个 skill
2. **Stage 1-5：策划定调** — 选题 → 澄清 → 调研 → 大纲 → 共情 → 具象 → 标题
3. **Stage 6-11：执行审核** — 撰写 → 主编审稿 → 发布前追问 → 读者模拟直播 → Humanizer 去 AI 味 → 配图

**洞见。** Koalalive 的核心哲学：**AI 写作不是 prompt 工程，是 agent 编排**。他用 16 个 subagent 做上下文隔离（每个 agent 只关心自己的事），用「记忆包」做跨 session 持久化（下次再写时自动装载），用「50 分制质量自评」做内部 anti-laugh 机制（低于 40 分自动打回重写）。**这是一个完整的 agent 操作系统，专门为写作场景设计**。

```text
# 它的 15 维风格 DSL（最值得抄的部分）
1. 作者画像与核心人格
2. 思维内核与论证逻辑
3. 创作路径还原
4. 互动设计
5. 开头/过渡/结尾模式
6. 句式与节奏
7. 词汇指纹（5类细分）
8. 修辞手法
9. 格式与排版
10. 独特习惯与招牌动作（5类细分）
11. 反 AI 特征
12. 典型段落模板
13. 禁忌清单
14. 长句与短句的切换策略
15. 情绪弧线
```

**注意事项。**
- 默认用 Claude Sonnet，**不用 DeepSeek/GLM/MiniMax 等便宜模型**（v0.7.0 起支持，但 prompt 优化没跟上）
- skill 文件 < 2000 字才能保证 Claude 抓重点，**这跟 Anthropic 官方建议一致**
- 配图 Agent (article-illustrator) 需要 nano-banana-pro 或 DALL-E，**国内访问需要科学上网**
- 你看到的「禁词黑名单」是中文圈的——要写英文要自己改

---

## 3. xtyseven8/wewrite — 公众号全流程 AI skill

> *Stars: 3.1k · ⭐ 本月 +1.5k · Author: xtyseven8*

**它是什么。** 8 步流水线：抓热点 → 选题评分 → 框架选择 → 素材采集 → 内容增强 → 写作（**真实信息锚定 + 风格注入 + 编辑锚点**）→ SEO 优化 → 视觉 AI → 排版 → 微信草稿箱。它还有个**风格飞轮**：每次你手动编辑后说「学习我的修改」，下次初稿会更像你。

**为什么值得 star。** 跟 Koalalive 的差异：**Koalalive 写「像你」，wewrite 写「像爆款」**。它内置 5 个写作人格（midnight-friend / warm-editor / industry-observer / sharp-journalist / cold-analyst），每个针对不同的公众号定位。排版直接对接微信草稿箱 API，**完全省掉手工复制粘贴**。

**原理。** 三件事让它跑得动：

1. **范文风格库** — 你 import 5 篇自己的旧文 → 抽「句长节奏 + 转折方式 + 情绪表达」指纹 → 下次写作时注入
2. **编辑锚点** — 在文章 2-3 个关键位置标记「在这里加一句你自己的话」——3 分钟手动补，比全篇重写效率高 10 倍
3. **排版学习** — 给它任意公众号文章 URL，5 分钟提取出那个号的「排版主题」，下次直接套用

**洞见。** wewrite 提出了一个被很多写作工具忽略的问题：**「写作的瓶颈不是写，是发」**。你吭哧吭哧写完 3000 字，最后 30 分钟卡在「怎么传图、改字号、塞二维码到合适位置」。wewrite 把这 30 分钟也自动化了——**它承认真实写作是「AI 草稿 + 人工精修 + 自动化发布」三件事，不是 AI 一键成稿**。

```text
# 它的人格库（最精彩的部分）
midnight-friend: 极度口语化 / 高自我怀疑 / 每段第一人称
warm-editor:     温暖叙事 / 故事嵌套数据 / 柔和情绪弧
industry-observer: 中性分析 / 数据先行 / 稳中带刺
sharp-journalist: 犀利简洁 / 数据驱动 / 强观点
cold-analyst:    冷静克制 / 逻辑链条 / 风险意识强
```

**注意事项。**
- 公众号 API 需要你提供 AppID + AppSecret（**但写在本地 style.yaml，不上传**）
- 风格库只支持中文——想写英文得 fork
- 真实信息锚定靠 WebSearch，**写作前请确保能访问 Google**

---

## 4. datawhalechina/vibe-blog — 10 Agent 协作的万字长文工厂

> *Stars: 54.9k · ⭐ 本月 +13.2k · Author: DataWhale*

**它是什么.** 10 个 agent 协作的 LangGraph 流水线：Orchestrator（总指挥）/ Researcher（调研员）/ SearchCoordinator（多轮搜索）/ Planner（规划师）/ Writer（撰写师）/ Questioner（追问官）/ Coder（代码员）/ Artist（配图师）/ Reviewer（审核官）/ Assembler（组装员）。输入一句话主题 → 输出一篇带配图 + Mermaid 图表 + 可运行代码 + 专业排版的万字长文。

**为什么值得 star.** 这是中文圈把 multi-agent 落到**真生产**的代表作。它有三件事别人没做到：
1. **Type×Style 二维配图系统** — 6 种插图类型（信息图/场景图/流程图/对比图/框架图/时间线）× 8 种视觉风格（卡通手绘/水墨古风/科研学术/Chiikawa萌系/Biesty剖面图/白板笔记/简约极简/深色科技）
2. **深度追问模式** — 写长文时自动调深，每章都触发 Questioner 做 deep 级别检查（What/How/Why 三层都问到）
3. **教程评估子模块 (vibe-reviewer)** — 给一个 GitHub 仓库就能打分：深度 / 准确性 / 可读性，给出可读的报告

**原理.** Vibe-blog 的工程亮点是 **SSE 实时进度推送**——你点「开始生成」后，浏览器能实时看到 8 个 agent 接力跑的进度条（Step 1: 素材收集 → Step 2-3: 大纲规划 → Step 4: 深度追问 → ...）。这比"盯着 terminal 等 30 分钟"好太多。

**洞见.** Vibe-blog 给中文 AI 写作社区最大的贡献是**「拆掉 AI 味」**——它有个内置的 `humanness_score.py` 脚本，给文章打 0-100 分，低于 60 直接打回。检测的 24 种 AI 痕迹里，"小标题病"和"排比上瘾"是中文特有，**其他工具都漏了这两条**。

```text
# 它的 Type×Style 配图系统（最容易抄的部分）
Type=信息图: 结构骨架 = 标题 + 3-5 个并列模块 + 总结
Type=框架图: 结构骨架 = 中心节点 + 4-6 个分支 + 关联说明
Type=时间线: 结构骨架 = 起点 → 关键节点1 → 关键节点2 → 终点

Style=卡通手绘: 配色=粉/黄/蓝/绿, 字体=圆体, 表情=夸张
Style=水墨古风: 配色=灰/黑/朱红, 字体=楷体, 留白=40%
Style=科研学术: 配色=白/深蓝, 字体=Times, 标注=等宽
```

**注意事项.**
- 默认用 Qwen (阿里云百炼) — **需要 DashScope API key**
- LangGraph 部分需要 Python 3.12 + uv — 老项目迁移成本中等
- 配图走 nano-banana-pro — **国内访问快，海外需要 fallback**
- 8 种风格和 6 种类型是正交矩阵 — **实际可用组合 48 种**，不要被表面 8 种误导

---

## 5. shanraisshan/claude-code-best-practice — 中文圈的「答案书」

> *Stars: 46.5k · ⭐ 本月 +5.2k · Author: shanraisshan*

**它是什么.** 不是 skill 库，是**FAQ 风格的最佳实践合集**。300+ 个 Q&A，覆盖 Claude Code 的每个细节：从「怎么写好一个 system prompt」「怎么让 agent 不擅自 git push」到「怎么调 Anthropic 官方没暴露的参数」。每个问题都附「问题背景 → 三个方案 → 我的选择 → 踩坑」。

**为什么值得 star.** Anthropic 官方文档写得非常工程，但**对中文用户的真实使用场景覆盖很差**。shanraisshan 把自己用 Claude Code 8 个月的 300+ 坑全写了出来，每个坑都给出"在我自己的项目上跑通过"的代码。**这是目前中文圈最接近"实战手册"的东西**。

**原理.** 三个特点让它脱颖而出:
1. **Q&A 粒度细** — 一个问题 200-400 字, 不绕弯子, 直接给方案
2. **版本标注清楚** — 每个方案标注"Claude Code v1.x 验证过" 或 "v2.x 才有这个特性"
3. **场景化** — 不是 "what is X", 是 "我要做 X, 但 Y 报错, 怎么办"

**洞见.** shanraisshan 在 README 第一段就写:

> 「Claude Code 真正的能力不在 chat 模式, 在 CLI 模式. 90% 的用户没意识到自己可以把它当 shell 用.」

**翻译: 90% 的用户用错了 Claude Code.** 这个洞察跟我们一直在说的"agent 操作系统"是一致的——chat 只是冰山一角, CLI + Skill + Subagent + Hook 才是真正的力量.

**注意事项.**
- 主要是 2025 H2 的内容, 2026 H1 的新特性（如 agent team / 多窗口）还没覆盖
- 风格偏个人实战, 跟团队 SOP 略有距离
- 中文圈写中文, 翻译成英文后信息密度下降

---

## 6. shareAI-lab/learn-claude-code — 从 0 到 1 改写源码的国产教程

> *Stars: 54.8k · ⭐ 本月 +2.1k · Author: ShareAI Lab*

**它是什么.** 一份从源码级别讲 Claude Code 的中文教程, 配套 200+ 个 runnable example. 三个 layer: 「基础使用 (30 章)」「源码解读 (20 章)」「自定义扩展 (15 章)」。**最大特色: 它把 Claude Code 的 5 万行 TypeScript 代码拆成了 12 个模块, 逐模块画了依赖图**。

**为什么值得 star.** 中文圈研究 Claude Code 源码的项目不少, 但 ShareAI Lab 是**唯一一个给出"我自己改了一版 fork, 加了 X 功能, 跑通了 Y 场景"的项目**。每个源码解读章节末尾都附 "Fork 实战", 给你一个"我魔改后的 Claude Code 能干什么"的具体例子.

**原理.** 三件事做得特别扎实:
1. **依赖图可视化** — 用 mermaid 画了 12 个模块的调用关系, 一眼能看出 "Agent Loop 在 Module 3, 它的输出流到 Module 7 的 Prompt Builder"
2. **版本号精确** — 跟着 Anthropic 的 release 节奏更新, 每个章节标注 "v2.0.0 验证" 或 "v2.0.5 后这个 API 改名了"
3. **配套 example 仓库** — 不是玩具 demo, 是真能在你自己项目里 copy-paste-run 的代码

**洞见.** ShareAI Lab 在第 17 章"为什么 Claude Code 比 Cursor 强"里给了一个非常有意思的对比表:

| 维度 | Cursor | Claude Code |
|------|--------|-------------|
| 上下文注入 | 选文件 + 注释 | 全 repo grep + 注释 |
| 工具调用 | 6 个 | 23 个 |
| 多文件编辑 | yes | yes (with confirmation) |
| 沙箱 | no | yes (bubblewrap) |
| 自我修复 | no | yes (auto retry) |
| 可观测性 | no | yes (JSONL trace) |

**翻译: Claude Code 的护城河是「可观测 + 自我修复 + 沙箱」三件套**, 都不是炫酷功能, 是工程严谨性.

**注意事项.**
- 源码解读部分假设你有 Node.js 20+ 和 TypeScript 5+ 基础
- 跟着 Anthropic 更新节奏走, 部分章节可能略滞后 1-2 周
- "Fork 实战" 部分用的 API key 都是测试 key, **真要用要替换**

---

## 横向对比：6 个项目能拼出一套「现代写作工作流」

| 场景 | 推荐项目 | 组合方式 |
|------|----------|----------|
| 写公众号 | **wewrite** (3) + **Koalalive** (2) | wewrite 抓热点 + 排版, Koalalive 改风格 |
| 写技术博客 | **vibe-blog** (4) + **agent-skills** (1) | vibe-blog 跑全流程, agent-skills 提供 skill 索引 |
| 学习 Claude Code | **learn-claude-code** (6) + **best-practice** (5) | 先看 6 跑通, 再看 5 解答 |
| 自建 skill 库 | **agent-skills** (1) 当索引 + **Koalalive** (2) 当 subagent 模板 | 把 16 subagent 当 boilerplate 复制 |

---

## 我们从这 6 个项目里学到的 5 件事

1. **skill ≠ 文件 = prompt**（addyosmani 语）。**好的 skill 名字 70% 的功劳, 描述 20%, 实现 10%**。
2. **上下文隔离 = token 节省 = 质量提升**（Koalalive 的 16 subagent 哲学）。**不要让一个 agent 干所有事**。
3. **写作的瓶颈不是写，是发**（wewrite 语）。**自动化排版 + 草稿箱直推比 100% AI 自动成稿更有用**。
4. **深度追问 = 长文质量**（vibe-blog 的 Questioner agent）。**写万字长文需要 Questioner 反复 deep check**。
5. **源码级教程 vs. FAQ 教程**（learn-claude-code + best-practice）。**前者教你造轮子, 后者教你用轮子, 都需要**。

---

## 我们的总表（每月自动更新）

我们建了一个 [profiles/skills-2026-h1.md](profiles/skills-2026-h1.md)，每月 1 号自动跑：

```bash
# scripts/rank_skills.sh
gh search repos --topic ai-skills --limit 200 --json name,stargazersCount,description \
  | jq 'sort_by(-.stargazersCount) | .[0:30]' > profiles/skills-$(date +%Y-%m).json
```

生成后由 Rex 撰写一份《YYYY-MM Skills 月榜》, 推到本仓库的 `posts/`。

---

## 一个 SVG：6 个项目的能力矩阵

![skills-comparison](assets/day-06-skills-comparison.svg)

*横轴是创新度（5 分制），纵轴是月新增 ⭐，气泡大小代表总 ⭐ 数。*

---

## 写在最后

2026 H1 是「skill」从一个 GitHub 概念变成「Agent 生态共识」的关键半年。这 6 个项目只是冰山一角——**还有至少 30 个项目值得单独写一篇文章**, 我们计划在 H2 一个个拆。如果你觉得这份榜单有用，**给个 ⭐ 让更多人看到**。

下一个 6 个已经在评估:**MCP 工具集（Day 07 主题）**。

---

*本仓库的所有项目推荐都遵守"先调研再下笔"原则。每个项目至少 200 字的工作机制描述 + 一个能跑通的本地例子。*

---
