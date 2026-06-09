# App YAML Reference (脱敏)

> 完整 schema 描述了一个 App 的所有可声明字段。

## 最小可工作示例

```yaml
id: code-review
version: 1.0.0
description: Review staged changes against repo conventions.

trigger_keywords: ["review", "code review"]
default_brain: brain-2
fallback_brain: brain-4

inputs:
  target: {type: repo, required: true}
  staged_changes: {type: git_diff, required: false}

tools:
  - git.diff
  - test.runner
  - comment.pr_poster
```

## 完整字段

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `id` | string | ✓ | 唯一标识（kebab-case） |
| `version` | semver | ✓ | 语义化版本 |
| `description` | string | ✓ | 一句话说明 |
| `trigger_keywords` | string[] | - | 路由匹配关键词 |
| `default_brain` | enum | ✓ | 默认大脑 |
| `fallback_brain` | enum | - | 兜底大脑 |
| `inputs` | object | ✓ | 输入 schema |
| `tools` | string[] | - | 工具白名单 |
| `quality_thresholds.min_score` | float | - | 最低质量分（0-1） |
| `must_human_review_if` | condition[] | - | 触发人工 review 的条件 |
| `cost_budget_per_run_cents` | int | - | 单次预算上限 |
| `sla_seconds` | int | - | SLA 时限 |

## 真实差异

- 内部 schema 包含 RBAC scope 字段
- 内部 schema 包含 evidence requirement
- 内部 schema 包含 audit_log 配置
- 这些**不公开**，因为涉及组织级权限模型
