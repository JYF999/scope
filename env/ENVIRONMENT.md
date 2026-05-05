# FIPO（v37）conda 环境（/pfs/yufei/miniconda3/envs）

本目录脚本实际使用的 conda 环境与前缀路径如下（来自你机器现状）：

- 训练/Reward：`/pfs/yufei/miniconda3/envs/reprompt_rl`
- Image 服务：`/pfs/yufei/miniconda3/envs/qwen-image`
- GenEval 服务：`/pfs/yufei/miniconda3/envs/geneval`

为保证“详细且正确”，我已把这 3 个环境的 **完整导出** 放在本目录（可直接用于复现）：

- `conda_env_reprompt_rl.yml`
- `conda_env_qwen-image.yml`
- `conda_env_geneval.yml`

同时也导出了更短的 “from-history” 版本（通常不够完整，仅做参考）：

- `conda_env_reprompt_rl.from-history.yml`
- `conda_env_qwen-image.from-history.yml`
- `conda_env_geneval.from-history.yml`

## 用法（复现到新机器/新账号）

1) 拷贝这些 yml 到目标机器后执行：

```bash
/pfs/yufei/miniconda3/bin/conda env create -f conda_env_reprompt_rl.yml
/pfs/yufei/miniconda3/bin/conda env create -f conda_env_qwen-image.yml
/pfs/yufei/miniconda3/bin/conda env create -f conda_env_geneval.yml
```

2) 如果目标机器 conda 不在 `/pfs/yufei/miniconda3`，需要把 yml 里的 `prefix:` 行删掉或改成目标前缀（推荐直接删掉 `prefix:`）。

## 环境变量

需要的运行时环境变量放在 `env.example.txt`（不包含任何密钥）。

