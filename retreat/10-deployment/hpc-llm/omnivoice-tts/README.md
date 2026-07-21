# OmniVoice TTS on HPC (vLLM-Omni)

Serve **[k2-fsa/OmniVoice](https://github.com/k2-fsa/OmniVoice)** — a
zero-shot multilingual TTS model (600+ languages) — on a GPU cluster and call
it from your laptop through a single OpenAI-compatible URL.

This is a self-contained companion to the main vLLM LLM host. The LLM host
(`host_models.sh` + `server/serve.py`) targets text/chat/embedding models via
`vllm serve`. OmniVoice is a **TTS** model, so this example uses
**[vLLM-Omni](https://github.com/vllm-project/vllm-omni)**, which extends vLLM
with native OmniVoice support (`OmniVoiceModel`) and exposes the OpenAI
`POST /v1/audio/speech` endpoint. It keeps its **own isolated venv** so it
never disturbs an LLM-hosting setup.

```
   your laptop                                  GPU cluster
  ┌──────────────────┐     rsync code+model   ┌──────────────────────────┐
  │ omnivoice.conf   │ ─────────────────────▶ │ venv + vllm-omni         │
  │ launch_omnivoice │   ssh + sbatch         │  └─ vllm serve           │
  │  .sh             │ ◀────────────────────  │     k2-fsa/OmniVoice     │ :8000
  └────────┬─────────┘   port forward 8000    │     --omni               │  ◀ public
           ▼                                    └──────────────────────────┘
  http://localhost:8000/v1/audio/speech   ←  one URL, OpenAI TTS API
```

---

## Why vLLM-Omni?

OmniVoice is not an OpenAI-compatible LLM, so the LLM gateway can't serve it
directly. vLLM-Omni is the official vLLM extension for omni-modality / TTS /
diffusion models and lists OmniVoice as a
[supported model](https://vllm-omni.readthedocs.io/en/latest/models/supported_models/).
Launching it is just:

```bash
vllm serve k2-fsa/OmniVoice --omni --trust-remote-code --port 8000
```

That single command starts an OpenAI-compatible server with
`POST /v1/audio/speech`. This example wraps it in the same SSH/rsync/SLURM/
port-forward lifecycle as the main tool, plus a ready-to-run client.

---

## Quick start (3 steps)

```bash
# 1. Configure: copy the example and point it at your cluster
cp omnivoice.conf.example omnivoice.conf
$EDITOR omnivoice.conf          # set host, user, ssh_key, workspace_filesystem, workspace_name, modules

# 2. Check everything is wired up (SSH, tools, config)
./launch_omnivoice.sh doctor

# 3. Go!
./launch_omnivoice.sh start
```

When you see `OmniVoice is live!`, synthesize speech:

```bash
# Auto voice: omit "voice" (the server registers no named voices; "default" is
# rejected with "Supported: none"). Omitting the field triggers auto voice.
curl -X POST http://localhost:8000/v1/audio/speech \
     -H 'Content-Type: application/json' \
     -d '{"input":"Hello, how are you?","response_format":"wav"}' \
     -o out.wav
```

Stop everything with `./launch_omnivoice.sh stop`.

---

## Commands

| Command   | What it does                                                                |
|-----------|-----------------------------------------------------------------------------|
| `start`   | Create/verify workspace, sync code + model, install deps, submit the SLURM job, wait for ready, forward the port, then monitor. |
| `stop`    | Cancel the cluster job and release the local port.                          |
| `status`  | Show the SLURM job state, node, and the URL to call.                        |
| `logs`    | Follow the live server log.                                                 |
| `sync`    | Create/verify workspace, sync code + model, and run cluster setup, without starting a job. |
| `forward` | Re-establish port forwarding to an already-running job.                     |
| `doctor`  | Preflight checks: tools, config, SSH target, and model path (if source=local). |
| `help`    | Show usage.                                                                  |

Use `--config FILE` before the command to use a config other than `./omnivoice.conf`.

```bash
./launch_omnivoice.sh --config ./my-omnivoice.conf start
```

---

## Calling the model

### curl

```bash
# Auto voice (simplest, stable online mode). Omit "voice": the server exposes
# no named voices, and sending "default"/"" is rejected with "Supported: none".
curl -X POST http://localhost:8000/v1/audio/speech \
     -H 'Content-Type: application/json' \
     -d '{"input":"Hello, how are you?","response_format":"wav"}' \
     -o out.wav
```

### Python client

```bash
python client/speech_client.py --api-base http://localhost:8000 \
       --text "Hello, how are you?"
```

Voice cloning (reference audio + transcript) and voice-design/style control:

```bash
# Voice cloning
python client/speech_client.py \
       --text "Hello, this is a cloned voice." \
       --ref-audio /path/to/ref.wav \
       --ref-text "Transcript of the reference audio."

# Language hint
python client/speech_client.py --text "Bonjour, comment allez-vous?" --language French

# Voice design / style
python client/speech_client.py --text "Hello!" --instructions "loud voice"

# Deterministic output
python client/speech_client.py --text "Hello!" --seed 42 -o out.wav
```

A stdlib-only variant (no `openai` / `httpx` dependency, uses `urllib`) is
available as `client/speech_client_stdlib.py` with the same CLI:

```bash
python client/speech_client_stdlib.py --api-base http://localhost:8000 \
       --text "Hello, how are you?"
```

### OpenAI SDK

```python
from openai import OpenAI

client = OpenAI(base_url="http://localhost:8000/v1", api_key="not-needed")
# Pass voice=None: the SDK requires the argument, but the vLLM-Omni server
# registers no named voices (sending "default"/"" is rejected). None is sent
# as JSON null, which the server treats as auto voice.
resp = client.audio.speech.create(
    model="k2-fsa/OmniVoice",
    voice=None,
    input="Hello, how are you?",
)
resp.stream_to_file("out.wav")
```

---

## Configuration (`omnivoice.conf`)

A plain INI file. See `omnivoice.conf.example` for the fully annotated version.

```ini
[hpc]
host                 = capella1
user                 = apku868a
ssh_key              = ~/.ssh/id_ed25519
workspace_filesystem = scratch
workspace_name       = omnivoice-hosting
account              = p_scads
modules              = release/24.10 GCCcore/13.3.0 Python/3.12.3 CUDA/12.6

[slurm]
job_name    = omnivoice-tts
gres        = gpu:1
cpus        = 8
mem         = 40G
time        = 08:00:00
reservation =

[service]
port              = 8000
local_port        = 8000
python            = python3
vllm_version      = 0.24.0
vllm_omni_source  = vllm-omni==0.24.0
# vllm_extra_index_url =          # optional, e.g. a custom/ROCm wheels index

[model:omnivoice]
source                = huggingface
model_id              = k2-fsa/OmniVoice
trust-remote-code     = true
dtype                 = bfloat16
gpu-memory-utilization = 0.9
```

The cluster work directory is **derived** as
`/data/<workspace_filesystem>/ws/<user>-<workspace_name>` and auto-allocated
(10 days, renewed on each run) via `ws_allocate`. Keep it separate from your
LLM-hosting workspace so the two venvs don't clash.

### Model sources

| `source`      | Required key  | What happens                                                            |
|---------------|---------------|-------------------------------------------------------------------------|
| `huggingface` | `model_id`    | Pre-downloaded into `<work_dir>/hf_cache/` on the login node; the compute node serves from the shared cache (offline). |
| `local`       | `local_path`  | The folder is rsynced to `<work_dir>/models/<name>/` and served from disk. Use this for a custom / fine-tuned copy. |

### Serve options

Optional keys in the `[model:NAME]` block are forwarded to `vllm serve`:

| Key                       | Maps to                        | Notes                                  |
|---------------------------|--------------------------------|----------------------------------------|
| `trust-remote-code`       | `--trust-remote-code`          | OmniVoice needs this; defaulted on.    |
| `dtype`                   | `--dtype`                      | `auto`, `float16`, `bfloat16`, ...     |
| `gpu-memory-utilization`  | `--gpu-memory-utilization`     | Lower if sharing the GPU.              |
| `extra-args`              | (appended raw)                 | Anything else `vllm serve` accepts.    |

> The `--omni` flag is always added by the job script.

---

## What happens during `start`

```
==> Connecting to HPC              # validates SSH
==> Checking workspace on HPC      # ws_find or ws_allocate -F <fs> <name> (10 days)
==> Syncing server code            # rsync hpc/ + client/ to work_dir
==> Syncing model                  # rsync local_path -> work_dir/models/<name> (source=local only)
==> Installing deps                # creates venv, pip installs vLLM-Omni (+ vLLM),
                                   # and pre-downloads the OmniVoice model
==> Rendering SLURM job            # renders run.sbatch from the template
==> Submitting SLURM job           # sbatch --parsable, stores the job id
==> Waiting for server             # tails the cluster log until SERVER_READY
==> Port forwarding                # ssh -L localhost:8000 -> compute-node:8000
==> Monitoring                     # exits if the job dies; Ctrl-C keeps the job
```

Readiness: the SLURM job launches `vllm serve ... --omni` in the background,
polls `GET /health` on the compute node, and prints `SERVER_READY` once the
OpenAI server is up. The laptop greps the synced log for that sentinel.

---

## Notes & caveats

- **First `start` is slow.** It builds a venv and installs vLLM + vLLM-Omni
  (large wheels) and downloads the OmniVoice weights. Subsequent runs are fast.
- **Workspace is auto-allocated.** `start`/`sync` call `ws_find` and fall back
  to `ws_allocate -F <workspace_filesystem> <workspace_name> 10` (a 10-day
  workspace) on the cluster. The work dir is
  `/data/<filesystem>/ws/<user>-<name>`. Re-running renews/finds it.
- **vLLM + vLLM-Omni versions.** vLLM-Omni is a library on top of vLLM and
  does **not** declare vLLM/torch as dependencies, so setup installs the
  matching `vllm` wheel first (it provides the `vllm` CLI the job launches),
  then vLLM-Omni. The two must share the same major.minor. Defaults target the
  latest **stable** PyPI pair: `vllm==0.24.0` + `vllm-omni==0.24.0` (CUDA 12
  line, matches a `CUDA/12.x` module). For bleeding edge set **both**
  `vllm_version = 0.25.0` and `vllm_omni_source = git+https://github.com/vllm-project/vllm-omni.git`
  (CUDA 13). Mixing versions makes `import vllm_omni` fail.
- **CUDA vs vLLM wheel.** vLLM 0.25.x ships a CUDA 13 build; vLLM 0.24.x ships
  CUDA 12. Pick the pair whose CUDA line matches your cluster's NVIDIA driver
  / `CUDA` module (the default 0.24.0 pair fits a `CUDA/12.6` module).
- **Re-pinning versions.** If you change `vllm_version` / `vllm_omni_source`
  after a first install, remove the stale venv on the cluster
  (`rm -rf <work_dir>/venv`) before re-running `sync` so pip starts clean.
- **Isolation.** Use a `work_dir` separate from your LLM-hosting `work_dir`;
  the two stacks need different vLLM versions and would clash in one venv.
- **Online vs offline features.** Per the vLLM-Omni docs, OmniVoice online
  serving stably exposes **auto voice**; voice cloning and voice design are
  also accepted by the request schema (`ref_audio`/`ref_text`/`instructions`).
  For full offline control see the
  [OmniVoice Python API](https://github.com/k2-fsa/OmniVoice#python-api).
- **Reference audio tips.** Use a 3–10 s clip; for standard pronunciation use
  a reference in the same language as the target text.
- **Models live after Ctrl-C.** Interrupting `start` tears down local
  forwarding but leaves the cluster job running; use `stop` to cancel it, or
  `forward` to reconnect.
- **HuggingFace mirror.** If downloads fail, set
  `export HF_ENDPOINT="https://hf-mirror.com"` on the cluster before running.

---

## Requirements

- On your laptop: `bash` 4+, `ssh`, `rsync`, `lsof` (optional, for port
  cleanup), Python 3. The `speech_client.py` client needs the `openai` SDK
  (`pip install openai`); the `speech_client_stdlib.py` variant needs no
  third-party packages.
- Passwordless SSH to the cluster (key-based).
- On the cluster: SLURM, a GPU partition, a Python 3.10+ module, and a CUDA
  toolkit module that matches vLLM's wheel. The setup script installs vLLM and
  vLLM-Omni into a local venv.
