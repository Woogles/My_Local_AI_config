# Local AI Test Lab

## Project Overview

Local AI Test Lab is a home-lab project focused on learning, testing, and experimenting with locally hosted AI models, automation tools, and supporting infrastructure.

The goal is not to build a production AI platform. Instead, the project serves as a practical environment for:

- Running local language models with Ollama
- Evaluating model sizes and hardware limitations
- Creating specialist AI roles through prompt engineering
- Testing local AI workflows and automation
- Exploring secure self-hosted AI deployments
- Learning how AI tooling interacts with home-lab infrastructure

The project intentionally prioritizes simplicity, local operation, and security-conscious defaults over maximum performance or feature completeness.

---

## Project Status

This project is currently under active development.

The installation scripts, deployment flow, and documentation are functional but continue to evolve. Several planned improvements, security enhancements, and deployment refinements have not yet been implemented.

Future enhancements, deployment recommendations, and outstanding work are tracked separately in `ROADMAP.md`.

Before deploying any component, review the scripts and configuration files to ensure they meet your requirements and security expectations.

---

## Design Philosophy

This project follows several guiding principles:

- Local-first AI inference
- Conservative security defaults
- Loopback-only Ollama access
- Measured testing before scaling
- Minimal exposure of services
- One-model-at-a-time operation on constrained hardware
- Learning through experimentation rather than chasing benchmarks

The intent is to understand what works reliably in a real home-lab environment while avoiding unnecessary complexity.

---

## Hardware Assumptions

This project was planned around:

- Dell Precision 5810 workstation
- NVIDIA RTX 3060 (12 GB VRAM)
- NVIDIA GTX 1070 (8 GB VRAM)
- 32 GB system RAM
- Ubuntu Linux

These specifications are assumptions, not requirements.

Always verify your actual hardware configuration before deploying models or downloading large assets.

Important considerations:

- GPU memory is not pooled.
- A 12 GB GPU and 8 GB GPU do not provide a combined 20 GB VRAM pool.
- Ollama may distribute model layers across GPUs in some situations, but actual placement and performance must be tested.
- Context length, batch size, runtime overhead, and concurrent workloads all impact memory usage.

---

## Recommended Deployment Sequence

The recommended deployment order is:

1. Verify hardware health and GPU detection.
2. Install Ubuntu and NVIDIA drivers.
3. Review project scripts before executing them.
4. Install Ollama.
5. Run the 8B smoke test.
6. Deploy Open WebUI.
7. Configure Tailscale (optional).
8. Deploy n8n (optional).
9. Deploy Paperclip (optional).
10. Create specialist AI roles.
11. Configure GitHub Pages publication (optional).

This order allows hardware validation and performance testing before downloading large models or introducing additional services.

---

# Step 1: Verify Hardware

Before installing any AI tooling, verify:

- GPU detection
- System temperatures
- Storage capacity
- Available RAM
- Power supply stability
- Cooling performance

Confirm the NVIDIA driver detects both GPUs:

```bash
nvidia-smi
```

Also verify:

- Disk space for model downloads
- Available system memory
- GPU temperatures under load

Do not assume published hardware specifications match the actual workstation configuration.

---

# Step 2: Install Ollama

From the project directory:

```bash
bash setup_ollama.sh
```

The script configures Ollama to:

- Listen only on `127.0.0.1:11434`
- Limit concurrent model loading
- Use conservative settings appropriate for a small home-lab environment

Verify the service:

```bash
ollama list

curl http://127.0.0.1:11434/api/tags
```

The Ollama API should remain bound to loopback.

Do not expose port 11434 directly to your LAN, Tailscale network, or the public internet.

---

# Step 3: Run the Initial Smoke Test

Before pulling larger models, test a smaller model first.

```bash
ollama pull qwen3:8b-q4_K_M

ollama run qwen3:8b-q4_K_M
```

Evaluate:

- Response speed
- GPU utilization
- RAM usage
- Temperature behavior
- Stability

Monitor utilization during testing:

```bash
nvidia-smi
```

Exit the test session with:

```text
Ctrl+D
```

---

# Step 4: Deploy Open WebUI

Open WebUI is the recommended interface for the reference deployment.

For users adapting this repository to their own environment, Open WebUI remains optional. However, it is treated as a core component of the intended lab architecture.

Deploy Open WebUI with:

- Authentication enabled
- Persistent data storage
- Access restricted to trusted devices
- Connectivity to local Ollama

Recommended practices:

- Keep administrator access protected.
- Retain persistent storage between upgrades.
- Back up configuration and chat history as needed.
- Do not expose the service directly to the public internet.

Open WebUI should communicate with Ollama while Ollama remains bound to loopback.

---

# Step 5: Tailscale (Optional)

Tailscale provides secure remote access without router port forwarding.

Install:

```bash
bash setup_tailscale.sh
```

Authorize the machine using the provided URL.

Once connected, trusted devices on the same tailnet can access approved services without exposing them publicly.

Tailscale membership should not replace application authentication.

Continue using:

- Strong passwords
- Service authentication
- Access controls

---

# Step 6: n8n (Optional)

n8n can be used to build AI workflows and automation.

Install:

```bash
bash setup_n8n.sh
```

Example uses:

- AI-assisted workflows
- Notification pipelines
- Internal automation
- Multi-step prompts

Important considerations:

- Treat workflows as executable code.
- Review imported workflows before activating them.
- Protect credentials and secrets.
- Back up the n8n encryption key.
- Keep access restricted to trusted users.

---

# Step 7: Paperclip (Optional)

Paperclip can be used for task management and AI-assisted project workflows.

Install:

```bash
bash setup_paperclip.sh
```

Paperclip is not required for local inference.

Use it if you wish to experiment with:

- Task coordination
- Agent workflows
- Project planning
- AI-assisted operations

Always enable authentication and review network exposure carefully.

---

# Step 8: Create Specialist Models

Once the smoke test is successful, create the specialist AI roles:

```bash
bash setup_models.sh
```

By default the script:

- Pulls a general-purpose model
- Pulls a coding-focused model
- Creates multiple role-based variants
- Applies role-specific system prompts

These are not separately trained models.

They are prompt-based role configurations built on shared base models.

The specialist roles exist to make common home-lab tasks easier without requiring users to repeatedly re-enter instructions.

---

## Example Specialist Roles

| Role | Purpose |
|--------|--------|
| lab-assistant | General assistance |
| lab-codewright | Coding help |
| lab-network-planner | Networking guidance |
| lab-platform-keeper | Containers and virtualization |
| lab-security-analyst | Security reviews |
| lab-media-curator | Media management |
| lab-home-systems | Home Assistant and IoT |
| lab-signal-watch | Monitoring and alerting |
| lab-recovery-planner | Backup and recovery |
| lab-model-tuner | AI model tuning |

These roles share the same underlying model weights and do not all occupy GPU memory at the same time.

---

## Model Selection Guidance

Detailed model recommendations have been separated into:

```text
Model_Recommendations.md
```

That document covers:

- GPU memory tiers
- Ollama recommendations
- llama.cpp recommendations
- Context sizing
- Quantization guidance
- VRAM planning
- Runtime tuning considerations

Always test actual performance on your hardware rather than relying solely on published recommendations.

---

## Security Considerations

This project intentionally favors conservative defaults.

Recommended practices:

- Keep Ollama bound to loopback.
- Do not expose port 11434.
- Require authentication for all web interfaces.
- Avoid router port forwarding.
- Restrict access to trusted devices.
- Review AI workflows before activation.
- Keep backups of configuration and application data.
- Protect encryption keys and secrets.
- Review scripts before running them.

Remember:

Running locally improves privacy but does not automatically make a system secure.

---

## GitHub Pages Publication (Optional)

This project may be published through GitHub Pages.

When publishing:

- Use an allowlisted set of files.
- Treat all published files as public.
- Do not publish secrets.
- Do not rely on `.gitignore` as a security boundary.
- Review publication artifacts before deployment.

GitHub Pages should be used for documentation and approved project assets only.

---

## Project Files

| File | Purpose |
|--------|--------|
| README.md | Primary documentation |
| ROADMAP.md | Planned improvements and future work |
| Model_Recommendations.md | Hardware and model sizing guidance |
| setup_ollama.sh | Ollama installation and configuration |
| setup_models.sh | Specialist model creation |
| setup_tailscale.sh | Tailscale installation |
| setup_n8n.sh | n8n deployment |
| setup_paperclip.sh | Paperclip deployment |
| automation/ | n8n files and workflows |
| DEPLOYMENT_CHECKLIST.md | Step-by-step deployment and validation runbook |

## Deployment Checklist

For a complete deployment and validation procedure, see:

DEPLOYMENT_CHECKLIST.md

This document serves as the project's operational runbook and acceptance checklist.
---

## Known Limitations

This project remains a work in progress.

Current limitations include:

- Configuration may change over time.
- Version pinning is not fully implemented.
- Network architecture continues to evolve.
- Open WebUI deployment automation is not yet complete.
- Hardware assumptions may not match all environments.
- Larger models may not perform acceptably on constrained hardware.

Users should treat the project as an experimental learning environment rather than a finished platform.

---

## Future Work

Planned enhancements and recommendations are maintained in:

```text
ROADMAP.md
```

Areas under active consideration include:

- Version pinning
- Deployment automation
- Security hardening
- Accessibility improvements
- Networking refinement
- GitHub Pages improvements
- Larger model testing
- Multi-GPU experimentation

---

## Final Notes

This project exists primarily as a learning environment for understanding local AI deployment in a real home-lab setting.

Start small, measure performance, validate assumptions, and scale only after you understand how the system behaves on your actual hardware.

Reliable systems are built through observation and iteration, not by immediately deploying the largest model that fits on paper.