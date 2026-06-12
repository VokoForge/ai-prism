# OpenMed：开源医疗 AI，病历分析永不出境

[![GitHub Stars](https://img.shields.io/github/stars/openmed/openmed?style=social)](https://github.com/openmed/openmed)
[![GitHub Forks](https://img.shields.io/github/forks/openmed/openmed?style=social)](https://github.com/openmed/openmed)
[![GitHub Issues](https://img.shields.io/github/issues/openmed/openmed)](https://github.com/openmed/openmed/issues)
[![License](https://img.shields.io/github/license/openmed/openmed)](https://github.com/openmed/openmed)

> **项目速览**
> - 项目：OpenMed
> - GitHub：github.com/openmed/openmed（示例）
> -  Stars：15,000+ | 日增：+500
> -  创建时间：2026 年 5 月
> -  核心标签：医疗 AI / 本地运行 / 隐私保护 / 临床 NLP

---

## 一、开篇：当医院开始用 AI 看病，你的病历去哪了？

2026 年，医疗 AI 已经不再是科幻。

从影像识别到病理分析，从药物研发到个性化治疗方案，AI 正在渗透医疗的每一个环节。但在这股浪潮背后，有一个被大多数人忽视的问题：

**你的病历、检查报告、诊断记录——这些最敏感的个人数据，正在被送往哪里？**

答案是：**云端。第三方服务器。甚至可能是境外。**

很多医疗 AI 产品为了提供"智能分析"，要求医院将患者数据上传到云端。数据出境、隐私泄露、合规风险……这些问题像定时炸弹一样悬在头顶。

![OpenMed 本地优先架构](../../assets/openmed-arch.png)

**有没有一种方案，能让 AI 分析病历，但数据永远不出本地？**

有。**OpenMed**。

2026 年 5 月登上 GitHub Trending，迅速收获 **15,000+ Star**。它不是又一个云端医疗 AI，而是一个**完全本地运行的开源医疗分析系统**。

---

## 二、OpenMed 是什么？

一句话：**OpenMed 是一个开源的医疗 AI 分析工具，所有处理都在本地完成，数据永不出设备。**

三大核心能力：

| 能力 | 说明 | 技术基础 |
|------|------|---------|
| 临床文本实体提取 | 从病历中自动识别疾病、症状、药物、剂量 | 医学 NLP + 本地 LLM |
| PII 脱敏 | 自动识别并脱敏患者姓名、身份证号、电话等敏感信息 | 规则引擎 + 模型识别 |
| 结构化报告生成 | 将自由文本病历转为结构化数据，便于统计和分析 | 医学知识图谱 |

![Star 增长趋势](../../assets/star-growth-trend.png)

---

## 三、为什么医疗 AI 必须本地运行？

### 1. 法规合规

- **中国**：《个人信息保护法》《数据安全法》明确要求敏感个人信息本地化存储
- **欧盟**：GDPR 对医疗数据有最严格的保护要求
- **美国**：HIPAA 规定医疗信息的传输和存储标准

**云端处理 = 合规 nightmare。**

### 2. 隐私安全

2025 年某知名医疗 AI 平台的数据泄露事件还历历在目：数百万患者病历被挂在暗网出售。

OpenMed 的解决方案简单粗暴：**没有网络请求，就没有数据泄露。**

### 3. 离线可用

很多医院内网根本不通外网。云端 AI 再强，连不上网就是废铁。

OpenMed 纯本地运行，**断网也能用**。

![项目分类占比](../../assets/category-pie.png)

---

## 四、技术实现亮点

### 1. 医学 NLP 模型

OpenMed 基于 BioBERT + 中文医学语料微调：

```python
# 实体识别示例
from openmed import MedicalNLP

nlp = MedicalNLP()

text = """
患者张三，男，58岁，因"胸痛3天"入院。
既往有高血压病史10年，服用氨氯地平5mg qd。
查体：BP 150/90mmHg，HR 88bpm。
"""

entities = nlp.extract_entities(text)
# 输出：
# [
#   {"text": "张三", "type": "PATIENT_NAME", "start": 2, "end": 4},
#   {"text": "男", "type": "GENDER", "start": 5, "end": 6},
#   {"text": "58岁", "type": "AGE", "start": 7, "end": 10},
#   {"text": "胸痛", "type": "SYMPTOM", "start": 14, "end": 16},
#   {"text": "3天", "type": "DURATION", "start": 16, "end": 18},
#   {"text": "高血压", "type": "DISEASE", "start": 26, "end": 29},
#   {"text": "10年", "type": "DURATION", "start": 31, "end": 33},
#   {"text": "氨氯地平", "type": "DRUG", "start": 36, "end": 40},
#   {"text": "5mg", "type": "DOSAGE", "start": 40, "end": 43},
#   {"text": "qd", "type": "FREQUENCY", "start": 44, "end": 46},
#   {"text": "BP 150/90mmHg", "type": "VITAL_SIGN", "start": 51, "end": 64},
# ]
```

### 2. PII 脱敏策略

OpenMed 的脱敏不是简单的"替换为 XXX"，而是**智能保留医学价值**：

| 信息类型 | 原始文本 | 脱敏后 | 医学价值保留 |
|---------|---------|--------|------------|
| 姓名 | 张三 | [患者A] | ❌（无医学价值） |
| 年龄 | 58岁 | 58岁 | ✅（诊断参考） |
| 性别 | 男 | 男 | ✅（诊断参考） |
| 身份证号 | 11010119800101XXXX | [身份证号] | ❌ |
| 药物 | 氨氯地平5mg | 氨氯地平5mg | ✅（治疗方案） |
| 电话 | 138****8888 | [电话] | ❌ |

### 3. 本地模型部署

OpenMed 支持多种本地部署方案：

```bash
# 方案 1：Ollama（推荐，最简单）
ollama pull openmed
ollama run openmed

# 方案 2：LM Studio（带 GUI）
# 下载 OpenMed GGUF 模型，在 LM Studio 中加载

# 方案 3：vLLM（生产环境）
vllm serve openmed/openmed-7b --tensor-parallel-size 2
```

**硬件要求：**

| 模型大小 | 显存需求 | 适用场景 |
|---------|---------|---------|
| 3B | 6GB | 个人测试、轻量分析 |
| 7B | 14GB | 中小型医院科室 |
| 13B | 26GB | 大型医院、研究机构 |

---

## 五、真实应用场景

### 场景 1：病历结构化

医院每天有成千上万份手写/电子病历，传统方式需要护士手动录入结构化系统。

OpenMed 可以：

1. 读取 PDF/图片病历
2. 自动提取关键信息
3. 生成结构化 JSON
4. 直接导入医院信息系统（HIS）

**效率提升：从 30 分钟/份 → 30 秒/份。**

### 场景 2：科研数据脱敏

医学研究需要大量病历数据，但直接使用涉及隐私泄露。

OpenMed 可以：

1. 批量处理病历
2. 自动脱敏 PII
3. 保留医学相关信息
4. 生成可供研究使用的匿名数据集

### 场景 3：基层医疗辅助

偏远地区缺乏专科医生，OpenMed 可以作为辅助诊断工具：

1. 读取患者描述
2. 提取症状、病史
3. 提示可能的诊断方向
4. **注意：仅作参考，不替代医生判断**

---

## 六、社区反响

> **@hospital-it**："我们医院内网不通外网，之前一直没法用 AI 工具。OpenMed 纯本地运行，解决了大问题。"

> **@medical-researcher**："脱敏功能太实用了。以前手动脱敏 100 份病历要一周，现在 10 分钟搞定。"

> **@privacy-advocate**："终于有一个医疗 AI 是把隐私放在第一位的。不是先收集数据再谈安全，而是设计之初就不让数据出去。"

---

## 七、快速上手

```bash
# 1. 安装
pip install openmed

# 2. 下载模型（首次使用）
openmed download-model --size=7b

# 3. 分析单份病历
openmed analyze --input ./病历.pdf --output ./结构化结果.json

# 4. 批量脱敏
openmed deidentify --input ./病历文件夹/ --output ./脱敏后/

# 5. 启动 API 服务（供医院系统调用）
openmed serve --port 8080 --model 7b
```

---

## 八、写在最后

OpenMed 的出现，标志着医疗 AI 正在从"功能优先"转向"隐私优先"。

在过去，医疗 AI 的产品逻辑是：先做出强大的功能，再想办法保护数据。

OpenMed 的逻辑是：**先确保数据不出本地，再在这个前提下做功能。**

这不是技术路线的选择，这是价值观的选择。

15K Star 说明，越来越多的开发者和医疗机构认同这个价值观。

**医疗 AI 的未来，一定是"本地优先、隐私优先、患者优先"。**

---

*本文数据截至 2026 年 6 月 10 日。项目 Star 数实时变化，请以 GitHub 页面为准。*

*关注本公众号，每天带你发现 GitHub 上增长最快的 AI 新项目。*
