# Day 11 · Build Your Own MCP Server in 200 Lines

[English](./day-11.md) | [简体中文](../zh/day-11.md)
> **Date:** 2026-05-26 · **Category:** Hands-on · **Difficulty:** Intermediate
> **Read time:** ~12 min · **Code:** ~200 lines Python

Last week we surveyed 5 MCP servers in production (Day 07). This week we go hands-on: in 200 lines of Python you'll ship a working MCP server, wire it to an MCP host (Claude Desktop / Cursor / Cline), and verify a real end-to-end call. No framework magic, no copy-paste, just the protocol primitives.

## What you'll build

A `notes-mcp` server exposing three tools — `note_create`, `note_search`, `note_delete` — backed by SQLite. After this post you'll understand:

1. The **3 RPC methods** every MCP server must implement (`initialize`, `tools/list`, `tools/call`).
2. The **stdio transport** (the most common one) and why it beats HTTP for local tools.
3. How **tool schemas** become model-readable tool calls.
4. Where the **failure modes** live (most teams lose days here).

---

![mcp-architecture](../../assets/day-11-mcp-architecture.svg)

## 1. Why MCP, in one paragraph

Before MCP, every IDE / chat client / agent framework invented its own "tool" format: OpenAI has `function_calling`, Anthropic has `tool_use`, LangChain has `Tool`, LlamaIndex has `ToolSpec`. Each was a private schema. An MCP server author wrote the tool **once** in the MCP shape; any host that speaks MCP can consume it. That is the entire thesis. If you've ever lost a weekend to "make my tool work in Cursor AND Claude Desktop AND Cline", MCP is the answer.

## 2. The protocol in 3 RPCs

MCP is **JSON-RPC 2.0 over a transport** (stdio, HTTP+SSE, or streamable HTTP). Every server must respond to three methods:

| Method | Direction | Purpose |
|--------|-----------|---------|
| `initialize` | client → server | Negotiate protocol version + capabilities |
| `tools/list` | client → server | Return JSON Schema of every tool |
| `tools/call` | client → server | Invoke one tool, return result or error |

That's it. Resources and prompts are optional features we'll skip today.

## 3. The transport: stdio is enough

For local tools (90% of what you'll build), `stdio` is the right transport:

```
client ←stdin/stdout→ server
```

The client spawns the server as a subprocess. The server reads JSON-RPC messages from stdin, writes responses to stdout. **No port, no auth, no CORS.** The downside: the server process dies when the client disconnects, but that's actually a feature — no leaked state.

The JSON-RPC framing is line-delimited: each message is one JSON object on its own line, separated by `\n`. Many tutorials mess this up.

## 4. The 200-line server

Here is the **complete, runnable** code. We use the official `mcp` Python SDK, but to teach the protocol I show the raw JSON-RPC envelope first.

```python
#!/usr/bin/env python3
"""notes_mcp.py — a minimal MCP server over stdio.

Run from a host config:
    {"command": "python", "args": ["/path/to/notes_mcp.py"]}
"""

import json
import sqlite3
import sys
import uuid
from pathlib import Path

DB_PATH = Path.home() / ".notes_mcp.db"

# ---- protocol constants -------------------------------------------------
PROTOCOL_VERSION = "2025-03-26"
SERVER_INFO = {"name": "notes-mcp", "version": "0.1.0"}

# ---- storage ------------------------------------------------------------
def db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("""CREATE TABLE IF NOT EXISTS notes (
        id TEXT PRIMARY KEY, title TEXT, body TEXT,
        created_at REAL DEFAULT (strftime('%s','now'))
    )""")
    return conn

# ---- tool definitions ---------------------------------------------------
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

# ---- tool implementations ----------------------------------------------
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

# ---- JSON-RPC plumbing --------------------------------------------------
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
        return  # no reply for client→server notifications
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

That's 200 lines including docstrings. **The 5 things to notice:**

1. `initialize` returns `protocolVersion` + `capabilities` + `serverInfo`. The host uses `capabilities.tools = {}` to know we have tools.
2. `tools/list` returns a list of tool definitions. The `inputSchema` is **plain JSON Schema** — the model reads it.
3. `tools/call` dispatches by `name`. Errors must use JSON-RPC error codes; the SDK helps but raw is also fine.
4. The `notifications/initialized` message is a **client→server notification** (no `id`); we don't reply.
5. **One JSON object per line** on stdout. `flush()` is mandatory —stdio is line-buffered by default but in a pipe it's block-buffered.

## 5. Wire it to a host

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

Restart Claude Desktop. The model can now call `note_create("hello", "world")` and you'll see the new row in `~/.notes_mcp.db`.

**Cursor / Cline** follow the same shape; check their docs for the exact path.

## 6. Verify the end-to-end call

Don't trust the chat UI —trust the protocol. Open a terminal and **speak JSON-RPC directly**:

```bash
python notes_mcp.py <<'EOF'
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"probe","version":"0"}}}
{"jsonrpc":"2.0","method":"notifications/initialized"}
{"jsonrpc":"2.0","id":2,"method":"tools/list"}
{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"note_create","arguments":{"title":"probe","body":"hello"}}}
EOF
```

You should see 3 JSON responses (initialize, tools/list, tools/call), the last one containing `Created note <id>`. If the third response is an error, the most common cause is **forgetting `flush()`** — the server actually ran fine but the buffer never emptied.

## 7. Failure modes the docs don't list

- **Stdio buffering.** `print()` alone is not enough. Use `sys.stdout.write` + `flush()` or set `PYTHONUNBUFFERED=1`.
- **Schema strictness.** If `inputSchema` says `required: ["title"]` and the model omits it, the host validates **before** the call. Make `description` text do real work; it's the model's only hint.
- **Long output truncation.** Most hosts cap tool output at 25k tokens. `note_search` paginates with `LIMIT 20` to stay under.
- **State on stderr.** Debug logs go to **stderr**, never stdout — stdout is the protocol channel. One stray `print()` corrupts the stream.
- **Process supervision.** The host spawns you per session. Don't try to keep a long-lived daemon; rebuild state from SQLite each startup.

## 8. Production checklist

Before you ship:

- [ ] All tool outputs ≤ 25k tokens (paginate)
- [ ] `description` field is a full sentence, not a label
- [ ] `inputSchema` declares `minLength` / `maxLength` / `enum` where applicable
- [ ] Errors return JSON-RPC codes (-32601, -32602, -32000), not HTTP-style
- [ ] Logs go to stderr, with `[notes-mcp]` prefix
- [ ] Tested with `--stdio` pipe (above probe) before connecting to a host
- [ ] README has a one-line install command (e.g. `uv tool install notes-mcp`)

## 9. Where to go next

- **Resources** (`resources/list` + `resources/read`) for read-only data the model can browse.
- **Prompts** (`prompts/list` + `prompts/get`) for reusable prompt templates the user can invoke with `/`.
- **HTTP+SSE transport** when the server is remote; same JSON-RPC, different envelope.
- **Sampling** — letting the server ask the host to call the model. Powerful, easy to abuse; read the spec twice.

## 10. Our take

MCP's "boring" reputation is unfair. The protocol is 3 RPCs, the SDK is 200 lines, and the value compounds: one server, every host. The hard part is not the protocol — it's writing tool descriptions that make the **model** pick the right tool with the right arguments. Spend 80% of your time on `description` and `inputSchema`, not on the dispatcher.

---
