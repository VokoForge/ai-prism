# 136K Star！30+ 主流 AI 工具的系统提示词全泄露了

![GitHub Stars](https://img.shields.io/github/stars/x1xhlol/system-prompts-and-models-of-ai-tools?style=for-the-badge&color=blue)
![GitHub Created At](https://img.shields.io/github/created-at/x1xhlol/system-prompts-and-models-of-ai-tools?style=for-the-badge)
![GitHub Last Commit](https://img.shields.io/github/last-commit/x1xhlol/system-prompts-and-models-of-ai-tools?style=for-the-badge)

> **项目速览**
> - 项目：system-prompts-and-models-of-ai-tools
> - 作者：x1xhlol
> - GitHub：[github.com/x1xhlol/system-prompts-and-models-of-ai-tools](https://github.com/x1xhlol/system-prompts-and-models-of-ai-tools)
> -  Stars：136,000+
> -  创建时间：2026 年 4 月
> -  核心标签：Prompt Engineering / AI 工具 / 系统提示词 / 开源情报

---

## 一、开篇：AI 工具的黑箱里，到底藏着什么？

你有没有好奇过：

- 为什么 Claude Code 写代码总是遵循特定的格式？
- 为什么 Cursor 的 AI 回复总是先分析再给出代码？
- 为什么 Devin AI 能自主规划任务，而其他工具不行？

**答案藏在系统提示词（System Prompt）里。**

系统提示词是 AI 工具的"底层指令"——它决定了 AI 的行为模式、输出格式、安全边界。普通用户看不到它，但它无时无刻不在影响你的使用体验。

**而有人，把这些系统提示词全扒出来了。**

**system-prompts-and-models-of-ai-tools**，2026 年 4 月发布，迅速收获 **136,000 Star**，成为 GitHub 上增长最快的 Prompt Engineering 相关项目。

它收集了 **30+ 主流 AI 工具的系统提示词**，包括：

![已收录系统提示词的工具](../../assets/system-prompts-tools.png)

---

## 二、这个项目到底是什么？

一句话：**system-prompts-and-models-of-ai-tools 是一个开源情报（OSINT）项目，通过逆向工程提取主流 AI 工具的系统提示词，供开发者学习和研究。**

![项目 Star 增长趋势](../../assets/star-growth-trend.png)

**收录的工具清单（部分）：**

| 工具 | 类型 | 提示词长度 | 关键特征 |
|------|------|-----------|---------|
| Claude Code | AI 编程助手 | ~5000 tokens | 强调工具使用、文件操作、测试驱动 |
| Cursor | AI IDE | ~3000 tokens | 代码补全、重构、解释 |
| Devin AI | 自主 AI 工程师 | ~8000 tokens | 任务规划、自主执行、环境交互 |
| Windsurf | AI 编辑器 | ~4000 tokens | 实时代码生成、上下文感知 |
| GitHub Copilot | 代码补全 | ~2000 tokens | 简洁、快速、单行补全优先 |
| ChatGPT | 通用对话 | ~1500 tokens | 安全边界、拒绝策略 |
| Perplexity | AI 搜索 | ~2500 tokens | 引用要求、事实核查 |

---

## 三、为什么它值 136K Star？

### 1. 揭开了 AI 工具的"黑箱"

系统提示词是 AI 产品的核心竞争力之一。它决定了：

- AI 如何理解用户意图
- AI 如何组织输出
- AI 什么该做、什么不该做
- AI 如何处理边缘情况

**看到这些提示词，等于看到了这些产品的"底层代码"。**

### 2. Prompt Engineering 的绝佳教材

这些提示词都是顶级 AI 公司的工程师写的，代表了行业最高水平。学习它们，比自己瞎琢磨效率高 100 倍。

![收录工具分类占比](../../assets/category-pie.png)

### 3. 安全研究价值

通过分析系统提示词，研究者可以发现：

- 安全边界的设计逻辑
- 可能的越狱路径
- 数据泄露风险

---

## 四、经典提示词解析

### Claude Code 的系统提示词（节选）

```markdown
You are Claude Code, an AI assistant created by Anthropic. 
You are an expert software engineer with deep knowledge of:
- Software architecture and design patterns
- Testing methodologies (unit, integration, e2e)
- Code review best practices
- Security and performance optimization

## Core Principles

1. **Tool Use**: You have access to tools for file operations, 
   command execution, and code analysis. Use them proactively.

2. **Test-Driven**: When writing code, always consider testing.
   If tests exist, run them. If not, suggest adding them.

3. **Incremental Changes**: Make small, focused changes. 
   One logical change per step.

4. **Context Awareness**: Before modifying code, read the 
   relevant files to understand the context.

## Output Format

- For code: Use markdown code blocks with language tags
- For explanations: Be concise but thorough
- For plans: Use numbered lists or checkboxes
- Always explain WHY, not just WHAT

## Safety

- Never execute destructive commands without confirmation
- Never modify .env files or credentials
- Never delete files without explicit user request
```

**解析：**

Claude Code 的提示词有几个精妙之处：

1. **角色定义具体**：不是"你是一个助手"，而是"你是一个专家软件工程师，擅长 X、Y、Z"
2. **原则明确**：工具使用、测试驱动、增量修改、上下文感知——四条核心原则
3. **输出格式约束**：代码块、解释风格、计划格式——确保输出一致
4. **安全边界**：三条红线，明确不可为

### Cursor 的系统提示词（节选）

```markdown
You are Cursor, an AI-powered code editor. Your goal is to 
help users write, understand, and improve code efficiently.

## Interaction Style

- Be concise. Users prefer short, actionable responses.
- When suggesting code, provide the complete implementation.
- Use inline comments sparingly. Code should be self-documenting.

## Code Generation

- Follow existing code style in the project
- Use the same patterns and conventions as surrounding code
- Prefer modern language features when appropriate
- Handle edge cases gracefully

## Context

You have access to:
- Current file content
- Selected code range
- Recent edit history
- Project structure (file tree)

Use this context to provide relevant suggestions.
```

**对比分析：**

| 维度 | Claude Code | Cursor |
|------|-------------|--------|
| 角色定位 | 专家工程师 | 代码编辑器 |
| 交互风格 | 详细、解释驱动 | 简洁、行动驱动 |
| 上下文范围 | 整个项目（可主动读取） | 当前文件 + 选择 |
| 测试重视 | 高（明确要求） | 中（隐含） |
| 安全约束 | 显式列出 | 隐含 |

**关键洞察：** Claude Code 设计为"自主代理"，Cursor 设计为"增强编辑器"。这解释了为什么 Claude Code 会主动读取文件、运行测试，而 Cursor 更专注于当前编辑区域。

---

## 五、如何用这个项目的知识？

### 1. 优化你自己的 AI 应用

如果你在用 Claude API / OpenAI API 构建应用，参考这些提示词的设计：

```python
# 优化前（模糊）
system_prompt = "你是一个客服助手，帮助用户解决问题。"

# 优化后（具体，参考 Claude Code 风格）
system_prompt = """
你是 TechSupport AI，一个专业的技术支持助手。

## 专业领域
- SaaS 产品故障排查
- API 集成问题
- 账户和计费咨询

## 工作流程
1. 先确认用户的具体问题和环境信息
2. 提供分步解决方案
3. 如果问题复杂，提供官方文档链接
4. 确认问题是否解决

## 输出格式
- 步骤用编号列表
- 代码用 markdown 代码块
- 重要警告用 ⚠️ 标记

## 边界
- 不提供非官方支持的第三方集成帮助
- 不处理需要人工审核的账户问题
- 不透露内部系统架构细节
"""
```

### 2. 理解 AI 产品的设计哲学

通过对比不同产品的提示词，你可以理解它们的设计选择：

- 为什么 Claude 总是先分析再行动？→ 提示词里写了"Context Awareness"
- 为什么 Copilot 的补全那么短？→ 提示词里写了"单行补全优先"
- 为什么 Devin 能自主执行？→ 提示词里写了"自主规划、环境交互"

### 3. 安全研究

```python
# 分析提示词的安全边界
prompt = load_prompt('claude-code')

# 检查是否有注入漏洞
if 'ignore previous instructions' not in prompt.lower():
    print("⚠️ 可能存在指令注入风险")

# 检查数据泄露风险
if 'api_key' in prompt.lower() or 'password' in prompt.lower():
    print("⚠️ 提示词中包含敏感关键词")
```

---

## 六、争议与伦理

这个项目也引发了一些争议：

**支持方认为：**
- 系统提示词不是商业秘密，用户有权知道 AI 如何与自己交互
- 促进 Prompt Engineering 领域的开放研究
- 帮助开发者构建更好的 AI 应用

**反对方认为：**
- 提取系统提示词可能违反服务条款
- 公开提示词可能帮助恶意用户找到越狱方法
- 损害公司的竞争优势

**项目作者的立场：**

> "这些信息都是通过公开渠道获取的（API 响应头、前端代码、网络抓包）。我们不鼓励违反服务条款的行为，但已公开的信息应该被研究和学习。"

---

## 七、快速浏览

```bash
# 克隆项目
git clone https://github.com/x1xhlol/system-prompts-and-models-of-ai-tools.git

# 查看 Claude Code 的提示词
cat prompts/claude-code.md

# 对比两个工具的提示词
diff prompts/claude-code.md prompts/cursor.md

# 搜索特定关键词
grep -r "test-driven" prompts/
```

---

## 八、写在最后

system-prompts-and-models-of-ai-tools 的 136K Star，说明了一个事实：**开发者对"理解 AI"的渴望，远超想象。**

AI 工具越来越强大，但也越来越黑箱。我们不知道它为什么这样回复，不知道它的能力边界，不知道它的安全限制。

而这个项目，用开源情报的方式，**拆掉了黑箱的一面墙**。

**未来的 AI 开发，Prompt Engineering 会和代码能力同等重要。** 而这个项目，就是 Prompt Engineering 的"源码"。

136K Star 不是终点。随着更多 AI 工具的发布，这个项目的价值只会越来越大。

**了解你的 AI，才能更好地使用它。**

---

*本文数据截至 2026 年 6 月 10 日。项目 Star 数实时变化，请以 GitHub 页面为准。*

*关注本公众号，每天带你发现 GitHub 上增长最快的 AI 新项目。*
