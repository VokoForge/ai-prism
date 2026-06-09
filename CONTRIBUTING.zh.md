# 投稿与共建

[English](./CONTRIBUTING.md) | [简体中文](./CONTRIBUTING.zh.md)

> 欢迎贡献一篇 / 修一个错 / 提一个 issue。
> 我们的理念是：**方法论公开，闭源内容不混进来。**

---

## 📋 范围

**✅ 可投稿：**
- Agent 编排、调度、监控、成本控制等方法论
- 真实踩坑、复盘、反思
- 架构图、YAML schema、CI/CD 模板
- 外部视角的 AI 项目深度解读
- 翻译现有中文内容为英文

**❌ 不投稿：**
- 闭源产品代码
- 付费 API 集成
- 内部组织信息、姓名、邮箱、凭据
- 任何可识别为"客户"或"用户"的数据

---

## 🔄 投稿流程

```mermaid
graph LR
    A[想法] --> B[Fork + 创建分支]
    B --> C[写文章]
    C --> D[配图: SVG]
    D --> E[本地预览]
    E --> F{通过 checklist?}
    F -- no --> G[修订]
    G --> E
    F -- yes --> H[开 PR]
    H --> I[CI 自动 lint]
    I -- pass --> J[人类 review]
    I -- fail --> G
    J --> K[merge]
```

---

## ✅ Checklist（必过）

每篇 PR 提交前自查：

- [ ] **双语完整** — 中英两版都写完，不是"先写中文、英文 TODO"
- [ ] **脱敏** — 没有人名 / 客户名 / 内部凭证 / 内部 GitHub org 名
- [ ] **代码片段用通用示例** — 不暴露内部项目名 / 业务逻辑
- [ ] **图用 SVG** — 不要 PNG / 外部链接（GitHub 渲染 SVG 最好）
- [ ] **每篇 600-1500 字** — 短了不够深，长了读者跑掉

---

## 📝 文章结构

### 外部视角 (External Lens)

每篇 `zh/day-NN.md` / `en/day-NN.md` 必须有：

```markdown
# AI棱镜 · 外部视角 · Day NN

[English](../en/day-NN.md) | [简体中文](./day-NN.md)

> 日期 · 第 N 期

---

## TL;DR

[3-5 行要点]

## 正文

[深度解读内容]

## Appendix: Tools & Links

[关联链接 + 下篇预告]
```

### Yason 和他的罗伯特们

每篇 `zh/chNN.md` / `en/chNN.md` 必须有：

```markdown
# 第N章：标题

[English](../en/chNN.md) | [简体中文](./chNN.md)

> **核心观点：一句话概括**

---

[正文内容]
```

---

## 🎨 图标准

- **格式**：SVG（矢量、可 git diff、GitHub 完美渲染）
- **viewBox**：1200×600 或 1000×500
- **字号**：标题 28-32px，正文 11-14px
- **色板**：
  - 🔮 Indigo `#6366f1` — 外部视角
  - 🤖 Pink `#ec4899` — 内部实践
  - ✨ Amber `#f59e0b` — 高亮
  - 🌑 Dark `#0f0b1a` — 背景
- **文件命名**：`day-NN-描述.svg` 或 `NN-描述.svg`

---

## 📌 Commit & PR 规范

- **Commit**: `post: day-NN` / `post: chNN` 或 `fix: day-NN typo`
- **Branch**: `post/day-NN-主题` 或 `fix/day-NN-具体问题`
- **PR Title**: `Day NN: 中文标题` 或 `Ch NN: 中文标题`

---

## 🤝 行为准则

- 友善、尊重、就事论事
- 接受建设性批评
- 不接受人身攻击 / 歧视 / 骚扰
