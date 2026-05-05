# v45 Quickstart

本目录用于快速复现 `scope` 训练流程（来自 v45 版本整理）。

## 1) 环境准备

推荐使用你当前机器上的 3 套环境：

- 训练/Reward：`/pfs/yufei/miniconda3/envs/reprompt_rl`
- 图像服务：`/pfs/yufei/miniconda3/envs/sd3-medium`
- GenEval：`/pfs/yufei/miniconda3/envs/geneval`

如果你要在新机器搭环境，请参考 `ENVIRONMENT.md`。

## 2) 关键路径（默认值）

- 训练模型：`/pfs/yufei/model/Qwen3-8B`
- 训练数据：`/pfs/yufei/Reprompt/test/scope/data/train_metadata.jsonl`
- 输出目录：`/pfs/yufei/Reprompt/test/scope/outputs/out`
- 训练日志：`/pfs/yufei/Reprompt/test/scope/logs/training_local_8gpu.log`

可选：先加载模板环境变量

```bash
cd /pfs/yufei/Reprompt/test/scope
cp env/env.example.txt .env.local
source .env.local
```

## 3) 启动 span server（必须）

```bash
cd /pfs/yufei/Reprompt/test/scope
/pfs/yufei/miniconda3/envs/reprompt_rl/bin/python src/span_server.py --port 6100
```

> 说明：`train.py` 会通过 `SPAN_ENDPOINTS` 拉取 LLM spans。  
> 若不启服务，将退化为 fallback span，不是完整 LLM span 流程。

## 4) 启动训练（已有 image/geneval/reward 服务）

```bash
cd /pfs/yufei/Reprompt/test/scope

export SPAN_ENDPOINTS="http://127.0.0.1:6100"
export WANDB_MODE=disabled
export MAX_STEPS=2   # 冒烟建议，正式训练请调大

./scripts/start_local_8gpu.sh
```

## 5) tmux 后台运行

```bash
cd /pfs/yufei/Reprompt/test/scope
./scripts/start_scope_tmux.sh
tmux attach -t scope_train
```

## 6) 核心环境变量

- `SPAN_ENDPOINTS`：LLM span 服务地址（逗号分隔）
- `SPAN_MAX_SPANS`：默认 `0`（不限制）
- `REWARD_ENDPOINTS`：reward 服务地址（逗号分隔）
- `MAX_STEPS`：训练步数（通过环境变量生效）
- `WANDB_MODE`：建议默认 `disabled`

## 7) 常见问题

- **Q: logs 下没有训练日志？**  
  A: 请通过 `start_local_8gpu.sh` 启动。脚本内置 `tee` 写日志。

- **Q: 提示 wandb API key 错误？**  
  A: 设置 `WANDB_MODE=disabled`，或自行配置 `WANDB_API_KEY`。

- **Q: span 划分不生效？**  
  A: 确认 `SPAN_ENDPOINTS` 指向可访问的 span server，且服务端环境包含 `vllm`。
