#!/bin/bash
# ============================================================================
#  Runs ON THE CLUSTER (via ssh) to create an isolated virtualenv, install
#  vLLM + vLLM-Omni, and pre-download the OmniVoice model so the compute node
#  can serve it offline. Called by launch_omnivoice.sh.
#
#      setup_omnivoice.sh <work_dir>
#
#  Reads MODULES / PYTHON_BIN / VLLM_VERSION / VLLM_OMNI_SOURCE / MODEL_REF
#  from run.env (uploaded by the orchestrator).
#
#  Safe to re-run: skips creating an existing venv and lets pip resolve
#  incremental upgrades.
# ============================================================================
set -eo pipefail

WORK_DIR="${1:-}"
if [ -z "$WORK_DIR" ]; then
    echo "usage: setup_omnivoice.sh <work_dir>"
    exit 1
fi

if [ -f "${WORK_DIR}/run.env" ]; then
    # shellcheck disable=SC1090
    source "${WORK_DIR}/run.env"
fi

PYTHON_BIN="${PYTHON_BIN:-python3}"
MODULES="${MODULES:-}"
# Default to the latest stable PyPI pair (vllm-omni 0.24.0 <-> vllm 0.24.0,
# CUDA 12 line). For bleeding edge set VLLM_OMNI_SOURCE to git main AND
# VLLM_VERSION to 0.25.0 (CUDA 13). Keep the two versions on the same
# major.minor -- vllm-omni warns/errors on mismatch.
VLLM_OMNI_SOURCE="${VLLM_OMNI_SOURCE:-vllm-omni==0.24.0}"
# vLLM-Omni is a library on top of vLLM: it does NOT declare vLLM or torch as
# dependencies (see vllm-omni/requirements/{common,cuda}.txt), so the matching
# `vllm` wheel -- which provides the `vllm` CLI the SLURM job launches -- must
# be installed first.
VLLM_VERSION="${VLLM_VERSION:-0.24.0}"
VLLM_EXTRA_INDEX="${VLLM_EXTRA_INDEX:-}"
MODEL_REF="${MODEL_REF:-k2-fsa/OmniVoice}"

# Load environment modules (only on systems that have the 'module' command).
if command -v module >/dev/null 2>&1 && [ -n "$MODULES" ]; then
    echo "Loading modules: ${MODULES}"
    # shellcheck disable=SC2086
    module load $MODULES || true
fi

VENV="${WORK_DIR}/venv"
if [ ! -f "${VENV}/bin/activate" ]; then
    echo "Creating virtualenv at ${VENV}"
    "$PYTHON_BIN" -m venv "$VENV"
fi

# shellcheck disable=SC1091
source "${VENV}/bin/activate"
pip install --upgrade pip setuptools wheel >/dev/null

# 1) vLLM itself -- provides the `vllm` CLI and pulls a matching torch+CUDA.
#    Installed from PyPI's default CUDA wheel (predictable on a headless login
#    node; vLLM-Omni's setup.py detects torch -> loads requirements/cuda.txt).
echo "Installing vLLM ${VLLM_VERSION} (provides the 'vllm' CLI + torch)..."
if [ -n "$VLLM_EXTRA_INDEX" ]; then
    pip install "vllm==${VLLM_VERSION}" --extra-index-url "${VLLM_EXTRA_INDEX}"
else
    pip install "vllm==${VLLM_VERSION}"
fi

# 2) vLLM-Omni -- registers the --omni flag, OmniVoiceModel, and the
#    /v1/audio/speech endpoint. This is isolated in this venv and does not
#    affect any separate LLM-hosting venv you may have.
echo "Installing vLLM-Omni from: ${VLLM_OMNI_SOURCE}"
pip install "${VLLM_OMNI_SOURCE}"

# 3) Verify now so we fail loudly here instead of at SLURM time with
#    "vllm: command not found" or an import error (the original failure modes).
if ! command -v vllm >/dev/null 2>&1; then
    echo "ERROR: 'vllm' CLI is not on PATH after install."
    echo "       vLLM ${VLLM_VERSION} did not install correctly."
    exit 1
fi
import_err="$(python -c "import vllm_omni" 2>&1)" || {
    echo "ERROR: 'vllm_omni' did not import -- likely a vLLM/vLLM-Omni version mismatch."
    echo "       vLLM installed : $(python -c 'import vllm; print(vllm.__version__)' 2>/dev/null || echo unknown)"
    echo "       vllm-omni src  : ${VLLM_OMNI_SOURCE}"
    echo "       Real error was:"
    printf '%s\n' "$import_err" | sed 's/^/         /'
    echo "       Hint: align [service] vllm_version with vllm_omni_source in omnivoice.conf"
    echo "             (same major.minor; default stable pair = vllm-omni==0.24.0 + vllm==0.24.0)."
    exit 1
}
echo "vLLM $(python -c 'import vllm; print(vllm.__version__)' 2>/dev/null) + vLLM-Omni ready"

# Keep Hugging Face downloads inside the work dir so they survive across jobs
# and are visible from both the login and compute nodes.
export HF_HOME="${WORK_DIR}/hf_cache"
mkdir -p "${HF_HOME}"

echo "Pre-downloading OmniVoice model: ${MODEL_REF}"
# Pre-download so compute nodes (often offline) can serve from the shared cache.
# Source=huggingface uses the repo id; source=local is rsynced separately.
if [ "${MODEL_SOURCE:-huggingface}" = "huggingface" ]; then
    if ! huggingface-cli download "${MODEL_REF}"; then
        echo "  WARN: could not pre-download ${MODEL_REF} (will retry at serve time)"
    fi
else
    echo "  (source=local -> model was rsynced by the orchestrator; skipping download)"
fi

echo "SETUP_DONE"
