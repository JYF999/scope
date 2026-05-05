#!/bin/bash
set -euo pipefail

WORK_DIR="/pfs/yufei/Reprompt/test/scope"
START="${WORK_DIR}/scripts/start_local_8gpu.sh"
SESSION_NAME="scope_train"
ATTACH=0

for a in "$@"; do
  case "$a" in
    --attach|-a) ATTACH=1 ;;
    -h|--help)
      echo "用法: ./start_scope_tmux.sh [session_name] [--attach|-a]"
      exit 0
      ;;
  esac
done

for a in "$@"; do
  case "$a" in
    --attach|-a|-h|--help) ;;
    *) if [[ "$a" != -* ]]; then SESSION_NAME="$a"; break; fi ;;
  esac
done

chmod +x "${START}" 2>/dev/null || true
INNER="cd $(printf %q "$WORK_DIR") && ./scripts/start_local_8gpu.sh; st=\$?; echo; echo \"[exit \${st}]\"; exec bash -l"

if [ "$ATTACH" -eq 1 ]; then
  tmux new-session -s "$SESSION_NAME" -c "$WORK_DIR" bash -c "$INNER"
else
  tmux new-session -d -s "$SESSION_NAME" -c "$WORK_DIR" bash -c "$INNER"
  echo "已在 tmux 中启动: ${SESSION_NAME}"
fi
