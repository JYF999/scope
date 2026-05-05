#!/bin/bash
set -euo pipefail

PROJECT_ROOT="/pfs/yufei/Reprompt/test/scope"
WORK_DIR="${PROJECT_ROOT}"
cd "${WORK_DIR}"

CONDA_BASE="/pfs/yufei/miniconda3"
ENV_TRAIN="${CONDA_BASE}/envs/reprompt_rl"

export SPAN_BACKEND="${SPAN_BACKEND:-http}"
export SPAN_ENDPOINTS="${SPAN_ENDPOINTS:-http://127.0.0.1:6100}"
export SPAN_TIMEOUT="${SPAN_TIMEOUT:-120}"
export SPAN_MAX_SPANS="${SPAN_MAX_SPANS:-0}"
export SPAN_CACHE_SIZE="${SPAN_CACHE_SIZE:-20000}"

MASTER_PORT=${MASTER_PORT:-29500}
NPROC_TRAIN=${NPROC_TRAIN:-2}
MODEL_PATH=${MODEL_PATH:-"/pfs/yufei/model/Qwen3-8B"}
DATA_PATH=${DATA_PATH:-"${PROJECT_ROOT}/data/train_metadata.jsonl"}
OUT_DIR=${OUT_DIR:-"${PROJECT_ROOT}/outputs/out"}
NUM_GEN=${NUM_GEN:-8}

export PER_DEVICE_TRAIN_BATCH_SIZE="${PER_DEVICE_TRAIN_BATCH_SIZE:-8}"
export GRAD_ACC_STEPS="${GRAD_ACC_STEPS:-4}"
export MAX_STEPS="${MAX_STEPS:-1250}"
export REWARD_ENDPOINTS="${REWARD_ENDPOINTS:-http://127.0.0.1:5000}"
export REWARD_TIMEOUT="${REWARD_TIMEOUT:-1800}"

mkdir -p "${PROJECT_ROOT}/logs" "${OUT_DIR}"
LOG_FILE="${PROJECT_ROOT}/logs/training_local_8gpu.log"

env CUDA_VISIBLE_DEVICES=0,1 \
  "${ENV_TRAIN}/bin/torchrun" \
  --nnodes=1 \
  --nproc_per_node="${NPROC_TRAIN}" \
  --node_rank=0 \
  --master_addr=127.0.0.1 \
  --master_port="${MASTER_PORT}" \
  src/train.py \
  --data "${DATA_PATH}" \
  --model "${MODEL_PATH}" \
  --outdir "${OUT_DIR}" \
  --num_gen "${NUM_GEN}" \
  --per_device_train_batch_size "${PER_DEVICE_TRAIN_BATCH_SIZE}" \
  --gradient_accumulation_steps "${GRAD_ACC_STEPS}" \
  2>&1 | tee "${LOG_FILE}"
