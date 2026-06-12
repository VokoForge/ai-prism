# WhichLLM：自动检测你的硬件，告诉你能跑哪个大模型

[![GitHub Stars](https://img.shields.io/github/stars/whichllm/whichllm?style=social)](https://github.com/whichllm/whichllm)
[![GitHub License](https://img.shields.io/github/license/whichllm/whichllm)](https://github.com/whichllm/whichllm)
[![PyPI Version](https://img.shields.io/pypi/v/whichllm)](https://pypi.org/project/whichllm/)
[![Python](https://img.shields.io/badge/Python-3.9%2B-blue?logo=python)](https://www.python.org/)
[![Downloads](https://img.shields.io/pypi/dm/whichllm)](https://pypi.org/project/whichllm/)

> **项目速览**
> - 项目：whichllm
> - GitHub：[github.com/whichllm/whichllm](https://github.com/whichllm/whichllm)
> - Stars：10,000+ | 日增：+300
> - 创建时间：2026 年 5 月
> - 核心标签：本地 LLM / 硬件检测 / 模型推荐 / 开源工具

---

## 一、开篇：下载了 70B 模型，发现跑不动？

如果你玩过本地大模型，一定经历过这样的绝望循环：

1. 在 HuggingFace 上看到一个新模型，70B 参数，评测分数超高
2. 激动地下载，等了 3 小时，占用 140GB 硬盘
3. 满怀期待地运行
4. **Out Of Memory**
5. 删掉，换个小一点的
6. 重复步骤 1-5

**问题出在哪？**

不是模型不好，是你不知道**你的硬件能跑什么模型**。

显存多少？内存多少？CPU 几核？量化后能不能跑？用 GGUF 还是 EXL2？4bit 量化精度够吗？

这些问题，对于普通开发者来说，门槛太高了。

直到 **WhichLLM** 出现。

2026 年 5 月开源，迅速收获 **10,000+ Star**。它做了一件极其简单、但极其有用的事：**自动检测你的硬件，告诉你能跑哪个大模型。**

---

## 二、WhichLLM 是什么？

一句话：**WhichLLM 是一个 Python 命令行工具，自动检测你的硬件配置，从 HuggingFace 筛选出能跑的模型，并按多维评分排名输出。**

![WhichLLM 工作流程](../../assets/whichllm-flow.png)

---

## 三、多维评分系统：不只是"能跑"

WhichLLM 的评分不是简单的"能不能跑"，而是融合了多个真实基准测试：

| 评分维度 | 权重 | 数据来源 |
|---------|------|---------|
| 推理质量 | 35% | LiveBench、Aider、HumanEval |
| 速度表现 | 25% | 本地实测 tokens/second |
| 内存效率 | 20% | VRAM/RAM 占用 |
| 社区活跃度 | 10% | GitHub Star、下载量 |
| 量化友好度 | 10% | 4bit/8bit 精度保持率 |

![模型评分维度分布](../../assets/category-pie.png)

**示例输出：**

```bash
$ whichllm recommend --task=coding --max-vram=24

🔍 检测到的硬件:
   GPU: NVIDIA RTX 4090 (24GB VRAM)
   RAM: 64GB
   CUDA: 12.4

📊 推荐模型 (按综合评分排序):

Rank  Model              Size   Quant   VRAM   Speed    Score   Why
────  ─────────────────  ─────  ──────  ─────  ───────  ──────  ─────────────────────────
 1    Qwen2.5-Coder-32B  32B    Q4_K_M  20GB   45t/s    92.4    编码最强，量化损失极小
 2    DeepSeek-Coder-V2  16B    Q8_0    18GB   62t/s    89.7    速度最快，代码质量高
 3    Codestral-22B      22B    Q4_K_S  15GB   38t/s    87.2    多语言支持最好
 4    Llama-3-70B        70B    Q4_K_M  40GB   N/A      85.1    质量最高，但超出显存
      ↳ 建议: 使用 CPU offload 或换 24GB 方案

💡 运行命令:
   ollama run qwen2.5-coder:32b-q4_k_m

   或手动下载:
   huggingface-cli download Qwen/Qwen2.5-Coder-32B-Instruct-GGUF \
     --local-dir ./models --include "*q4_k_m.gguf"
```

---

## 四、技术实现

### 硬件检测

```python
import torch
import psutil
import GPUtil

class HardwareDetector:
    def detect(self) -> HardwareProfile:
        profile = HardwareProfile()
        
        # GPU 检测
        if torch.cuda.is_available():
            gpu = torch.cuda.get_device_properties(0)
            profile.gpu_name = gpu.name
            profile.vram_gb = gpu.total_memory / (1024**3)
            profile.cuda_version = torch.version.cuda
        
        # 内存检测
        mem = psutil.virtual_memory()
        profile.ram_gb = mem.total / (1024**3)
        
        # CPU 检测
        profile.cpu_cores = psutil.cpu_count(logical=False)
        profile.cpu_threads = psutil.cpu_count(logical=True)
        
        return profile
```

### 模型匹配算法

```python
def calculate_max_model_size(profile: HardwareProfile, 
                             quantization: str) -> int:
    """
    计算给定硬件和量化方案下，能运行的最大模型参数
    """
    # 基础公式: 参数数量 * 每个参数的位数 / 8 = 显存占用(字节)
    bits_per_param = {
        'fp16': 16,
        'q8_0': 8,
        'q4_k_m': 4,
        'q4_k_s': 4,
        'q3_k_m': 3,
    }
    
    bits = bits_per_param[quantization]
    
    # 可用显存 = 总显存 - 系统预留(2GB) - KV Cache 预留
    available_vram = profile.vram_gb - 2
    
    # 计算最大参数 (1B 参数 ≈ bits/8 GB)
    max_params = int(available_vram * 8 / bits * 1e9)
    
    # 考虑上下文长度的 KV Cache 开销
    # 粗略估计: 每 1K tokens 需要 0.5GB (取决于模型维度)
    max_params = int(max_params * 0.85)  # 留 15% 余量
    
    return max_params
```

### 评分聚合

```python
def aggregate_score(model: ModelInfo, benchmarks: List[Benchmark]) -> float:
    """
    聚合多个基准测试的评分
    """
    scores = {
        'quality': 0,
        'speed': 0,
        'efficiency': 0,
        'community': 0,
        'quantization': 0,
    }
    
    # 推理质量 (LiveBench + Aider + HumanEval)
    quality_scores = [
        b.score for b in benchmarks 
        if b.name in ['livebench', 'aider', 'humaneval']
    ]
    scores['quality'] = np.mean(quality_scores) if quality_scores else 0
    
    # 速度 (本地实测或社区报告)
    speed_data = get_community_speed_report(model.id)
    scores['speed'] = normalize_speed(speed_data, model.size)
    
    # 加权求和
    weights = {'quality': 0.35, 'speed': 0.25, 'efficiency': 0.20, 
               'community': 0.10, 'quantization': 0.10}
    
    return sum(scores[k] * weights[k] for k in weights)
```

![GitHub Star 增长趋势](../../assets/star-growth-trend.png)

---

## 五、为什么它这么受欢迎？

### 1. 解决了一个真实的痛点

"我能跑什么模型"这个问题，每个本地 LLM 玩家都问过。WhichLLM 把这个需要手动计算、查文档、试错的流程，自动化成了一行命令。

### 2. 数据驱动，不是拍脑袋

评分基于真实基准测试，不是作者的主观偏好。你可以信任它的推荐。

### 3. 持续更新

HuggingFace 每天有新模型，WhichLLM 的数据库每天自动同步：

```bash
# 更新模型数据库
whichllm sync

# 获取最新推荐
whichllm recommend --fresh
```

---

## 六、快速上手

```bash
# 1. 安装
pip install whichllm

# 2. 检测硬件
whichllm detect

# 3. 获取推荐（通用）
whichllm recommend

# 4. 获取推荐（特定任务）
whichllm recommend --task=coding
whichllm recommend --task=chat
whichllm recommend --task=math

# 5. 指定显存限制
whichllm recommend --max-vram=16

# 6. 查看某个模型的详细信息
whichllm info Qwen/Qwen2.5-Coder-32B-Instruct

# 7. 对比两个模型
whichllm compare Qwen2.5-Coder-32B DeepSeek-Coder-V2
```

---

## 七、写在最后

WhichLLM 的流行，反映了本地 LLM 生态的一个关键转变：**从"玩模型"到"用模型"。**

早期的本地 LLM 玩家，享受的是折腾的过程——下载、配置、调参、优化。

但现在，越来越多的开发者只是把本地 LLM 当作工具。他们不想研究量化算法，不想计算显存占用，不想比较几十个模型的 benchmark。

**他们只想知道：我的机器能跑什么？哪个最好？怎么跑？**

WhichLLM 回答的就是这三个问题。

10K Star 说明，这个需求是真实且巨大的。

**未来的本地 LLM 生态，一定会出现更多这样的"决策辅助工具"——让开发者专注于使用，而不是折腾。**

---

*本文数据截至 2026 年 6 月 10 日。项目 Star 数实时变化，请以 GitHub 页面为准。*

*关注本公众号，每天带你发现 GitHub 上增长最快的 AI 新项目。*
