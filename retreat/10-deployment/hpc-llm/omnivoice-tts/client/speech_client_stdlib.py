#!/usr/bin/env python3
"""OmniVoice TTS client for the OpenAI-compatible /v1/audio/speech endpoint.

Stdlib-only variant of ``speech_client.py``: no third-party dependencies
(no ``httpx``, no ``openai``). Uses ``urllib.request`` from the Python
standard library, so it runs on any Python 3.7+ install without ``pip``.

Talks to a vLLM-Omni server started with:
    vllm serve k2-fsa/OmniVoice --omni --port 8000 --trust-remote-code

OmniVoice has NO built-in voices. Pick one of three ways:
  1. Auto voice     -> omit --voice and --ref-audio (model picks a voice)
  2. Voice cloning  -> pass --ref-audio + --ref-text
  3. Registered     -> pass --voice NAME (a voice uploaded via POST /v1/audio/voices)

Examples
--------
# Auto voice (simplest)
python speech_client_stdlib.py --text "Hello, how are you?"

# Force English
python speech_client_stdlib.py --text "Hello" --language English

# Voice cloning (ref_audio may be a local path, http(s) URL, or data: URI)
python speech_client_stdlib.py --text "Hello" --ref-audio ref.wav --ref-text "Reference transcript."

# Voice design / style
python speech_client_stdlib.py --text "Hello" --instructions "female, low pitch, british accent"

# Deterministic output
python speech_client_stdlib.py --text "Hello" --seed 42 -o out.wav
"""

import argparse
import base64
import json
import sys
import urllib.error
import urllib.request

# The only language values the vLLM-Omni /v1/audio/speech endpoint accepts.
# Omit --language to let the model auto-detect from the text.
SUPPORTED_LANGUAGES = [
    "Auto", "Chinese", "English", "Japanese", "Korean", "German",
    "French", "Russian", "Portuguese", "Spanish", "Italian",
]


def encode_audio_to_base64(path: str) -> str:
    """Read a local audio file and return a base64 data: URL."""
    ext = path.lower().rsplit(".", 1)[-1]
    mime = {"wav": "audio/wav", "mp3": "audio/mpeg",
            "flac": "audio/flac", "ogg": "audio/ogg"}.get(ext, "audio/wav")
    with open(path, "rb") as f:
        b64 = base64.b64encode(f.read()).decode()
    return f"data:{mime};base64,{b64}"


def build_payload(args: argparse.Namespace) -> dict:
    """Build the /v1/audio/speech request body from CLI args."""
    payload = {"model": args.model, "input": args.text,
               "response_format": args.response_format}
    # voice=None -> auto voice (omitted from JSON so the server auto-detects).
    if args.voice:
        payload["voice"] = args.voice
    if args.language:
        payload["language"] = args.language
    if args.ref_text:
        payload["ref_text"] = args.ref_text
    if args.instructions:
        payload["instructions"] = args.instructions
    if args.ref_audio:
        # Inline ref audio for voice cloning: pass URLs/data-URIs through,
        # base64-encode local file paths.
        if args.ref_audio.startswith(("http://", "https://", "data:")):
            payload["ref_audio"] = args.ref_audio
        else:
            payload["ref_audio"] = encode_audio_to_base64(args.ref_audio)
    if args.seed is not None:
        payload["seed"] = args.seed
    return payload


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(
        description="OmniVoice TTS client (stdlib-only, OpenAI-compatible "
                    "/v1/audio/speech)",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    p.add_argument("--api-base", default="http://localhost:8000",
                   help="vLLM-Omni base URL")
    p.add_argument("--api-key", default="EMPTY", help="API key (unused locally)")
    p.add_argument("--model", "-m", default="k2-fsa/OmniVoice",
                   help="model id served by vLLM-Omni")
    p.add_argument("--text", required=True, help="text to synthesize")
    p.add_argument("--voice", default=None,
                   help="registered voice name (omit for auto voice; "
                        "OmniVoice has no built-in voices)")
    p.add_argument("--language", default=None, choices=SUPPORTED_LANGUAGES,
                   help="language hint (omit for Auto-detect)")
    p.add_argument("--response-format", default="wav",
                   choices=["wav", "mp3", "flac", "pcm", "aac", "opus"],
                   help="audio output format")
    p.add_argument("--ref-audio", default=None,
                   help="reference audio for cloning (local path, URL, or data: URI)")
    p.add_argument("--ref-text", default=None,
                   help="transcript of the reference audio")
    p.add_argument("--instructions", default=None,
                   help="voice-design / style instructions, e.g. "
                        "'female, low pitch, british accent'")
    p.add_argument("--seed", type=int, default=None,
                   help="random seed for deterministic output")
    p.add_argument("--timeout", type=float, default=300.0,
                   help="request timeout (seconds)")
    p.add_argument("--output", "-o", default=None, help="output file path")
    return p.parse_args()


def main() -> int:
    args = parse_args()
    payload = build_payload(args)

    mode = ("voice cloning" if args.ref_audio
            else f"voice '{args.voice}'" if args.voice else "auto voice")
    print(f"Generating ({mode})...")

    url = f"{args.api_base.rstrip('/')}/v1/audio/speech"
    body = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        url, data=body, method="POST",
        headers={"Content-Type": "application/json",
                 "Authorization": f"Bearer {args.api_key}"},
    )

    try:
        with urllib.request.urlopen(req, timeout=args.timeout) as resp:
            content = resp.read()
    except urllib.error.HTTPError as e:
        print(f"Error: HTTP {e.code}", file=sys.stderr)
        raw = e.read()
        try:
            print(json.loads(raw), file=sys.stderr)
        except (ValueError, json.JSONDecodeError):
            print(raw.decode("utf-8", "replace"), file=sys.stderr)
        return 1
    except urllib.error.URLError as e:
        print(f"Error: could not reach {args.api_base}: {e.reason}",
              file=sys.stderr)
        return 1

    out = args.output or f"omnivoice_output.{args.response_format}"
    with open(out, "wb") as f:
        f.write(content)
    print(f"Saved: {out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
