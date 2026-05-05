# scope

`scope` 是在 `v43` 基础上演进的实验目录（原 v45），核心目标是：

- 保留 **span-FIPO** 训练主干（future-KL + span pooling）
- 将 span 划分来源切换为 **LLM span splitter**（HTTP span server）
- 支持本地多服务协同训练（train + image + geneval + reward）

## 核心特性

- **训练器**：`train.py`（基于 `v43` 的 FIPO trainer）
- **LLM 划分 span**：通过 `SPAN_ENDPOINTS` 调用 span server
- **fallback 策略**：当 LLM span 不可用时，自动回退到固定窗口 span，避免训练中断
- **数据**：默认使用 `dataset/train_metadata.jsonl`

## 目录结构

- `src/`：核心训练入口（`src/train.py`）
- `scripts/`：运行脚本与服务入口（训练、tmux、span/reward/image/geneval）
- `configs/`：配置文件（如 deepspeed json）
- `env/`：环境依赖与环境变量模板
- `data/`：数据说明与数据路径约定
- `docs/`：项目文档
- `logs/`：训练日志输出
- `outputs/`：模型与中间产物输出

## 快速开始

请先看 `QUICKSTART.md`，其中包含：

1. 环境准备
2. 服务启动顺序
3. 最小可跑通命令
4. 常见问题

## 环境与依赖

- Python 依赖清单：`env/requirements.txt`（训练环境基础依赖）
- 环境说明：`ENVIRONMENT.md`（多环境方案：reprompt_rl / sd3-medium / geneval）
- 环境变量模板：`env/env.example.txt`（复制后 `source` 使用）

> 注意：本项目是多服务架构，通常至少需要 3 个环境（训练、图像生成、GenEval）。  
> 单一 `requirements.txt` 只覆盖训练侧最小依赖。
