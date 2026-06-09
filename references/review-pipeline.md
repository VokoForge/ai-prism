# 7-Checklist Review — 多 Agent 审核流水线

> 所有 posts/*.md 发布前**必须**通过此审核. **不是 1 个 Agent** — 是 **3 个 Agent + 1 个人类抽审**.

## 7 条合规检查（自动化 · 100% 必跑）

| # | 检查项 | 工具 | 失败行为 |
|---|--------|------|----------|
| 1 | **不违法** — 不涉及盗版、隐私、违禁内容 | `scripts/legal_scan.sh` | 阻断发布 |
| 2 | **不查水表** — 不引战政治、敏感人物、宗教 | `scripts/sensitive_scan.sh` | 阻断发布 |
| 3 | **不泄露** — 闭源项目名 / 客户名 / API key 全部脱敏 | `scripts/redact.sh` | 自动替换为 `<公司>` 等 |
| 4 | **不夸大** — 项目评级必须有 GitHub 真实数据支撑 | `scripts/verify_claims.py` | 标注「需数据源」 |
| 5 | **不抄袭** — 引用必须注明, 大段复制使用 `> blockquote` | `scripts/cite_check.sh` | 警告 |
| 6 | **不误导** — 评分公式公开, 主观评价必须标注「我」 | `scripts/subjective_check.sh` | 警告 |
| 7 | **不刷屏** — 每天最多 1 篇, 周末不更新 | `scripts/schedule_check.sh` | 警告 |

## 多 Agent 互审流程

```
1. Rex 起草          (Claude Sonnet 4.5, 主笔+编排)
        ↓
2. OpenCode 互审     (deepseek-v4-flash, 工程审视)
        ↓
3. Kimi 互审         (kimi-k1.6, 中文表达审视)
        ↓
4. 7-checklist 自动跑 (Python 脚本)
        ↓
5. 人类 20% 抽审     (Yason)
        ↓
6. 合规通过 → 推 PR → 自动发布
```

## 跑审核

```bash
# 跑全部 7 项 + 3 个 Agent
scripts/review.sh posts/day-XX-name.md

# 只跑合规 7 项（快速）
scripts/review.sh --quick posts/day-XX-name.md

# 只跑 1 个 Agent
scripts/review.sh --agent opencode posts/day-XX-name.md
```

## 失败响应

- **阻断发布**（1/2/3）: 文章自动回滚到草稿, 通知 Yason
- **警告**（4/5/6/7）: 标黄显示, 但允许发布, 30 天内人工 review

## 写在最后

**多 Agent 不是炫技, 是制衡**. 每个 Agent 有自己的 bias, 互审 = 互相覆盖盲区.
- Claude 偏"框架化"
- OpenCode 偏"工程严谨"
- Kimi 偏"中文表达"
- 人类 = 终极判断

**任何一个 Agent 误判, 其他两个能 catch.**
