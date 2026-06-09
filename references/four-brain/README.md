# Four-Brain Reference (脱敏)

> 这是一个**脱敏版**的四脑调度器参考实现。生产版本在公司闭源仓库里。

## 核心概念

```python
class Brain(Enum):
    BRAIN_1 = "brain-1"  # 主脑：长上下文 / 推理
    BRAIN_2 = "brain-2"  # 快脑：短任务 / 补全
    BRAIN_3 = "brain-3"  # 深脑：多步 / 复杂
    BRAIN_4 = "brain-4"  # 兜底：高质量 / 关键
```

## 调度器

```python
def select_brain(task: Task) -> Brain:
    if task.budget_remaining_cents < 5:
        return Brain.BRAIN_2
    if task.kind in {CodeEdit, BugFix, TestGen}:
        return Brain.BRAIN_2
    if task.kind in {ResearchReport, ArchitectureDoc}:
        return Brain.BRAIN_1
    if task.kind in {MultiStepRefactor, DeepAnalysis}:
        return Brain.BRAIN_3
    if task.risk == Risk.HIGH or task.requires_approval:
        return Brain.BRAIN_4
    return Brain.BRAIN_1
```

## 失败降级

```python
def execute_with_fallback(task: Task) -> Result:
    brains = [select_brain(task)] + [b for b in Brain if b != select_brain(task)]
    for brain in brains:
        try:
            result = brain.run(task, timeout=task.sla_seconds)
            if result.quality_score >= task.min_quality:
                return result
        except TimeoutError:
            log(f"{brain} timeout, downgrade → next")
        except QualityError as e:
            log(f"{brain} quality {e.score} < {task.min_quality}, downgrade → next")
    raise AllBrainsFailed(task)
```

## 关键设计

1. **每个脑一个标准接口**：`brain.run(task, timeout) → result`
2. **调度器是无状态函数**：纯函数，零外部依赖
3. **质量分是统一信号**：所有脑返回 `result.quality_score` ∈ [0, 1]
4. **降级链是预排序的**：在调度时一次性生成，避免重试回路

## 与生产版的差异

- 真实脑的具体模型名 / API endpoint 在公司闭源仓库
- 真实 budget 接入的是 LLM 网关（new-api / hub-router）的计费信号
- 真实 RBAC 在最外层（不是脑内）
