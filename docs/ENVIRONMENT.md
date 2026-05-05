# 环境与依赖说明

本仓库面向 **多进程、多服务** 训练：训练进程、图像生成、基于检测或 CLIP 的评分等往往 **不宜混在同一 Conda 环境**。下面给出推荐拆分与文件用途。

## 推荐环境拆分

1. **训练环境**：大语言模型策略、DeepSpeed、与训练侧 HTTP 客户端（访问 reward）。  
2. **图像生成环境**：扩散管线、CUDA 上的大权重推理。  
3. **评测 / GenEval 环境**：检测、分割、CLIP 等评测依赖。

`env/` 目录下提供了从一台已跑通机器导出的 **完整 Conda YAML**（含 `pip` 子依赖），便于在新机器复现：

- `conda_env_reprompt_rl.yml` — 训练侧示例名：`reprompt_rl`  
- `conda_env_qwen-image.yml` — 图像服务侧示例名：`qwen-image`  
- `conda_env_geneval.yml` — 评测服务侧示例名：`geneval`  

另有 `*.from-history.yml` 为精简导出，**复现完整性通常不如完整 YAML**，仅作参考。

## 创建环境（示例）

```bash
conda env create -f env/conda_env_reprompt_rl.yml
conda env create -f env/conda_env_qwen-image.yml
conda env create -f env/conda_env_geneval.yml
```

若 YAML 中含 `prefix:` 指向他人机器路径，在目标机上 **删除或改写 `prefix:`** 行后再创建（推荐删除，由 Conda 自动选择前缀）。

## 与训练脚本的对应关系

- **`src/span_server.py`**（若使用）：通常需要能加载大模型的推理栈；是否与训练共用环境取决于你的安装方式。  
- **`src/image_server.py`**：建议放在图像专用环境中，用 `uvicorn` 启动。  
- **`src/geneval_reward_server.py`**：建议放在 GenEval 专用环境中。  

具体启动命令以 `docs/QUICKSTART.md` 为准。

## 最小 pip 列表

`env/requirements.txt` 仅覆盖训练侧 **一小部分** pip 依赖；完整复现请优先以 Conda YAML 为准。

## 环境变量

运行时变量模板见 **`env/env.example.txt`**。请勿将 API 密钥、内网路径提交到公开分支；用本地 `.env.local`（已加入忽略规则则更好）覆盖即可。
