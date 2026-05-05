# Scope

本仓库用于**可复现的文本到图像提示优化研究**：在策略梯度框架下做训练，并配合外部 **reward**、**图像生成**、**评测** 等 HTTP 服务。目录按「论文附录式代码发布」组织，便于他人克隆后替换路径与模型即可运行。

## 目标读者

- 需要复现实验或对比方法的同行  
- 需要清晰目录结构、环境文件与启动脚本，而不依赖内部实验代号或私有命名习惯  

## 功能概览

- **分布式训练**：通过 `torchrun` 与 DeepSpeed（见 `configs/`）启动多卡训练。  
- **Span 与正则化**：训练实现支持在 completion 上做 **span 级 pooling** 与 **future-KL** 类正则（具体超参由环境变量与训练脚本共同决定）。  
- **多服务协同**：训练进程通过 HTTP 调用 reward；典型部署还包括图像生成服务、GenEval 类评分服务等（见 `docs/QUICKSTART.md`）。  
- **可选 LLM 分段**：若你所使用的训练入口支持 HTTP span 服务，可通过 `SPAN_*` 环境变量接入；否则启动脚本中的相关变量可被忽略。  

## 目录结构

| 路径 | 说明 |
|------|------|
| `src/` | Python 入口：训练、各服务端包装或加载逻辑 |
| `scripts/` | Shell 启动脚本（训练、tmux 等） |
| `configs/` | 训练侧配置（如 DeepSpeed JSON） |
| `env/` | Conda 导出、环境变量模板、精简 pip 列表 |
| `data/` | 默认数据与示例列表（路径请用环境变量覆盖） |
| `docs/` | 本说明与快速开始 |
| `logs/` | 训练日志（由脚本 `tee` 写入） |
| `outputs/` |  checkpoint 与训练输出 |

## 文档索引

- **上手命令与依赖顺序**：[`docs/QUICKSTART.md`](QUICKSTART.md)  
- **多 Conda 环境与导出文件说明**：[`docs/ENVIRONMENT.md`](ENVIRONMENT.md)  
- **与 `env/` 中环境说明一致**：仓库根下 `env/ENVIRONMENT.md`、`env/env.example.txt`  

## 自包含与路径

默认 `src/train.py` 可能仍指向**本机其他路径**上的完整训练脚本（便于与你现有工作区共用一份实现）。若要将本仓库单独发布到 GitHub，请将该入口改为**仓库内相对路径**或拷贝训练脚本到 `src/`，并同步修改文档中的说明。

## 许可与引用

发布前请自行添加 `LICENSE` 与论文引用信息；勿将 API 密钥、私有数据路径写入已提交的示例文件。
