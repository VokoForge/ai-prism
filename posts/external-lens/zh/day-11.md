# Day 11 · 200 行代码自建一个 MCP Server

[English](../en/day-11.md) | [简体中文](./day-11.md)
> **日期:** 2026-05-26 · **类型:** 实战 · **难度:** 中级
> **阅读时间:** ~12 分钟 · **代码:** ~200 行 Python

上周我们盘点了 5 个生产中的 MCP server (Day 07)。本周动手: 用 200 行 Python 写一个能跑的 MCP server, 接入 Claude Desktop / Cursor / Cline 任意一个 host, 跑通端到端调用。没有框架魔法, 没有复制粘贴, 只有协议原语。

## 你会做出什么

一个 `notes-mcp` server, 暴露三个工具: `note_create` / `note_search` / `note_delete`, 用 SQLite 存数据。读完你会搞懂:

1. 每个 MCP server **必须实现**的 3 个 RPC 方法 (`initialize` / `tools/list` / `tools/call`)
2. **stdio 传输** 是什么, 为什么本地工具都用它
3. 工具的 **JSON Schema** 怎么变成模型能调用的工具
4. 90% 团队栽在哪几个**坑**里

![mcp-architecture](../../assets/day-11-mcp-architecture.svg)

## 1. 一段话说清 MCP 的价值

MCP 之前, 每个 IDE / 聊天客户端 / Agent 框架都发明自己的"工具"格式: OpenAI 有 `function_calling`, Anthropic 有 `tool_use`, LangChain 有 `Tool`, LlamaIndex 有 `ToolSpec`。每家一套私有 schema。MCP 的作者**一次**按 MCP 规范写好工具, 任何支持 MCP 的 host 都能直接用。这就是 MCP 的全部价值主张。如果你曾为"我的工具在 Cursor 里能跑但在 Claude Desktop 里跑不起来"浪费过一个周末, MCP 就是答案。

## 2. 协议就 3 个 RPC

MCP 是 **JSON-RPC 2.0 + 传输层** (stdio / HTTP+SSE / streamable HTTP)。每个 server 必须响应三个方法:

| 方法 | 方向 | 用途 |
|------|------|------|
| `initialize` | client → server | 协商协议版本和能力 |
| `tools/list` | client → server | 返回每个工具的 JSON Schema |
| `tools/call` | client → server | 调用一个工具, 返回结果或错误 |

就这些。Resources 和 Prompts 是可选特性, 这次跳过。

## 3. 传输层: stdio 就够了

本地工具 (你要写的 90% 的工具) 用 **stdio**:

```
client ←stdin/stdout→ server
```

客户端把 server 当子进程拉起, server 从 stdin 读 JSON-RPC 消息, 往 stdout 写响应。**没有端口, 没有鉴权, 没有 CORS**。代价: 客户端断开时 server 进程就死了 — 但这其实是优点, 不会有泄漏的状态。

JSON-RPC 帧格式是**按行分隔**: 每条消息是独立一行的 JSON 对象, 用 `\n` 分隔。很多教程在这里栽过。

## 4. 200 行 server

下面是**完整可运行**的代码。我们用官方 `mcp` Python SDK, 但为了把协议讲清楚, 先展示原始的 JSON-RPC 信封。

```python
#!/usr/bin/env python3
"""notes_mcp.py — 一个最小化的 stdio MCP server.

从 host 配置启动:
    {"command": "python", "args": ["/path/to/notes_mcp.py"]}
"""

import json
import sqlite3
import sys
import uuid
from pathlib import Path

DB_PATH = Path.home() / ".notes_mcp.db"

# ---- 协议常量 ---------------------------------------------------------
PROTOCOL_VERSION = "2025-03-26"
SERVER_INFO = {"name": "notes-mcp", "version": "0.1.0"}

# ---- 存储层 -----------------------------------------------------------
def db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("""CREATE TABLE IF NOT EXISTS notes (
        id TEXT PRIMARY KEY, title TEXT, body TEXT,
        created_at REAL DEFAULT (strftime('%s','now'))
    )""")
    return conn

# ---- 工具定义 ---------------------------------------------------------
TOOLS = [{
    "name": "note_create",
    "description": "Create a new note. Returns the note id.",
    "inputSchema": {
        "type": "object",
        "properties": {
            "title": {"type": "string", "maxLength": 200},
            "body":  {"type": "string"}
        },
        "required": ["title", "body"]
    }
}, {
    "name": "note_search",
    "description": "Search notes by case-insensitive substring of title or body.",
    "inputSchema": {
        "type": "object",
        "properties": {"query": {"type": "string", "minLength": 1}},
        "required": ["query"]
    }
}, {
    "name": "note_delete",
    "description": "Delete a note by id.",
    "inputSchema": {
        "type": "object",
        "properties": {"id": {"type": "string"}},
        "required": ["id"]
    }
}]

# ---- 工具实现 ---------------------------------------------------------
def tool_create(args):
    nid = str(uuid.uuid4())[:8]
    with db() as conn:
        conn.execute("INSERT INTO notes(id,title,body) VALUES(?,?,?)",
                     (nid, args["title"], args["body"]))
    return {"content": [{"type": "text", "text": f"Created note {nid}"}]}

def tool_search(args):
    q = f"%{args['query']}%"
    with db() as conn:
        rows = conn.execute(
            "SELECT id,title,substr(body,1,80) AS preview "
            "FROM notes WHERE title LIKE ? OR body LIKE ? LIMIT 20",
            (q, q)).fetchall()
    if not rows:
        return {"content": [{"type": "text", "text": "No matches."}]}
    text = "\n".join(f"{r['id']}  {r['title']} — {r['preview']}…" for r in rows)
    return {"content": [{"type": "text", "text": text}]}

def tool_delete(args):
    with db() as conn:
        cur = conn.execute("DELETE FROM notes WHERE id=?", (args["id"],))
    msg = "Deleted" if cur.rowcount else "Not found"
    return {"content": [{"type": "text", "text": f"{msg} {args['id']}"}]}

DISPATCH = {
    "note_create": tool_create,
    "note_search": tool_search,
    "note_delete": tool_delete,
}

# ---- JSON-RPC 收发 ----------------------------------------------------
def reply(id_, result):
    sys.stdout.write(json.dumps({"jsonrpc": "2.0", "id": id_, "result": result}) + "\n")
    sys.stdout.flush()

def fail(id_, code, message):
    sys.stdout.write(json.dumps({
        "jsonrpc": "2.0", "id": id_, "error": {"code": code, "message": message}
    }) + "\n")
    sys.stdout.flush()

def handle(msg):
    method, id_, params = msg.get("method"), msg.get("id"), msg.get("params", {})
    if method == "initialize":
        return reply(id_, {
            "protocolVersion": PROTOCOL_VERSION,
            "capabilities": {"tools": {}},
            "serverInfo": SERVER_INFO,
        })
    if method == "tools/list":
        return reply(id_, {"tools": TOOLS})
    if method == "tools/call":
        name, args = params.get("name"), params.get("arguments", {})
        if name not in DISPATCH:
            return fail(id_, -32601, f"Unknown tool: {name}")
        try:
            return reply(id_, DISPATCH[name](args))
        except Exception as exc:
            return fail(id_, -32000, f"{type(exc).__name__}: {exc}")
    if method == "notifications/initialized":
        return  # client→server 通知, 不回复
    if id_ is not None:
        return fail(id_, -32601, f"Method not found: {method}")

def main():
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            handle(json.loads(line))
        except json.JSONDecodeError:
            fail(None, -32700, "Parse error")

if __name__ == "__main__":
    main()
```

加上 docstring 共 200 行。**注意 5 个细节:**

1. `initialize` 返回 `protocolVersion` + `capabilities` + `serverInfo`。host 看 `capabilities.tools = {}` 知道我们有工具。
2. `tools/list` 返回工具定义列表, `inputSchema` 是**纯 JSON Schema** — 模型读它。
3. `tools/call` 按 `name` 分发。错误必须用 JSON-RPC 错误码, SDK 帮了你, 裸写也行。
4. `notifications/initialized` 是 **client→server 通知** (没有 `id`), 不回复。
5. stdout 上**一行一个 JSON 对象**。`flush()` 是必须的 — stdio 在管道里默认是块缓冲。

## 5. 接入 host

**Claude Desktop** (`~/Library/Application Support/Claude/claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "notes": {
      "command": "python",
      "args": ["/absolute/path/to/notes_mcp.py"]
    }
  }
}
```

重启 Claude Desktop。模型现在可以调 `note_create("hello", "world")`, 你会在 `~/.notes_mcp.db` 看到新行。

**Cursor / Cline** 同样格式, 路径看各自文档。

## 6. 端到端验证

别信聊天 UI —信协议。打开终端**直接说 JSON-RPC**:

```bash
python notes_mcp.py <<'EOF'
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"probe","version":"0"}}}
{"jsonrpc":"2.0","method":"notifications/initialized"}
{"jsonrpc":"2.0","id":2,"method":"tools/list"}
{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"note_create","arguments":{"title":"probe","body":"hello"}}}
EOF
```

应该看到 3 条 JSON 响应 (initialize / tools/list / tools/call), 最后一条含 `Created note <id>`。如果第三条是错误, 最常见原因是**忘了 `flush()`** — server 实际跑成功了, 但缓冲没清空。

## 7. 文档没列的失败模式

- **stdio 缓冲。** 光 `print()` 不够。用 `sys.stdout.write` + `flush()` 或设 `PYTHONUNBUFFERED=1`。
- **Schema 严格性。** `inputSchema` 写 `required: ["title"]`, 模型漏了, host 在调用**前**校验。让 `description` 真的在做事, 它是模型唯一的提示。
- **长输出截断。** 大多数 host 给工具输出设 25k token 上限。`note_search` 用 `LIMIT 20` 分页, 不超限。
- **状态走 stderr。** 调试日志走 **stderr**, 永远不走 stdout — stdout 是协议通道。一行多余的 `print()` 就毁掉流。
- **进程监管。** host 每次会话拉起你一次。别想保活长驻进程, 每次启动从 SQLite 重建状态。

## 8. 生产检查清单

上线前:

- [ ] 所有工具输出 ≤ 25k token (分页)
- [ ] `description` 字段是完整句子, 不是标签
- [ ] `inputSchema` 声明了 `minLength` / `maxLength` / `enum` (该声明的)
- [ ] 错误用 JSON-RPC 错误码 (-32601 / -32602 / -32000), 不是 HTTP 风格
- [ ] 日志走 stderr, 带 `[notes-mcp]` 前缀
- [ ] 接 host 前用 `--stdio` 管道测过 (上面的 probe)
- [ ] README 有一行安装命令 (如 `uv tool install notes-mcp`)

## 9. 下一步去哪

- **Resources** (`resources/list` + `resources/read`): 让模型浏览只读数据。
- **Prompts** (`prompts/list` + `prompts/get`): 用户用 `/` 调用的可复用 prompt 模板。
- **HTTP+SSE 传输**: server 远程时, 同样 JSON-RPC, 不同信封。
- **Sampling**: 让 server 反过来请 host 调模型。能力大, 易滥用, 读两遍规范再用。

## 10. 我们的看法

MCP 的"无聊"名声不太公平。协议就 3 个 RPC, SDK 200 行, 价值复利: 一个 server, 所有 host。难的部分不是协议 — 是写让**模型**用对工具、传对参数的 `description`。把 80% 的时间花在 `description` 和 `inputSchema` 上, 而不是 dispatcher。
