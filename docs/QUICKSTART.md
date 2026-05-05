# 快速开始

以下命令以「克隆后进入仓库根目录」为前提；**请将所有绝对路径改为你机器上的路径**（可用环境变量统一配置）。

## 1. 环境准备

典型部署需要 **三套 Python 环境**（也可合并，但依赖冲突多）：

| 角色 | 用途 | 说明 |
|------|------|------|
| 训练 | 策略模型、DeepSpeed、`torchrun` | 与 CUDA / PyTorch 版本对齐 |
| 图像服务 | 扩散模型推理（如 SD3 API） | 体积大、依赖独立 |
| GenEval 类服务 | 检测 / CLIP 等评测 | 常含 `mmdet` 等重型依赖 |

在新机器上建议用 `env/` 下的 Conda YAML 创建环境，步骤见 [`ENVIRONMENT.md`](ENVIRONMENT.md)。

## 2. 建议的环境变量

复制模板后按需编辑：

```bash
cd /path/to/scope
cp env/env.example.txt .env.local
# 编辑 .env.local：MODEL_PATH、DATA_PATH、REWARD_ENDPOINTS、conda 路径等
source .env.local
```

训练脚本还会读取例如 `MAX_STEPS`、`NUM_GEN`、`WANDB_MODE` 等；见 `env/env.example.txt` 内注释。

## 3. 启动顺序（多服务）

1. **GenEval（或等价）评分服务**（若 reward 链路需要）  
2. **图像生成服务**（若 reward 需要现场出图）  
3. **Reward 协调服务**（聚合上述能力，对训练暴露 HTTP）  
4. **（可选）Span 分段服务**：仅当你的训练入口会请求 `SPAN_ENDPOINTS` 时需要；依赖与训练环境可能不同（例如需单独安装推理引擎）。  
5. **训练**：使用 `scripts/start_local_8gpu.sh` 或自行调用 `torchrun`。

示例（路径请替换）：

```bash
# 仅当你的训练代码会调用 LLM span HTTP 接口时启用；端口与命令以你实际服务为准
export SPAN_ENDPOINTS="http://127.0.0.1:6100"

/path/to/miniconda3/envs/<train-env>/bin/python src/span_server.py --port 6100
```

## 4. 启动训练

```bash
cd /path/to/scope
export WANDB_MODE=disabled          # 无密钥时建议关闭
export MAX_STEPS=1000               # 示例；按实验修改
export REWARD_ENDPOINTS="http://127.0.0.1:5000"

./scripts/start_local_8gpu.sh
```

默认日志：`logs/training_local_8gpu.log`（由 `scripts/start_local_8gpu.sh` 内 `tee` 写入）。

可调环境变量包括：`NPROC_TRAIN`、`CUDA_VISIBLE_DEVICES`（在脚本内）、`MASTER_PORT`、`DATA_PATH`、`MODEL_PATH`、`OUT_DIR` 等；详见 `scripts/start_local_8gpu.sh`。

## 5. 后台运行（tmux）

```bash
cd /path/to/scope
./scripts/start_scope_tmux.sh
tmux attach -t scope_train
```

## 6. 常见问题

- **日志为空**  
  请通过 `scripts/start_local_8gpu.sh` 启动；不要只运行无重定向的 `torchrun`，否则不会写入 `logs/`。

- **WandB 报未配置 API Key**  
  设置 `WANDB_MODE=disabled`，或在环境中配置 `WANDB_API_KEY`。

- **Reward 连接被拒绝**  
  确认 `REWARD_ENDPOINTS` 与 reward 进程监听地址一致，且已先于训练启动。

- **DeepSpeed 找不到配置文件**  
  默认训练入口会将工作目录切到 `configs/`，使 `ds_zero2_bf16.json` 仅保留一份在 `configs/` 下即可。

- **显存不足**  
  减小 `PER_DEVICE_TRAIN_BATCH_SIZE`、`NUM_GEN`，或增加 GPU 数；与模型体量强相关，需自行压测。
