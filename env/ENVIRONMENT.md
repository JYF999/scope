# Conda 环境导出说明

本目录包含用于 **复现多服务训练** 的 Conda 环境导出文件（从一台已配置好的机器导出）。文件名表示用途，**不绑定**任何内部实验代号。

## 文件列表

**完整导出（推荐用于复现）：**

- `conda_env_reprompt_rl.yml` — 训练 / reward 客户端等  
- `conda_env_qwen-image.yml` — 图像生成服务（示例环境名：`qwen-image`）  
- `conda_env_geneval.yml` — GenEval 类评分服务  

**精简 from-history（依赖可能不完整，仅供参考）：**

- `conda_env_reprompt_rl.from-history.yml`  
- `conda_env_qwen-image.from-history.yml`  
- `conda_env_geneval.from-history.yml`  

## 在新机器上创建环境

将本目录复制到目标机器后执行（将 `conda` 换为你的安装路径）：

```bash
conda env create -f conda_env_reprompt_rl.yml
conda env create -f conda_env_qwen-image.yml
conda env create -f conda_env_geneval.yml
```

若 YAML 末尾含 **`prefix:`** 且仍指向导出者的本机路径，请在创建前 **删除该行** 或改为目标机前缀（删除更简单）。

## 环境变量模板

见同目录下的 **`env.example.txt`**（不含密钥）。训练与服务启动前可 `source` 一份本地副本。
