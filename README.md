# Local AI Test Lab

This repository is a small, hands-on project for testing local language models and home-lab automation on hardware I already have. It is not a production AI platform. The machine is resource-constrained, so the model choices, context size, and one-model-at-a-time settings are deliberate compromises based on the available hardware, not a claim that these are the best models for every system.

The aim is to learn what works locally: install Ollama, try a modest model, compare a general and a coding model, create prompt-based specialist roles, and optionally connect a chat UI and a simple workflow. Model downloads and software installation need internet access; inference is intended to run on the local Ubuntu host.

## Hardware and model choices

The project is planned around a Dell Precision 5810 with an NVIDIA RTX 3060 (12 GB VRAM) and a GTX 1070 (8 GB VRAM). Confirm the actual installed cards, RAM, power supply, cooling, and driver support before using the guide; this hardware profile is a planning assumption, not an automated hardware check.

- The RTX 3060's 12 GB is the main constraint for model placement and context memory.
- The RTX 3060 and GTX 1070 do not become one 20 GB memory pool. Ollama may split model layers across GPUs, but placement and speed depend on the runtime and workload.
- The setup starts with `qwen3:8b` as a manual smoke test, then the model script defaults to `qwen3:14b` for general roles and `qwen2.5-coder:14b` for coding. These are hardware-informed starting points to compare, not guaranteed to fit entirely in GPU memory or run quickly.
- All specialist Modelfiles use a 4096-token context and temperature 0.2. If 14B models are too slow or exceed available memory, substitute smaller tags with the environment variables shown below.
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
ollama pull qwen3:8b
ollama run qwen3:8b
```

Ask a few representative questions and observe response time, GPU use, and system memory. This separates basic inference testing from the larger model downloads. Use `Ctrl+D` to exit the interactive session.

### 4. Create the specialist roles

When the basic test is satisfactory, run:

```bash
bash setup_models.sh
```

By default, this pulls `qwen3:14b` and `qwen2.5-coder:14b`, then creates 17 `lab-*` model names with role-specific system prompts. It does not train or fine-tune model weights. Each role is a named Modelfile based on one of those two base models; the script does not load all 17 into memory at the same time.

If the 14B defaults are a poor fit for your measured performance, the script accepts other Ollama model tags. For example, a smaller general and coding pair can be selected with:

```bash
GENERAL_MODEL=qwen3:8b CODER_MODEL=qwen2.5-coder:7b bash setup_models.sh
```

Model availability and behavior can change with Ollama library tags. Check the current model catalog and confirm the exact tags before pulling. Re-running the script recreates the named roles using the selected bases.

### 5. Add a chat interface (optional)

Open WebUI is not installed by the included scripts. Follow the current [Open WebUI installation documentation](https://docs.openwebui.com/) and create its first administrator account. Configure the container to reach the host Ollama API through a deliberate, secured network arrangement. The API binds to loopback; do not expose it publicly to make container connectivity easier. Keep WebUI authentication enabled.

### 6. Add private remote access (optional)

On Ubuntu, run:

```bash
bash setup_tailscale.sh
```

Authorize the server using the one-time URL printed by Tailscale. Install Tailscale on your trusted client device and sign in to the same tailnet. Use the server's tailnet address to reach the Open WebUI port you configured. No router port-forwarding is needed. This is a private route to the UI; the included Ollama service remains loopback-only.

### 7. Test a local workflow (optional)

Install Docker Engine and Compose v2, then run:

```bash
bash setup_n8n.sh
```

The script creates `automation/.env` with a private encryption key and starts n8n using the included host-network Compose configuration. n8n listens only on `127.0.0.1:5678`, while workflow requests can reach Ollama at `127.0.0.1:11434`. Open n8n on the Ubuntu host, create its first-owner account, and import `automation/workflows/local-assistant-smoke-test.json`. Run it manually to test the `lab-assistant` model.

Keep `automation/.env` backed up and private; it is needed to decrypt saved credentials. Do not commit it or publish the n8n port. External webhooks require a separately secured ingress setup and are outside this starter configuration.

### 8. Explore Paperclip (optional)

Paperclip is an optional task and approval board, not a model runtime. It requires Node.js 24.11 or newer and a connected Tailscale host. Run the setup as your regular Ubuntu user, not as root:

```bash
bash setup_paperclip.sh
```

Configure a model provider and agent runtime inside Paperclip separately. The script does not create those credentials, connect the 17 Ollama roles, or make the task router call other models. Actual delegation needs an explicitly configured integration or workflow.

## Project files

- `index.html` is the project overview and interactive specialist directory.
- `styles.css` provides the responsive page styling; `script.js` handles search, filters, command copying, and mobile navigation.
- `setup_ollama.sh` installs Ollama when needed and keeps its API on loopback.
- `setup_models.sh` pulls the two configured base models and creates the 17 prompt-based specialist names.
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