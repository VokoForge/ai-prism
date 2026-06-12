# CodeGraph：给 Claude Code / Cursor 一张"本地代码地图"

![GitHub Stars](https://img.shields.io/github/stars/colbymchenry/codegraph?style=for-the-badge&color=blue)
![GitHub Created At](https://img.shields.io/github/created-at/colbymchenry/codegraph?style=for-the-badge)
![GitHub Last Commit](https://img.shields.io/github/last-commit/colbymchenry/codegraph?style=for-the-badge)

> **项目速览**
> - 项目：codegraph
> - 作者：colbymchenry
> - GitHub：[github.com/colbymchenry/codegraph](https://github.com/colbymchenry/codegraph)
> -  Stars：28,400+ | 本周新增：+14,100
> -  创建时间：2026 年 1 月（但 5 月爆发式增长）
> -  核心标签：AI 编程 / 代码知识图谱 / 预索引 / 上下文增强

---

## 一、开篇：AI 编程助手为什么总是"看不懂"你的项目？

如果你用 Claude Code 或 Cursor 处理过大型项目，一定遇到过这种 frustration：

- "请修改用户认证逻辑" → AI 改了错误的文件
- "这个 bug 在哪里？" → AI 在无关的文件里找了半天
- "重构这个模块" → AI 不知道哪些文件依赖这个模块

**为什么？因为 AI 没有"项目地图"。**

当你让 AI 处理代码时，它只能看到当前文件，或者你手动提供的几个文件。它不知道：

- 项目整体结构是什么样的
- 哪些模块依赖哪些模块
- 哪个函数被哪里调用
- 类的继承关系是什么

**它就像一个没有地图的探险家，只能盲人摸象。**

**CodeGraph** 解决这个问题的方式极其优雅：**给 AI 一张预先生成的代码知识图谱。**

2026 年 1 月创建，5 月爆发式增长，一周内新增 **14,100 Star**，总星数突破 **28,400**。

---

## 二、CodeGraph 是什么？

一句话：**CodeGraph 是一个代码知识图谱生成工具，解析项目源码，构建符号关系、调用图、依赖图，让 AI 编程助手能"看懂"整个项目。**

**支持的 AI 工具：**

| AI 工具 | 集成方式 | 效果提升 |
|---------|---------|---------|
| Claude Code | MCP Skill | 上下文准确率 +40% |
| Cursor | 插件 | 代码理解深度 +60% |
| Codex | 上下文注入 | 跨文件修改成功率 +50% |
| OpenCode | API | 项目级重构成功率 +35% |

![CodeGraph 生成的 5 种代码图谱](../../assets/codegraph-types.png)

---

## 三、为什么 AI 需要代码知识图谱？

### 场景对比

**没有 CodeGraph：**

```
用户：修改 UserService 的认证逻辑

Claude Code：
1. 读取 UserService.ts
2. 看到 authenticate() 方法
3. 修改方法实现
4. 提交

结果：💥 破坏了 OAuthCallback.ts 中的调用，
      因为不知道 OAuth 流程也依赖这个方法
```

**有 CodeGraph：**

```
用户：修改 UserService 的认证逻辑

Claude Code (通过 CodeGraph):
1. 查询图谱：UserService.authenticate 的调用者
2. 发现被 5 个文件调用：
   - LoginController.ts
   - OAuthCallback.ts
   - APIKeyAuth.ts
   - SessionManager.ts
   - AdminAuth.ts
3. 读取所有相关文件
4. 分析影响范围
5. 提出修改方案，包含所有需要同步修改的点
6. 执行修改
7. 运行测试验证

结果：✅ 所有调用点都正确更新
```

![项目 Star 增长趋势](../../assets/star-growth-trend.png)

---

## 四、技术实现

### 1. 代码解析

CodeGraph 使用 Tree-sitter 解析源代码：

```typescript
// 解析 TypeScript 文件
import Parser from 'tree-sitter';
import TypeScript from 'tree-sitter-typescript';

const parser = new Parser();
parser.setLanguage(TypeScript);

const tree = parser.parse(sourceCode);

// 提取所有函数定义
function extractFunctions(node: Parser.SyntaxNode): FunctionDef[] {
    const functions: FunctionDef[] = [];
    
    if (node.type === 'function_declaration' || 
        node.type === 'method_definition') {
        functions.push({
            name: node.childForFieldName('name')?.text,
            params: extractParams(node),
            range: { start: node.startPosition, end: node.endPosition }
        });
    }
    
    for (const child of node.children) {
        functions.push(...extractFunctions(child));
    }
    
    return functions;
}
```

### 2. 关系提取

```typescript
// 提取 import 关系
function extractImports(node: Parser.SyntaxNode): Import[] {
    const imports: Import[] = [];
    
    if (node.type === 'import_statement') {
        const source = node.childForFieldName('source')?.text;
        const specifiers = node.children
            .filter(c => c.type === 'import_specifier')
            .map(c => c.childForFieldName('name')?.text);
        
        imports.push({ source, specifiers });
    }
    
    return imports;
}

// 提取调用关系
function extractCalls(node: Parser.SyntaxNode): Call[] {
    const calls: Call[] = [];
    
    if (node.type === 'call_expression') {
        const callee = node.childForFieldName('function');
        calls.push({
            target: callee?.text,
            args: node.childForFieldName('arguments')?.children.length
        });
    }
    
    return calls;
}
```

![收录工具分类占比](../../assets/category-pie.png)

### 3. 图谱存储

CodeGraph 使用图数据库存储（Neo4j 或嵌入式）：

```cypher
// 创建符号节点
CREATE (f:Function {
    name: 'authenticate',
    file: 'src/services/UserService.ts',
    line: 45,
    params: ['email', 'password'],
    returnType: 'AuthResult'
})

// 创建调用关系
MATCH (caller:Function {name: 'login'})
MATCH (callee:Function {name: 'authenticate'})
CREATE (caller)-[:CALLS {
    line: 23,
    file: 'src/controllers/LoginController.ts'
}]->(callee)

// 查询某个函数的所有调用者
MATCH (caller)-[:CALLS]->(f:Function {name: 'authenticate'})
RETURN caller.name, caller.file
```

### 4. 向 AI 提供上下文

```typescript
// 当 AI 需要理解某个符号时，CodeGraph 提供相关上下文
function getContextForAI(symbol: string, depth: number = 2): string {
    const graph = loadGraph();
    
    // 1. 获取符号定义
    const definition = graph.getDefinition(symbol);
    
    // 2. 获取直接调用者
    const callers = graph.getCallers(symbol, depth);
    
    // 3. 获取直接依赖
    const dependencies = graph.getDependencies(symbol, depth);
    
    // 4. 格式化输出
    return formatContext({
        definition,
        callers,
        dependencies,
        relatedFiles: [...new Set([
            ...callers.map(c => c.file),
            ...dependencies.map(d => d.file)
        ])]
    });
}
```

---

## 五、性能数据

在 10 万行 TypeScript 项目上的测试：

| 指标 | 数值 |
|------|------|
| 索引构建时间 | ~30 秒 |
| 增量更新 | ~2 秒 |
| 查询响应 | < 10ms |
| 存储占用 | ~50MB |
| 支持语言 | TypeScript, Python, Go, Rust, Java, C++ |

---

## 六、真实效果

> **@senior-dev**："在 20 万行的 legacy 项目上，Claude Code 之前总是改错文件。装了 CodeGraph 后，它能准确找到所有相关代码，跨文件重构的成功率从 30% 提升到 80%。"

> **@tech-lead**："我们团队把 CodeGraph 集成到 CI 里了。每次 PR 自动更新图谱，Code Review 时 AI 能给出更精准的建议。"

> **@open-source-maintainer**："处理 issue 时，CodeGraph 帮我快速定位相关代码。以前要 grep 半天，现在 2 秒搞定。"

---

## 七、快速上手

```bash
# 1. 安装
npm install -g codegraph
# 或
pip install codegraph

# 2. 初始化项目索引
cd my-project
codegraph init

# 3. 构建图谱
codegraph build

# 4. 查询
# 查找函数的所有调用者
codegraph callers authenticate --depth=2

# 查找文件依赖图
codegraph deps src/services/UserService.ts

# 查找循环依赖
codegraph cycles

# 5. 在 Claude Code 中使用
npx skills add https://github.com/colbymchenry/codegraph

claude
> @codegraph analyze "修改用户认证逻辑的影响范围"
```

---

## 八、写在最后

CodeGraph 的 28K Star，揭示了一个关键趋势：**AI 编程助手正在从"文件级"进化到"项目级"。**

早期的 AI 代码工具，只能处理单个文件。你要手动告诉它"也看看那个文件"。

有了 CodeGraph，AI 终于有了"项目地图"——它知道整个项目的结构、关系、依赖。

**这就像是给 AI 从"盲人摸象"升级到了"全局视野"。**

28K Star 只是一个开始。随着代码知识图谱技术的成熟，未来的 AI 编程助手将能：

- 自动发现项目中的技术债务
- 建议架构改进方案
- 预测修改的影响范围
- 甚至自主进行项目级重构

**AI 编程的下一个时代，是"项目级智能"。而 CodeGraph，就是通往这个时代的门票。**

---

*本文数据截至 2026 年 6 月 10 日。项目 Star 数实时变化，请以 GitHub 页面为准。*

*关注本公众号，每天带你发现 GitHub 上增长最快的 AI 新项目。*
