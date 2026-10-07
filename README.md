# Local AI Test Lab

This repository is a small, hands-on project for testing local language models and home-lab automation on hardware I already have. It is not a production AI platform. The machine is resource-constrained, so the model choices, context size, and one-model-at-a-time settings are deliberate compromises based on the available hardware, not a claim that these are the best models for every system.

The aim is to learn what works locally: install Ollama, try a modest model, compare a general and a coding model, create prompt-based specialist roles, and optionally connect a chat UI and a simple workflow. Model downloads and software installation need internet access; inference is intended to run on the local Ubuntu host.

## Hardware and model choices

The project is planned around a Dell Precision 5810 with an NVIDIA RTX 3060 (12 GB VRAM) and a GTX 1070 (8 GB VRAM). Confirm the actual installed cards, RAM, power supply, cooling, and driver support before using the guide; this hardware profile is a planning assumption, not an automated hardware check.

- The RTX 3060's 12 GB is the main constraint for model placement and context memory.
- The RTX 3060 and GTX 1070 do not become one 20 GB memory pool. Ollama may split model layers across GPUs, but placement and speed depend on the runtime and workload.
- The setup starts with `qwen3:8b-q4_K_M` as a manual smoke test, then the model script explicitly defaults to `qwen3:14b-q4_K_M` for general roles and `qwen2.5-coder:14b-instruct-q4_K_M` for coding. Ollama's current catalog lists the 14B Q4_K_M weight files at about 9.3 GB and 9.0 GB respectively. The script checks the installed base model's reported quantization before it creates specialist roles.
- Q4_K_M is a deliberate weight-size compromise, not a GPU-memory guarantee. The 14B weights take most of the RTX 3060's 12 GB capacity before accounting for the Ollama runner, CUDA/runtime allocations, and KV cache for the 4096-token context. The model may partially offload to system RAM; check actual placement and speed before deciding it is a good fit. If it is too slow or memory-constrained, start with a 7B/8B Q4_K_M model.
- All specialist Modelfiles use a 4096-token context and temperature 0.2. Ollama is also configured for one loaded model and one parallel request at a time. These settings reduce concurrent pressure but do not reduce the memory required by the active model to zero.
- The 17 specialist names are prompt-configured variants of two base models. They are not 17 separately trained models, and they do not all occupy GPU memory at once.

## Walkthrough

### 1. Prepare the Ubuntu host

Install Ubuntu on the workstation, connect it to your network, update the system, and install the NVIDIA driver appropriate for the installed GPUs. Reboot and confirm the driver sees the cards:

```bash
nvidia-smi
```

Check temperatures, available system memory, storage space, and power/cooling before downloading large models. Model files take multiple gigabytes, and running a model can use both system RAM and GPU memory.

### 2. Install and check Ollama

From this project directory on the Ubuntu host, run:

```bash
bash setup_ollama.sh
```

The script installs Ollama if needed and configures its system service to listen only on `127.0.0.1:11434`. It allows one loaded model at a time, which keeps this constrained test box from trying to load several models concurrently. Confirm the service responds:

```bash
ollama list
curl http://127.0.0.1:11434/api/tags
```

The Ollama API is intentionally not available directly to other LAN devices. Do not change it to listen on all interfaces just to make another application connect.

### 3. Run a small first test

Try one smaller general model before fetching the full specialist set:

```bash
ollama pull qwen3:8b-q4_K_M
ollama run qwen3:8b-q4_K_M
```

Ask a few representative questions and observe response time, GPU use, and system memory. This separates basic inference testing from the larger model downloads. Use `Ctrl+D` to exit the interactive session.

### 4. Create the specialist roles

When the basic test is satisfactory, run:

```bash
bash setup_models.sh
```

By default, this pulls `qwen3:14b-q4_K_M` and `qwen2.5-coder:14b-instruct-q4_K_M`, verifies both with `ollama show --verbose`, then creates 17 `lab-*` model names with role-specific system prompts. It does not train or fine-tune model weights. Each role is a named Modelfile based on one of those two base models; the script does not load all 17 into memory at the same time. The aliases inherit the base weights' quantization, while their Modelfiles set the 4096-token context.

After pulling, inspect the actual local model metadata and active placement:

```bash
ollama show --verbose qwen3:14b-q4_K_M
ollama show --verbose qwen2.5-coder:14b-instruct-q4_K_M
ollama ps
```

The `ollama show` output should report `quantization Q4_K_M`. `ollama ps` reports whether a running model is on GPU, CPU, or split between them. Run it while a model is generating; an unloaded model will not appear. A quantization match confirms the weight format only, not that the model fits entirely in VRAM or performs acceptably.

If the 14B defaults are a poor fit for your measured performance, the script accepts other Ollama model tags. For example, a smaller general and coding pair can be selected with:

```bash
GENERAL_MODEL=qwen3:8b-q4_K_M CODER_MODEL=qwen2.5-coder:7b-instruct-q4_K_M bash setup_models.sh
```

The script expects `Q4_K_M` by default and fails if a pulled model reports a different quant. To intentionally test a different quant, select an available explicit tag and set `EXPECTED_QUANTIZATION` to the exact value Ollama reports, for example `EXPECTED_QUANTIZATION=Q5_K_M`. Higher-bit quants need more storage and memory; they are not recommended on this constrained GPU unless you have verified the available headroom. Model availability and behavior can change with Ollama library tags. Re-running the script recreates the named roles using the selected bases.

### 5. Install Open WebUI for local-network access (optional)

Open WebUI is not installed by the included scripts. On the Ubuntu host, install Docker Engine and Compose v2 if they are not already present. This example uses Docker host networking so the WebUI container can reach Ollama at `127.0.0.1:11434` while Ollama stays loopback-only. It sets the WebUI port to `3000`, stores chats in a persistent Docker volume, and saves a stable secret outside the container:

```bash
mkdir -p "$HOME/.config/open-webui"
if [[ ! -f "$HOME/.config/open-webui/.env" ]]; then
	printf 'WEBUI_SECRET_KEY=%s\nPORT=3000\nOLLAMA_BASE_URL=http://127.0.0.1:11434\n' \
		"$(openssl rand -hex 32)" > "$HOME/.config/open-webui/.env"
	chmod 600 "$HOME/.config/open-webui/.env"
fi

docker run -d \
	--network=host \
	--env-file "$HOME/.config/open-webui/.env" \
	--volume open-webui:/app/backend/data \
	--name open-webui \
	--restart always \
	ghcr.io/open-webui/open-webui:main
```

Host networking is for the Ubuntu/Linux host; do not add `-p` with this mode. Keep the `.env` file private and retain the same `WEBUI_SECRET_KEY` when recreating the container. For a stable deployment, use an Open WebUI release tag rather than a rolling image tag. This host-networked service is reachable on the host's network interfaces, so allow port `3000` only from trusted LAN devices with the host firewall. Do not forward the port from your router or expose the UI publicly.

On the Ubuntu server, find its LAN address with:

```bash
hostname -I
```

Use the address belonging to your home LAN. On another computer or phone connected to that same network, open `http://SERVER-LAN-IP:3000` in a browser. The first visit asks you to create the Open WebUI administrator account. Keep authentication enabled and do not enable open signup unless you intend to manage additional accounts. If the page does not load, confirm the container is running with `docker ps`, inspect startup messages with `docker logs open-webui`, and check the host firewall and LAN isolation settings.

The WebUI calls Ollama on the server; client devices do not need direct access to Ollama port `11434`. If the model list is empty, open **Settings > Admin > Connections**, check the Ollama connection URL is `http://127.0.0.1:11434`, and save it. The Ollama API remains bound to loopback by `setup_ollama.sh`.

### 6. Choose a model and role in Open WebUI

Start a new chat and select a model from the model dropdown. The named `lab-*` entries are prompt-based roles created by `setup_models.sh`; they are not separately trained models. Sixteen use the general Qwen3 base, while `lab-codewright` uses the Qwen2.5-Coder base. For a simple first check, select `lab-assistant` and ask a short home-lab question.

Every role Modelfile sets `temperature 0.2`. This makes responses less variable and more consistent; it does **not** prevent hallucinations or guarantee correctness. Verify commands and important claims, especially before changing a live system. The base models are also available for direct comparison: use Qwen3 for general-purpose questions and Qwen2.5-Coder for code-focused work.

| Task | Select this model | Use it for |
| --- | --- | --- |
| Everyday questions and first test | `lab-assistant` | General home-lab help and triage |
| Write or review code | `lab-codewright` | Scripts, code explanations, and reviews |
| Networking | `lab-network-planner` | Wi-Fi, VLANs, routing, DNS, and firewall planning |
| Containers and virtualization | `lab-platform-keeper` | Proxmox, LXC, Docker, and Compose |
| Media libraries | `lab-media-curator` | Plex/Jellyfin naming, mounts, and permissions |
| Physical server troubleshooting | `lab-hardware-guide` | Dell hardware, thermals, RAID, and maintenance |
| Security | `lab-security-analyst` | Defensive reviews of access, SSH, firewalls, and exposure |
| Learn a concept or command | `lab-tutor` | Step-by-step Linux and home-lab explanations |
| Media workflow automation | `lab-media-automation` | Sonarr, Radarr, Prowlarr, and authorized libraries |
| Brainstorm an experiment | `lab-idea-spark` | Plausible project ideas and prototypes |
| Backups and recovery | `lab-recovery-planner` | Snapshot plans and restore testing |
| Monitoring and alerts | `lab-signal-watch` | Grafana, Prometheus, Uptime Kuma, and Netdata |
| Smart home and IoT | `lab-home-systems` | Home Assistant, Zigbee, Z-Wave, MQTT, and YAML |
| Model and prompt tuning | `lab-model-tuner` | Ollama, quantization, context, prompts, and RAG |
| DNS and reverse proxy | `lab-edge-steward` | DNS, Pi-hole, certificates, and proxy exposure |
| Write documentation | `lab-knowledge-keeper` | Clear runbooks and searchable technical notes |
| Pick a specialist | `lab-task-router` | Request triage and a suggested role |

Open WebUI is the chat interface; choosing a role does not make it invoke other roles. `lab-task-router` can recommend a specialist but cannot call it without a separately configured workflow or tool. The host is configured for one loaded model and one parallel request at a time, so requests from multiple LAN clients can queue behind each other.

### 7. Add private remote access (optional)

On Ubuntu, run:

```bash
bash setup_tailscale.sh
```

Authorize the server using the one-time URL printed by Tailscale. Install Tailscale on your trusted client device and sign in to the same tailnet. Use the server's tailnet address to reach the Open WebUI port you configured. No router port-forwarding is needed. This is a private route to the UI; the included Ollama service remains loopback-only.

### 8. Test a local workflow (optional)

Install Docker Engine and Compose v2, then run:

```bash
bash setup_n8n.sh
```

The script creates `automation/.env` with a private encryption key and starts n8n using the included host-network Compose configuration. n8n listens only on `127.0.0.1:5678`, while workflow requests can reach Ollama at `127.0.0.1:11434`. Open n8n on the Ubuntu host, create its first-owner account, and import `automation/workflows/local-assistant-smoke-test.json`. Run it manually to test the `lab-assistant` model.

Keep `automation/.env` backed up and private; it is needed to decrypt saved credentials. Do not commit it or publish the n8n port. External webhooks require a separately secured ingress setup and are outside this starter configuration.

### 9. Explore Paperclip (optional)

Paperclip is an optional task and approval board, not a model runtime. It requires Node.js 24.11 or newer and a connected Tailscale host. Run the setup as your regular Ubuntu user, not as root:

```bash
bash setup_paperclip.sh
```

Configure a model provider and agent runtime inside Paperclip separately. The script does not create those credentials, connect the 17 Ollama roles, or make the task router call other models. Actual delegation needs an explicitly configured integration or workflow.

## Project files

- `index.html` is the project overview and interactive specialist directory.
- `styles.css` provides the responsive page styling; `script.js` handles search, filters, command copying, and mobile navigation.
- `setup_ollama.sh` installs Ollama when needed and keeps its API on loopback.
- `setup_models.sh` pulls explicit Q4_K_M base-model tags, verifies the reported quantization, and creates the 17 prompt-based specialist names.
- `setup_tailscale.sh` installs Tailscale and starts interactive tailnet authorization.
- `setup_n8n.sh`, `automation/compose.yaml`, and `automation/workflows/local-assistant-smoke-test.json` set up and test local n8n-to-Ollama calls.
- `setup_paperclip.sh` starts Paperclip's private tailnet onboarding; provider setup is separate.
- `Blueprint.txt` is an earlier planning draft, not current installation guidance. Its commands and model names do not match the maintained scripts, and it includes network exposure advice that conflicts with this project's loopback-only Ollama configuration. Follow the steps in this README and the current scripts instead.

## Preview the project page

Open `index.html` in a browser. The page is static and has no build step or package dependencies. Google Fonts and the hero photograph load from external hosts; the local page content and interactions work from the project files.

## Keep the experiment safe

- Treat local inference as a test, not a guarantee of private or secure application behavior. Choose carefully what data you send to any UI, workflow, or provider.
- Keep Ollama and n8n off the public internet. Use authenticated UI access and private networking for remote use.
- Verify model placement and performance on the actual host. GPU memory is not pooled, and longer contexts require more memory.
- Review current Ubuntu, NVIDIA, Ollama, Docker, Open WebUI, Tailscale, and Paperclip documentation before installing or upgrading those tools.