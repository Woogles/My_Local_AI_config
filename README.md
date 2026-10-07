# Fieldnotes: Local AI Command Center

A static, GitHub Pages-ready field guide and setup kit for Ubuntu, Ollama, Open WebUI, n8n automation, Paperclip delegation, and focused home-lab agents.

## Preview locally

Open `index.html` in a browser. The page has no build step or package dependencies. Google Fonts and the hero photography are loaded from external hosts; the rest of the site is local.


## Project files

- `index.html` contains the guide and agent directory.
- `styles.css` contains the responsive visual system.
- `script.js` handles agent filtering, search, command copying, and the mobile menu.
- `setup_ollama.sh` installs Ollama when needed and configures its system service for safe local access.
- `setup_models.sh` creates 17 Ollama specialist models: Qwen3 14B for general roles and Qwen2.5-Coder 14B for the coding role.
- `setup_tailscale.sh` installs and starts Tailscale, then begins interactive tailnet login.
- `setup_n8n.sh` creates a private n8n encryption key and starts the local-only Docker Compose service.
- `automation/compose.yaml` runs n8n on host networking so workflows can reach Ollama's loopback API.
- `automation/workflows/local-assistant-smoke-test.json` is an importable workflow that calls `lab-assistant`.
- `setup_paperclip.sh` checks Node.js and Tailscale, then starts Paperclip's authenticated tailnet onboarding and service install.

## Set up Ollama

Install the NVIDIA driver first and verify it with `nvidia-smi`. On the Ubuntu host, run:

```bash
bash setup_ollama.sh
```

The script installs Ollama with its official installer if it is missing, configures the systemd service to listen only on `127.0.0.1:11434`, and limits concurrent model loading to one. It is safe to rerun. For Open WebUI in Docker, configure host networking or another explicitly secured path to reach the host's loopback service; do not expose the Ollama API on all interfaces just to make the container connect.

## Create the agent models

After Ollama reports ready, run:

```bash
bash setup_models.sh
```

The script pulls `qwen3:14b` and `qwen2.5-coder:14b`, then creates the `lab-*` models with role-specific system prompts. These are prompt-configured models, not separately trained weights. The Modelfiles limit context to 4096 tokens as a conservative starting point for 12 GB VRAM; monitor GPU and system memory before increasing it. The RTX 3060 and GTX 1070 do not combine into one VRAM pool. Re-running the script updates those named agent models.

Override either base model with `GENERAL_MODEL=your-model:tag CODER_MODEL=your-coder:tag bash setup_models.sh`. The 14B defaults are a quality-oriented starting point for this hardware; use smaller 7B/8B variants if you prefer faster responses or more context headroom. Ollama may distribute layers across both GPUs, but this depends on runtime placement and can affect throughput.

## Add private remote access

On the Ubuntu server, run:

```bash
bash setup_tailscale.sh
```

Follow the one-time sign-in URL printed by the script to authorize the server. Install the Tailscale app on your phone and sign in to the same tailnet. Get the server's tailnet IP with `tailscale ip -4`, then open `http://SERVER-TAILNET-IP:WEBUI-PORT` on the phone while Tailscale is connected. Use the port published by your Open WebUI setup; no router port-forwarding is required.

The Ollama setup script binds its API to localhost, so this remote path is for Open WebUI, not direct Ollama API access. Keep WebUI authentication enabled and only add trusted devices to your tailnet. Home Assistant needs a separate, explicitly restricted Ollama network configuration if direct integration is required.

## Automate with n8n

Install Docker Engine and Compose v2 on Ubuntu, then run:

```bash
bash setup_n8n.sh
```

The script generates `automation/.env` with a private encryption key (ignored by Git), pulls n8n's stable image, and starts it with a persistent Docker volume. The container uses host networking so an n8n HTTP Request node can call Ollama at `http://127.0.0.1:11434`; n8n itself listens only on `127.0.0.1:5678`. Open `http://127.0.0.1:5678` on the server and create the first-owner account. Import `automation/workflows/local-assistant-smoke-test.json` in the n8n UI to verify the `lab-assistant` connection.

This local-only setup supports manual, schedule, and polling workflows. For inbound external webhooks, configure an authenticated private reverse proxy and the correct n8n webhook URL; do not publish port 5678 directly. The encryption key in `.env` is needed to decrypt stored credentials, so keep it in backups and never commit it.

## Delegate with Paperclip

Install Node.js 24.11 or newer and connect the Ubuntu server to Tailscale first. Then, as your regular user (not root), run:

```bash
bash setup_paperclip.sh
```

The script runs Paperclip's official npm onboarding in authenticated, private tailnet mode and installs its background service. Open `http://SERVER-TAILNET-IP:3100` from a device on the same tailnet. Paperclip is the task/org/approval board; n8n is the workflow runner. Paperclip does not automatically create the 17 Ollama roles or connect their models. Configure agent adapters and an Ollama-compatible provider explicitly in Paperclip, then use authenticated n8n HTTP Request credentials if a workflow should create or update Paperclip tasks. Never put API keys in exported workflow JSON.

## Notes on the setup guide

- Agent roles are prompt configurations, not separately trained models.
- A prompt alone does not make a coordinator invoke other models; real delegation needs a configured workflow or tool integration.
- GPU VRAM is not pooled. Check model fit, power, cooling, and driver support against the actual workstation configuration.
- Keep Ollama and the WebUI off the public internet. Use private remote access and deliberate firewall and authentication settings.
- Review current upstream installation instructions for Ubuntu, Ollama, NVIDIA drivers, and Open WebUI before deploying.