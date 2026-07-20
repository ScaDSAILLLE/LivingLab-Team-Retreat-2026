#!/bin/bash
# ============================================================================
#  OmniVoice TTS on HPC  -  serve k2-fsa/OmniVoice with vLLM-Omni
# ----------------------------------------------------------------------------
#  A self-contained companion to host_models.sh for the OmniVoice TTS model.
#  It uses the SAME pattern (laptop -> rsync -> SLURM job -> port forward) but
#  targets vLLM-Omni's OpenAI-compatible /v1/audio/speech endpoint instead of
#  the LLM gateway, and keeps its own isolated venv so it never disturbs a
#  vLLM-LLM setup.
#
#  Usage:
#      ./launch_omnivoice.sh [--config FILE] <command>
#
#  Commands:
#      start     sync + install deps, submit SLURM job, forward port, monitor
#      stop      cancel the job and release the local port
#      status    show job state + the URL to call
#      logs      follow the live server log
#      sync      sync code + (optional) local model, run cluster setup
#      forward   (re)establish port forwarding to an already-running job
#      doctor    preflight checks (config, ssh, tools, local model path)
#      help      show this message
#
#  Driven by a single config file (default: ./omnivoice.conf).
# ============================================================================
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/omnivoice.conf"
RUN_DIR="${SCRIPT_DIR}/.run"

# ── Colors (disabled when output is not a terminal) ─────────────────────────
if [ -t 1 ]; then
  C_RESET="\033[0m"; C_BOLD="\033[1m"; C_DIM="\033[2m"
  C_GREEN="\033[32m"; C_YELLOW="\033[33m"; C_RED="\033[31m"
  C_BLUE="\033[34m"; C_CYAN="\033[36m"
else
  C_RESET=""; C_BOLD=""; C_DIM=""; C_GREEN=""; C_YELLOW=""; C_RED=""
  C_BLUE=""; C_CYAN=""
fi

# ── Logging helpers ─────────────────────────────────────────────────────────
info()  { echo -e "${C_CYAN}[INFO]${C_RESET}  $1"; }
ok()    { echo -e "${C_GREEN}[ OK ]${C_RESET}  $1"; }
warn()  { echo -e "${C_YELLOW}[WARN]${C_RESET}  $1"; }
err()   { echo -e "${C_RED}[ERR ]${C_RESET}  $1" >&2; }
step()  { echo -e "\n${C_BOLD}${C_BLUE}==> $1${C_RESET}"; }
die()   { err "$1"; exit 1; }

# ── Config (INI) parser  (same convention as host_models.sh) ────────────────
#   [hpc] host = x          ->  INI_hpc_host="x"
#   [model:omnivoice] k = y ->  MODEL_omnivoice_k="y"  (+ MODEL_NAMES+=("omnivoice"))
parse_ini() {
  awk '
    function strip(v) { if (v ~ /^".*"$/) v = substr(v, 2, length(v) - 2); return v }
    BEGIN { section = "" }
    /^[[:space:]]*#/  { next }
    /^[[:space:]]*;/  { next }
    /^[[:space:]]*$/  { next }
    /^\[.*\]$/ {
      sec = $0
      sub(/^[[:space:]]*\[/, "", sec); sub(/\][[:space:]]*$/, "", sec)
      gsub(/[[:space:]]/, "", sec)
      section = sec
      if (section ~ /^model:/) {
        name = substr(section, 7)
        print "MODEL_NAMES+=(\"" name "\")"
      }
      next
    }
    {
      line = $0
      eq = index(line, "=")
      if (eq == 0) next
      key = substr(line, 1, eq - 1); val = substr(line, eq + 1)
      gsub(/^[[:space:]]+/, "", key); gsub(/[[:space:]]+$/, "", key)
      gsub(/^[[:space:]]+/, "", val); gsub(/[[:space:]]+$/, "", val)
      val = strip(val)
      gsub(/[^A-Za-z0-9_]/, "_", key)
      if (section ~ /^model:/) {
        name = substr(section, 7); gsub(/[^A-Za-z0-9_]/, "_", name)
        print "MODEL_" name "_" key "=\"" val "\""
      } else {
        sec = section; gsub(/[^A-Za-z0-9_]/, "_", sec)
        print "INI_" sec "_" key "=\"" val "\""
      }
    }
  ' "$1"
}

cfg() {  # cfg <section> <key>  -> echoes value (empty if missing)
  local s k v
  s="$(printf '%s' "$1" | tr -c 'A-Za-z0-9_' '_')"
  k="$(printf '%s' "$2" | tr -c 'A-Za-z0-9_' '_')"
  v="INI_${s}_${k}"
  echo "${!v:-}"
}

model_attr() {  # model_attr <name> <key>  -> echoes value
  local n k v
  n="$(printf '%s' "$1" | tr -c 'A-Za-z0-9_' '_')"
  k="$(printf '%s' "$2" | tr -c 'A-Za-z0-9_' '_')"
  v="MODEL_${n}_${k}"
  echo "${!v:-}"
}

is_true() { (echo "${1:-}" | tr '[:upper:]' '[:lower:]') | grep -qxE '1|true|yes|on'; }

expand_tilde() {  # expand a leading ~ to $HOME
  local p="$1"
  if [[ "$p" == "~"* ]]; then echo "${HOME}${p:1}"; else echo "$p"; fi
}

# ── Load + resolve config into globals ──────────────────────────────────────
load_config() {
  [ -f "$CONFIG_FILE" ] || die "Config file not found: ${CONFIG_FILE}
  Hint: cp omnivoice.conf.example omnivoice.conf  &&  edit it."

  MODEL_NAMES=()
  eval "$(parse_ini "$CONFIG_FILE")"

  HPC_HOST="$(cfg hpc host)"
  HPC_USER="$(cfg hpc user)"
  SSH_KEY="$(expand_tilde "$(cfg hpc ssh_key)")"
  WORK_DIR="$(cfg hpc work_dir)"
  HPC_ACCOUNT="$(cfg hpc account)"
  HPC_MODULES="$(cfg hpc modules)"

  JOB_NAME="$(cfg slurm job_name)";       [ -n "$JOB_NAME" ] || JOB_NAME="omnivoice-tts"
  SLURM_GRES="$(cfg slurm gres)";         [ -n "$SLURM_GRES" ] || SLURM_GRES="gpu:1"
  SLURM_CPUS="$(cfg slurm cpus)";         [ -n "$SLURM_CPUS" ] || SLURM_CPUS="8"
  SLURM_MEM="$(cfg slurm mem)";           [ -n "$SLURM_MEM" ] || SLURM_MEM="40G"
  SLURM_TIME="$(cfg slurm time)";         [ -n "$SLURM_TIME" ] || SLURM_TIME="08:00:00"
  SLURM_RESERVATION="$(cfg slurm reservation)"

  SERVICE_PORT="$(cfg service port)";     [ -n "$SERVICE_PORT" ] || SERVICE_PORT="8000"
  LOCAL_PORT="$(cfg service local_port)"; [ -n "$LOCAL_PORT" ] || LOCAL_PORT="$SERVICE_PORT"
  PYTHON_BIN="$(cfg service python)";     [ -n "$PYTHON_BIN" ] || PYTHON_BIN="python3"

  VLLM_OMNI_SOURCE="$(cfg service vllm_omni_source)"
  [ -n "$VLLM_OMNI_SOURCE" ] || VLLM_OMNI_SOURCE="vllm-omni==0.24.0"

  # vLLM-Omni does not depend on vLLM/torch; setup installs matching vLLM first
  # (provides the `vllm` CLI). Keep vllm_version aligned with vllm_omni_source
  # (same major.minor). Default = the latest stable PyPI pair (0.24.0/0.24.0,
  # CUDA 12 line). For bleeding edge set vllm_omni_source to git main AND
  # vllm_version to 0.25.0 (CUDA 13).
  VLLM_VERSION="$(cfg service vllm_version)"
  [ -n "$VLLM_VERSION" ] || VLLM_VERSION="0.24.0"
  VLLM_EXTRA_INDEX="$(cfg service vllm_extra_index_url)"

  # We serve exactly one model; take the first [model:...] block.
  MODEL_NAME="${MODEL_NAMES[0]:-omnivoice}"
  MODEL_SOURCE="$(model_attr "$MODEL_NAME" source)"; [ -n "$MODEL_SOURCE" ] || MODEL_SOURCE="huggingface"
  MODEL_ID="$(model_attr "$MODEL_NAME" model_id)";   [ -n "$MODEL_ID" ] || MODEL_ID="k2-fsa/OmniVoice"

  LOCAL_LOG="${RUN_DIR}/${JOB_NAME}.out"

  # Resolve the SSH target (user@host).
  if [[ "$HPC_HOST" == *@* ]]; then
    SERVER="$HPC_HOST"
  elif [ -n "$HPC_USER" ]; then
    SERVER="${HPC_USER}@${HPC_HOST}"
  else
    SERVER="$HPC_HOST"
  fi
}

# ── SSH / rsync helpers ─────────────────────────────────────────────────────
ssh_cmd() {
  if [ -n "$SSH_KEY" ]; then
    ssh -q -o ConnectTimeout=10 -o ServerAliveInterval=30 -i "$SSH_KEY" "$SERVER" "$@"
  else
    ssh -q -o ConnectTimeout=10 -o ServerAliveInterval=30 "$SERVER" "$@"
  fi
}
rsync_ssh() {
  if [ -n "$SSH_KEY" ]; then echo "ssh -i $SSH_KEY -o ConnectTimeout=10"; else echo "ssh -o ConnectTimeout=10"; fi
}

check_ssh_connection() {
  if ssh_cmd true 2>/dev/null; then ok "SSH connection to ${HPC_HOST}"; else die "Cannot SSH to ${HPC_HOST} (as ${SERVER})."; fi
}

# ── SLURM helpers ───────────────────────────────────────────────────────────
is_job_running() { ssh_cmd "squeue -t running --format=%.100j -n '$1' | grep -q '$1'"; }
get_job_state()  { local s; s="$(ssh_cmd "squeue -n '$1' -o '%T' -h")"; [ -z "$s" ] && s="STOPPED"; echo "$s"; }
get_node_name()  { ssh_cmd "squeue -h -n '$1' -t running -o '%N' | head -n1 | awk -F, '{print \$1}'"; }
get_jobid()      { ssh_cmd "squeue -t running -n '$1' -o '%A' | sed -n '2p'"; }
stop_hpc_job()   { ssh_cmd "scancel -n '$1'" 2>/dev/null || true; }

validate_jobid() {
  local j="$1"
  if [[ "$j" =~ ^[0-9]+$ ]]; then ok "Submitted SLURM job ${j}"; else err "Job submission failed: ${j}"; exit 1; fi
}

# ── Model reference + serve-extra (built from config) ───────────────────────
resolve_model_ref() {
  if [ "$MODEL_SOURCE" = "huggingface" ]; then
    MODEL_REF="$MODEL_ID"
  else
    # local model dir rsynced to <work_dir>/models/<name>/
    MODEL_REF="${WORK_DIR}/models/${MODEL_NAME}"
  fi
}

build_serve_extra() {
  local extra=""
  if is_true "$(model_attr "$MODEL_NAME" trust-remote-code)"; then
    extra="--trust-remote-code"
  elif [ -z "$(model_attr "$MODEL_NAME" trust-remote-code)" ]; then
    # OmniVoice needs trust-remote-code; default it on when unset.
    extra="--trust-remote-code"
  fi
  local dt; dt="$(model_attr "$MODEL_NAME" dtype)"
  [ -n "$dt" ] && extra="$extra --dtype $dt"
  local gpu; gpu="$(model_attr "$MODEL_NAME" gpu-memory-utilization)"
  [ -n "$gpu" ] && extra="$extra --gpu-memory-utilization $gpu"
  local raw; raw="$(model_attr "$MODEL_NAME" extra-args)"
  [ -n "$raw" ] && extra="$extra $raw"
  SERVE_EXTRA="${extra# }"
}

# ── Sync: code + (optional) local model ─────────────────────────────────────
sync_code() {
  info "Syncing server code to ${WORK_DIR}"
  rsync -azr --delete \
    --exclude='.git' --exclude='.run' --exclude='logs' --exclude='__pycache__' \
    -e "$(rsync_ssh)" \
    "${SCRIPT_DIR}/hpc" "${SCRIPT_DIR}/client" \
    "${SERVER}:${WORK_DIR}/" || die "Code sync failed."
}

sync_model() {
  if [ "$MODEL_SOURCE" != "local" ]; then
    info "model '${MODEL_NAME}' is a Hugging Face model (downloaded on the cluster); skipping rsync"
    return
  fi
  local lp; lp="$(expand_tilde "$(model_attr "$MODEL_NAME" local_path)")"
  [ -d "$lp" ] || die "Local model path not found for '${MODEL_NAME}': ${lp}"
  info "Syncing model '${MODEL_NAME}'  (${lp})"
  rsync -azr -e "$(rsync_ssh)" "$lp/" "${SERVER}:${WORK_DIR}/models/${MODEL_NAME}/" \
    || die "Sync failed for model '${MODEL_NAME}'."
  ok "model '${MODEL_NAME}' synced"
}

write_run_env() {
  mkdir -p "$RUN_DIR"
  cat >"${RUN_DIR}/run.env" <<EOF
WORK_DIR='${WORK_DIR}'
MODULES='${HPC_MODULES}'
PYTHON_BIN='${PYTHON_BIN}'
VLLM_VERSION='${VLLM_VERSION}'
VLLM_EXTRA_INDEX='${VLLM_EXTRA_INDEX}'
VLLM_OMNI_SOURCE='${VLLM_OMNI_SOURCE}'
MODEL_REF='${MODEL_REF}'
MODEL_SOURCE='${MODEL_SOURCE}'
JOB_NAME='${JOB_NAME}'
SERVICE_PORT='${SERVICE_PORT}'
EOF
  rsync -az -e "$(rsync_ssh)" "${RUN_DIR}/run.env" "${SERVER}:${WORK_DIR}/run.env" \
    || die "Could not upload run.env."
}

run_setup_remote() {
  info "Installing vLLM-Omni on the cluster (first run may take a while)..."
  if ! ssh_cmd "bash ${WORK_DIR}/hpc/setup_omnivoice.sh '${WORK_DIR}'" 2>&1 | sed 's/^/    /'; then
    die "Dependency setup failed on the cluster."
  fi
  ok "Dependencies ready"
}

# ── Render + submit SLURM job ───────────────────────────────────────────────
render_sbatch() {
  local tmpl="${SCRIPT_DIR}/hpc/run_omnivoice.sbatch.template"
  local modules_load=""
  [ -n "$HPC_MODULES" ] && modules_load="module load ${HPC_MODULES}"
  local out="${RUN_DIR}/run.sbatch"
  sed \
    -e "s!__JOB_NAME__!${JOB_NAME}!g" \
    -e "s!__GRES__!${SLURM_GRES}!g" \
    -e "s!__CPUS__!${SLURM_CPUS}!g" \
    -e "s!__MEM__!${SLURM_MEM}!g" \
    -e "s!__TIME__!${SLURM_TIME}!g" \
    -e "s!__ACCOUNT__!${HPC_ACCOUNT}!g" \
    -e "s!__WORK_DIR__!${WORK_DIR}!g" \
    -e "s!__MODULES_LOAD__!${modules_load}!g" \
    -e "s!__SERVICE_PORT__!${SERVICE_PORT}!g" \
    -e "s!__MODEL_REF__!${MODEL_REF}!g" \
    -e "s!__SERVE_EXTRA__!${SERVE_EXTRA}!g" \
    "$tmpl" >"$out"

  if [ -n "$SLURM_RESERVATION" ]; then
    sed -i "s!#__SBATCH_RESERVATION__!#SBATCH --reservation=${SLURM_RESERVATION}!g" "$out"
  else
    sed -i "/#__SBATCH_RESERVATION__/d" "$out"
  fi

  rsync -az -e "$(rsync_ssh)" "$out" "${SERVER}:${WORK_DIR}/hpc/run.sbatch" \
    || die "Could not upload run.sbatch."
}

submit_job() {
  ssh_cmd "mkdir -p ${WORK_DIR}/logs"
  local jobid
  local err
  jobid="$(ssh_cmd "sbatch --parsable -D ${WORK_DIR} ${WORK_DIR}/hpc/run.sbatch" 2> /tmp/omnivoice_sbatch_err)"
  err=$(cat /tmp/omnivoice_sbatch_err 2>/dev/null)
  echo "$jobid" >"${RUN_DIR}/JOBID"
  validate_jobid "$jobid"
}

# ── Log streaming from the cluster ──────────────────────────────────────────
sync_log_once() { rsync -az -e "$(rsync_ssh)" "${SERVER}:${WORK_DIR}/logs/${JOB_NAME}.out" "${RUN_DIR}/${JOB_NAME}.out" 2>/dev/null || true; }

show_remote_log_tail() {
  warn "Last lines of the cluster log for '${JOB_NAME}':"
  ssh_cmd "tail -n 30 ${WORK_DIR}/logs/${JOB_NAME}.out" 2>/dev/null | sed 's/^/    /' || true
}

wait_for_ready() {
	# set -x
  info "Waiting for '${JOB_NAME}' to finish loading OmniVoice..."
  local waited=0
  while true; do
    if ! is_job_running "$JOB_NAME"; then
      if [ "$(get_job_state "$JOB_NAME")" = "STOPPED" ]; then
        err "Job '${JOB_NAME}' stopped before the server became ready."
        show_remote_log_tail
        return 1
      fi
    fi
    sync_log_once
    if [ -f "$LOCAL_LOG" ]; then
      if grep -q 'SERVER_READY' "$LOCAL_LOG" 2>/dev/null; then
        ok "'${JOB_NAME}' is ready"
        sleep 1
        return 0
      fi
      if grep -q 'SERVER_FAILED' "$LOCAL_LOG" 2>/dev/null; then
        err "Server failed to start."
        show_remote_log_tail
        return 1
      fi
    fi
    sleep 5; waited=$((waited + 5))
    if [ $((waited % 30)) -eq 0 ]; then info "still waiting for '${JOB_NAME}' (${waited}s)..."; fi
  done
#   set +x
}

# ── Port forwarding ─────────────────────────────────────────────────────────
free_local_port() {
  if command -v lsof >/dev/null 2>&1 && lsof -i :"$1" >/dev/null 2>&1; then
    warn "Local port $1 is in use, freeing it..."
    lsof -i :"$1" | awk 'NR>1{print $2}' | sort -u | xargs -r kill -9 2>/dev/null || true
    sleep 1
  fi
}

port_forward() {
  local node; node="$(get_node_name "$JOB_NAME")"
  [ -n "$node" ] || die "Could not determine the compute node name."
  free_local_port "$LOCAL_PORT"
  info "Port forwarding  localhost:${LOCAL_PORT}  ->  ${node}:${SERVICE_PORT}"
  if [ -n "$SSH_KEY" ]; then
    ssh -i "$SSH_KEY" -o ConnectTimeout=10 -o ServerAliveInterval=30 \
      -L "${LOCAL_PORT}:${node}:${SERVICE_PORT}" "$SERVER" -N -f || die "Port forwarding failed (port ${LOCAL_PORT} may still be in use)."
  else
    ssh -o ConnectTimeout=10 -o ServerAliveInterval=30 \
      -L "${LOCAL_PORT}:${node}:${SERVICE_PORT}" "$SERVER" -N -f || die "Port forwarding failed (port ${LOCAL_PORT} may still be in use)."
  fi
  ok "Forward established (localhost:${LOCAL_PORT})"
}

# ── Status / access info ────────────────────────────────────────────────────
print_access_info() {
  echo
  echo -e "${C_GREEN}${C_BOLD}  OmniVoice is live!${C_RESET}"
  echo -e "  ${C_DIM}------------------------------------------${C_RESET}"
  echo -e "  Speech  : ${C_CYAN}POST http://localhost:${LOCAL_PORT}/v1/audio/speech${C_RESET}"
  echo -e "  Models  : http://localhost:${LOCAL_PORT}/v1/models"
  echo -e "  Health  : http://localhost:${LOCAL_PORT}/health"
  echo -e "  ${C_DIM}------------------------------------------${C_RESET}"
  echo -e "  ${C_BOLD}Quick test (auto voice):${C_RESET}"
  echo -e "  ${C_DIM}curl -X POST http://localhost:${LOCAL_PORT}/v1/audio/speech \\${C_RESET}"
  echo -e "  ${C_DIM}  -H 'Content-Type: application/json' \\ ${C_RESET}"
  echo -e "  ${C_DIM}  -d '{\"input\":\"Hello, how are you?\",\"response_format\":\"wav\"}' \\ ${C_RESET}"
  echo -e "  ${C_DIM}  -o out.wav ${C_RESET}"
  echo
  echo -e "  ${C_DIM}Or use the client:${C_RESET}"
  echo -e "  ${C_DIM}  python client/speech_client.py --api-base http://localhost:${LOCAL_PORT} --text 'Hello, how are you?'${C_RESET}"
}

# ── Commands ────────────────────────────────────────────────────────────────
cmd_sync() {
  step "Connecting to HPC";    check_ssh_connection
  step "Syncing server code";  sync_code
  step "Syncing model";        sync_model
  step "Installing deps";      resolve_model_ref; write_run_env; run_setup_remote
  ok "Sync complete."
}

cmd_start() {
  step "Connecting to HPC";    check_ssh_connection
  step "Syncing server code";  sync_code
  step "Syncing model";        sync_model
  step "Installing deps";      resolve_model_ref; write_run_env; run_setup_remote
  step "Rendering SLURM job";  resolve_model_ref; build_serve_extra; render_sbatch
  step "Submitting SLURM job"; submit_job
  step "Waiting for server";   wait_for_ready || exit 1
  step "Port forwarding";      port_forward
  print_access_info
  step "Monitoring"
  info "Ctrl-C tears down forwarding but leaves the cluster job running."
  info "Use './launch_omnivoice.sh stop' to cancel the job, 'logs' to follow."
  while true; do
    if ! is_job_running "$JOB_NAME"; then
      warn "Job '${JOB_NAME}' is no longer running ($(get_job_state "$JOB_NAME"))."
      warn "Re-run './launch_omnivoice.sh start' to relaunch."
      break
    fi
    sleep 15
  done
}

cmd_stop() {
  step "Stopping OmniVoice job"
  stop_hpc_job "$JOB_NAME"
  free_local_port "$LOCAL_PORT"
  ok "Stopped. Cluster job cancelled, port forwarding released."
}

cmd_status() {
  local state node jid
  state="$(get_job_state "$JOB_NAME")"
  node="$(get_node_name "$JOB_NAME")"
  jid="$(get_jobid "$JOB_NAME")"
  echo -e "${C_BOLD}Job  :${C_RESET} ${JOB_NAME}  (${state})"
  [ -n "$jid" ]  && echo -e "${C_BOLD}ID   :${C_RESET} ${jid}"
  [ -n "$node" ] && echo -e "${C_BOLD}Node :${C_RESET} ${node}"
  echo -e "${C_BOLD}Model:${C_RESET} ${MODEL_ID}  (source: ${MODEL_SOURCE})"
  if [ "$state" = "RUNNING" ]; then
    echo -e "${C_BOLD}URL  :${C_RESET} ${C_CYAN}http://localhost:${LOCAL_PORT}/v1/audio/speech${C_RESET}"
  fi
}

cmd_logs() {
  info "Tailing cluster log for '${JOB_NAME}' (Ctrl-C to stop)..."
  sync_log_once
  # Follow the remote log directly.
  exec ssh_cmd "tail -n 50 -f ${WORK_DIR}/logs/${JOB_NAME}.out"
}

cmd_forward() {
  step "Connecting to HPC"; check_ssh_connection
  if ! is_job_running "$JOB_NAME"; then die "Job '${JOB_NAME}' is not running."; fi
  step "Port forwarding";   port_forward
  print_access_info
}

cmd_doctor() {
  local problems=0
  step "Checking tools"
  for t in ssh rsync; do
    if command -v "$t" >/dev/null 2>&1; then ok "found: $t"; else err "missing: $t"; problems=$((problems+1)); fi
  done
  step "Checking config"
  [ -n "$HPC_HOST" ] && ok "hpc.host = ${HPC_HOST}" || { err "hpc.host not set"; problems=$((problems+1)); }
  [ -n "$WORK_DIR" ] && ok "hpc.work_dir = ${WORK_DIR}" || { err "hpc.work_dir not set"; problems=$((problems+1)); }
  step "Checking SSH"
  check_ssh_connection
  if [ "$MODEL_SOURCE" = "local" ]; then
    step "Checking local model"
    local lp; lp="$(expand_tilde "$(model_attr "$MODEL_NAME" local_path)")"
    [ -d "$lp" ] && ok "local_path exists: ${lp}" || { err "local_path not found: ${lp}"; problems=$((problems+1)); }
  else
    step "Checking model"
    ok "model_id = ${MODEL_ID} (downloaded on the cluster)"
  fi
  echo
  [ "$problems" -eq 0 ] && ok "All checks passed." || { err "${problems} problem(s) found."; exit 1; }
}

show_help() {
  sed -n '3,25p' "${BASH_SOURCE[0]}"
}

# ── Argument parsing + dispatch ─────────────────────────────────────────────
mkdir -p "$RUN_DIR"

while [ $# -gt 0 ]; do
  case "$1" in
    --config) CONFIG_FILE="$2"; shift 2;;
    -h|--help) show_help; exit 0;;
    start|stop|status|logs|sync|forward|doctor|help) COMMAND="$1"; shift; break;;
    *) die "Unknown argument: $1 (try 'help')";;
  esac
done

load_config
case "${COMMAND:-help}" in
  start)   cmd_start;;
  stop)    cmd_stop;;
  status)  cmd_status;;
  logs)    cmd_logs;;
  sync)    cmd_sync;;
  forward) cmd_forward;;
  doctor)  cmd_doctor;;
  help)    show_help;;
esac
