# v45 Environment Guide

`v45` 是多服务训练方案，建议拆分为 3 套环境。

## 推荐环境划分

1. `reprompt_rl`（训练 + reward + span client）
2. `sd3-medium`（image server）
3. `geneval`（geneval reward server）

## 训练环境（reprompt_rl）最小依赖

可先用 `env/requirements.txt`：

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r env/requirements.txt
```

> 实际大规模训练通常使用 conda + CUDA 对齐环境（与本机已有环境一致）。

## 关键说明

- `span_server.py` 依赖 `vllm`（如果你直接复用 `v36` span server）。
- `image_server.py` 依赖 diffusers/torch/cuda 相关组件，建议单独环境。
- `geneval_reward_server.py` 依赖 mmdet/open_clip，建议单独环境。

## 现有机器路径（示例）

- `/pfs/yufei/miniconda3/envs/reprompt_rl`
- `/pfs/yufei/miniconda3/envs/sd3-medium`
- `/pfs/yufei/miniconda3/envs/geneval`

## 可复现建议

- 冻结当前环境（导出 conda yml 或 pip freeze）
- 将模型路径、数据路径通过环境变量暴露
- 不把私有 key（如 wandb key）写入仓库
