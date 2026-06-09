# Feishu Card Template (脱敏)

> 强制所有 Agent 汇报走飞书卡片。这是一份通用模板。

## 模板

```json
{
  "config": {"wide_screen_mode": true},
  "header": {
    "template": "blue",
    "title": {"tag": "plain_text", "content": "📊 Agent 日报 · {date}"}
  },
  "elements": [
    {
      "tag": "div",
      "fields": [
        {"is_short": true, "text": {"tag": "lark_md", "content": "**负责人**\n{owner}"}},
        {"is_short": true, "text": {"tag": "lark_md", "content": "**模型版本**\n{brain}"}},
        {"is_short": true, "text": {"tag": "lark_md", "content": "**耗时**\n{latency}"}},
        {"is_short": true, "text": {"tag": "lark_md", "content": "**成本**\n{cost}"}}
      ]
    },
    {
      "tag": "hr"
    },
    {
      "tag": "div",
      "text": {"tag": "lark_md", "content": "**关键事件**\n{events}"}
    },
    {
      "tag": "div",
      "text": {"tag": "lark_md", "content": "**下一步**\n{next_steps}"}
    }
  ]
}
```

## 强制规则

1. **3 秒读完** — 总元素不超过 5 个 div + 1 个 hr
2. **emoji 区分** — 不同事件类型用不同 emoji（✓ ⚠️ 📌 🚨）
3. **可归档** — 卡片直接进 KG 事件流（避免重复写）
4. **可降级** — 网络/网关故障时降级到本地日志 + 重试 3 次

## 不开源的部分

- 内部事件 schema 字段（如 `risk_score`、`compliance_check`）
- 内部审批人 ID
- 内部消息网关（飞书 / 钉钉 / Slack）路由策略
