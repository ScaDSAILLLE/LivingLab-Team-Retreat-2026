#!/usr/bin/env python3
"""OmniVoice TTS client for the OpenAI-compatible /v1/audio/speech endpoint.

Talks to a vLLM-Omni server started with:
    vllm serve k2-fsa/OmniVoice --omni --port 8000 --trust-remote-code

Uses the official OpenAI Python SDK (``pip install openai``). The OmniVoice
endpoint is OpenAI-compatible but extends the request with extra fields
(``language``, ``ref_audio``, ``ref_text``, ``instructions``, ``seed``); those
are passed through ``extra_body``.

OmniVoice has NO built-in voices. Pick one of three ways:
  1. Auto voice     -> omit --voice and --ref-audio (model picks a voice)
  2. Voice cloning  -> pass --ref-audio + --ref-text
  3. Registered     -> pass --voice NAME (a voice uploaded via POST /v1/audio/voices)

Examples
--------
# Auto voice (simplest)
python speech_client.py --text "Hello, how are you?"

# Force English
python speech_client.py --text "Hello" --language English

# Voice cloning (ref_audio may be a local path, http(s) URL, or data: URI)
python speech_client.py --text "Hello" --ref-audio ref.wav --ref-text "Reference transcript."

# Voice design / style
python speech_client.py --text "Hello" --instructions "female, low pitch, british accent"

# Deterministic output
python speech_client.py --text "Hello" --seed 42 -o out.wav
"""

import argparse
import base64
import sys

from openai import OpenAI, OpenAIError, APIConnectionError, APIStatusError

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


def build_extra_body(args: argparse.Namespace) -> dict:
    """Build the OmniVoice-specific fields for the speech request.

    Standard OpenAI fields (``model``, ``input``, ``voice``,
    ``response_format``) are passed directly to ``audio.speech.create``;
    everything OmniVoice-specific goes through ``extra_body`` so it is merged
    into the JSON body alongside the standard fields.
    """
    extra: dict = {}
    if args.language:
        extra["language"] = args.language
    if args.ref_text:
        extra["ref_text"] = args.ref_text
    if args.instructions:
        extra["instructions"] = args.instructions
    if args.ref_audio:
        # Inline ref audio for voice cloning: pass URLs/data-URIs through,
        # base64-encode local file paths.
        if args.ref_audio.startswith(("http://", "https://", "data:")):
            extra["ref_audio"] = args.ref_audio
        else:
            extra["ref_audio"] = encode_audio_to_base64(args.ref_audio)
    if args.seed is not None:
        extra["seed"] = args.seed
    return extra


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(
        description="OmniVoice TTS client (OpenAI-compatible /v1/audio/speech)",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    p.add_argument("--api-base", default="http://localhost:8000",
                   help="vLLM-Omni base URL (without the /v1 suffix)")
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

    mode = ("voice cloning" if args.ref_audio
            else f"voice '{args.voice}'" if args.voice else "auto voice")
    print(f"Generating ({mode})...")

    # The OpenAI SDK expects the base URL to include the API version prefix.
    base_url = args.api_base.rstrip("/") + "/v1"
    client = OpenAI(base_url=base_url, api_key=args.api_key, timeout=args.timeout)

    extra_body = build_extra_body(args)
    try:
        # voice=None is sent as JSON null, which the vLLM-Omni server treats
        # as auto voice (it registers no named voices; sending "default"/""
        # is rejected). A registered voice name overrides this.
        speech = client.audio.speech.create(
            model=args.model,
            input=args.text,
            voice=args.voice,
            response_format=args.response_format,
            extra_body=extra_body or None,
        )
    except APIConnectionError as e:
        print(f"Error: could not reach {args.api_base}: {e}", file=sys.stderr)
        return 1
    except APIStatusError as e:
        print(f"Error: HTTP {e.status_code}", file=sys.stderr)
        try:
            print(e.response.json(), file=sys.stderr)
        except ValueError:
            print(e.response.text, file=sys.stderr)
        return 1
    except OpenAIError as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1

    out = args.output or f"omnivoice_output.{args.response_format}"
    speech.write_to_file(out)
    print(f"Saved: {out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
