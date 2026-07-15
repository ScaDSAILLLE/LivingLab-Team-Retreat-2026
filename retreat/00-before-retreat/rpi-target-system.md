# Raspberry Pi Target System Notes

## Purpose
Use a dedicated Raspberry Pi as a realistic demonstrator target for Nanobot WebUI access, reverse proxying, operations discussion, and deployment practice.

## Initial Assumption
- The RPi is a dedicated, closed demonstrator system.
- Full sandboxing may not be necessary for the retreat demo, but basic isolation and least privilege should still be discussed as best practice.
- Compute-heavy multimodal tasks may need central/HPC/GPU resources; the RPi should primarily host or expose the lightweight interface and orchestration layer.

## Candidate Architecture
- Nanobot process runs on the RPi through a managed Python/uv installation or Docker container.
- Nanobot WebUI is exposed through Nginx as a reverse proxy.
- `nanobot gateway` provides the WebUI/WebSocket surface, default port `8765`.
- Optional `nanobot serve` exposes an OpenAI-compatible local API on `127.0.0.1:8900` for integration tests.
- Secrets are injected through environment variables or protected local files, never through Git.

## Open Decisions
- RPi model, OS version, architecture, and available RAM.
- Local `uv` install versus Docker Compose.
- Whether WebUI should be reachable only on the local network or from a controlled public endpoint.
- TLS termination strategy: local-only HTTP, LAN-only HTTPS, or reverse proxy behind institutional infrastructure.
- Whether Nanobot should call `llm.scads.ai`, KIARA, another OpenAI-compatible endpoint, or a local fallback.
- Whether process supervision uses Docker restart policy, systemd user service, or systemd system service.
- What logs must be collected for maintenance without exposing sensitive content.

## Nginx Reverse Proxy Sketch
This is a planning sketch, not a verified final config.

```nginx
server {
    listen 80;
    server_name scaddy-rpi.local;

    location / {
        proxy_pass http://127.0.0.1:8765;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Docker Compose Sketch
This is a planning sketch. Validate against the chosen Nanobot version and RPi architecture before using it as workshop material.

```yaml
services:
  nanobot:
    image: local/nanobot:retreat
    restart: unless-stopped
    ports:
      - "127.0.0.1:8765:8765"
      - "127.0.0.1:8900:8900"
    volumes:
      - nanobot-state:/home/nanobot/.nanobot
    env_file:
      - ./nanobot.env

volumes:
  nanobot-state:
```

## Security Discussion Questions
- Which data leaves the RPi during a demo interaction?
- Which files persist on the RPi, and who can access them?
- Which ports are exposed, and to whom?
- How do we rotate or revoke model/API credentials after the retreat?
- What is the minimum sandboxing we want even on a dedicated system?
