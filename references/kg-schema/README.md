# Knowledge Graph Schema (脱敏)

> 公开的"实体类型 + 关系类型 + 事件类型"清单。具体实例不开源。

## 实体类型 (Entity)

| 类型 | 关键字段 | 说明 |
|------|----------|------|
| Person | name, role, scopes | 个人（含 Agent） |
| Project | repo_url, status, owner | 项目 |
| Decision | timestamp, decided_by, evidence | 决策 |
| Incident | severity, root_cause, fix_pr | 事故 |
| Run | brain, app, cost, quality_score | 一次执行 |
| Artifact | url, content_hash | 产物（PR/文档） |

## 关系类型 (Relation)

| 关系 | 起点 → 终点 | 反向 |
|------|-------------|------|
| OWNS | Person → Project | OWNED_BY |
| GENERATED | Run → Artifact | GENERATED_BY |
| CAUSED | Decision → Incident | CAUSED_BY |
| AFFECTED | Incident → Project | AFFECTED |
| DOCUMENTED_IN | Run/Incident → Artifact | DOCUMENTS |
| PRODUCED | Project → Artifact | PRODUCED_BY |

## 事件类型 (Event)

| 类型 | 必填字段 | 可选 |
|------|----------|------|
| decision | actor, subject, facts, evidence | relations |
| incident | actor, severity, root_cause, fix_pr | relations |
| run_complete | actor, brain, app, cost, quality_score | relations |
| artifact_created | actor, type, url, content_hash | relations |

## 治理规则

1. **RBAC** — 每个实体有 scope，Agent 只能读自己 scope 内的
2. **审计** — 所有 write 都进 audit log，append-only
3. **审批** — P0 实体（决策 / 事故 / 架构）写入需人类审批
4. **证据** — 每个断言挂 ≥ 1 个 evidence
5. **衰减** — 180 天没被引用 → 冷存储
