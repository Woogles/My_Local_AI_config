# Deployment Checklist

## Purpose

This checklist is intended to be used when performing a fresh deployment of the Local AI Test Lab environment.

The goal is to provide a repeatable process that validates hardware, software, security, and operational readiness before exposing services to users.

Complete each section before proceeding to the next.

---

# Phase 1 - Planning

## Define Goals

- [ ] Define intended use of the deployment.
- [ ] Determine whether deployment is for testing or long-term use.
- [ ] Determine who will access the environment.
- [ ] Determine whether remote access is required.
- [ ] Determine backup requirements.

## Review Documentation

- [ ] Review README.md.
- [ ] Review ROADMAP.md.
- [ ] Review Model_Recommendations.md.
- [ ] Review all deployment scripts before execution.

---

# Phase 2 - Hardware Validation

## System Verification

Record the following:

| Component | Actual Hardware |
|------------|------------|
| Workstation Model | |
| CPU | |
| RAM | |
| Primary Drive | |
| Secondary Drive | |
| Power Supply | |
| Operating System | |

---

## GPU Verification

Expected configuration:

- RTX 3060 (12 GB)
- GTX 1070 (8 GB)

Verify:

```bash
nvidia-smi
```

Checklist:

- [ ] RTX 3060 detected.
- [ ] GTX 1070 detected.
- [ ] Driver installed correctly.
- [ ] GPUs reporting expected VRAM.
- [ ] No driver errors present.

---

## Cooling Verification

- [ ] Fans operating normally.
- [ ] Airflow unobstructed.
- [ ] No abnormal temperatures.
- [ ] Dust cleaned if necessary.

Record idle temperatures:

| Component | Idle Temperature |
|------------|------------|
| CPU | |
| RTX 3060 | |
| GTX 1070 | |

---

# Phase 3 - Storage Planning

Determine storage locations before deployment.

## Ollama Models

Location:

```
____________________________
```

## Open WebUI Data

Location:

```
____________________________
```

## n8n Data

Location:

```
____________________________
```

## Paperclip Data

Location:

```
____________________________
```

## Backup Location

Location:

```
____________________________
```

---

## Disk Verification

Verify sufficient free space exists.

Commands:

```bash
df -h
```

Checklist:

- [ ] Storage plan documented.
- [ ] Model storage location verified.
- [ ] Backup storage location verified.
- [ ] Sufficient free disk space available.

---

# Phase 4 - Ubuntu Preparation

## Operating System

Checklist:

- [ ] Ubuntu installed.
- [ ] Hostname configured.
- [ ] System updated.
- [ ] Reboot completed.

Commands:

```bash
sudo apt update
sudo apt upgrade -y
sudo reboot
```

---

## NVIDIA Drivers

Install appropriate drivers.

Verify:

```bash
nvidia-smi
```

Checklist:

- [ ] Driver installed.
- [ ] Driver version recorded.
- [ ] GPUs detected after reboot.

Driver Version:

```
____________________________
```

---

# Phase 5 - Ollama Deployment

## Review Script

Checklist:

- [ ] setup_ollama.sh reviewed.
- [ ] Configuration understood.
- [ ] Existing configurations backed up.

Backup command example:

```bash
sudo cp override.conf override.conf.bak
```

---

## Installation

```bash
bash setup_ollama.sh
```

Checklist:

- [ ] Installation completed.
- [ ] Service starts automatically.
- [ ] No installation errors.

---

## Verification

```bash
ollama list
```

```bash
curl http://127.0.0.1:11434/api/tags
```

Checklist:

- [ ] Ollama operational.
- [ ] API responding.
- [ ] Bound to loopback.

---

# Phase 6 - Initial Model Smoke Test

## Download Test Model

```bash
ollama pull qwen3:8b-q4_K_M
```

---

## Run Test Model

```bash
ollama run qwen3:8b-q4_K_M
```

Test prompts:

- Explain Linux permissions.
- Explain Docker networking.
- Summarize the purpose of Ollama.

Checklist:

- [ ] Model loads successfully.
- [ ] Responses generated.
- [ ] No memory errors.
- [ ] No crashes.

---

## Performance Validation

Monitor:

```bash
nvidia-smi
```

Record observations:

| Metric | Result |
|----------|----------|
| Response Speed | |
| GPU Usage | |
| RAM Usage | |
| Temperature | |
| Stability | |

Checklist:

- [ ] Performance acceptable.
- [ ] Temperatures acceptable.
- [ ] System remains responsive.

---

# Phase 7 - Open WebUI Deployment

## Installation

Checklist:

- [ ] Deployment completed.
- [ ] Persistent storage configured.
- [ ] Administrator account created.

---

## Security

Checklist:

- [ ] Authentication enabled.
- [ ] Strong password configured.
- [ ] Public exposure disabled.

---

## Validation

Checklist:

- [ ] Login successful.
- [ ] Models displayed.
- [ ] Chat interface operational.
- [ ] Ollama connectivity verified.

---

# Phase 8 - Tailscale Deployment (Optional)

## Installation

```bash
bash setup_tailscale.sh
```

Checklist:

- [ ] Tailscale installed.
- [ ] Tailnet joined.
- [ ] Node appears in admin console.

---

## Validation

- [ ] Access works from approved devices.
- [ ] Access denied for unauthorized devices.
- [ ] ACLs reviewed.

---

# Phase 9 - n8n Deployment (Optional)

## Installation

```bash
bash setup_n8n.sh
```

Checklist:

- [ ] Installed successfully.
- [ ] Encryption key generated.
- [ ] Encryption key backed up.
- [ ] Administrator account created.

---

## Validation

Checklist:

- [ ] Login works.
- [ ] Workflow import works.
- [ ] Sample workflow runs.
- [ ] Ollama integration operational.

---

# Phase 10 - Paperclip Deployment (Optional)

## Installation

```bash
bash setup_paperclip.sh
```

Checklist:

- [ ] Installed successfully.
- [ ] Version recorded.
- [ ] Authentication configured.

Version:

```
____________________________
```

---

## Validation

Checklist:

- [ ] Login successful.
- [ ] Dashboard operational.
- [ ] Access controls verified.

---

# Phase 11 - Specialist Models

## Installation

```bash
bash setup_models.sh
```

Checklist:

- [ ] Base models downloaded.
- [ ] Specialist roles created.
- [ ] Model list verified.

---

## Validation

```bash
ollama list
```

Checklist:

- [ ] lab-assistant available.
- [ ] lab-codewright available.
- [ ] Specialist models operational.

---

# Phase 12 - Security Review

## Authentication

- [ ] Open WebUI protected.
- [ ] n8n protected.
- [ ] Paperclip protected.

---

## Network Exposure

Verify:

```bash
ss -tulpn
```

Checklist:

- [ ] Ollama bound to 127.0.0.1.
- [ ] No unexpected listening ports.
- [ ] Firewall configured.
- [ ] No router port forwarding.

---

## Secrets

Checklist:

- [ ] API keys secured.
- [ ] Encryption keys secured.
- [ ] Secrets excluded from Git.
- [ ] Backups secured.

---

# Phase 13 - Backup Validation

## Data

- [ ] Open WebUI backed up.
- [ ] n8n backed up.
- [ ] Paperclip backed up.
- [ ] Configuration backed up.

---

## Recovery Testing

- [ ] Restore process documented.
- [ ] Restore process tested.
- [ ] Encryption keys recoverable.

---

# Phase 14 - GitHub Pages Publication (Optional)

Checklist:

- [ ] Publication directory reviewed.
- [ ] Allowlist implemented.
- [ ] No secrets included.
- [ ] Documentation reviewed.
- [ ] Links tested.

---

# Final Acceptance Checklist

## Infrastructure

- [ ] Ubuntu operational.
- [ ] NVIDIA drivers operational.
- [ ] GPUs verified.
- [ ] Storage verified.

## AI Platform

- [ ] Ollama operational.
- [ ] Smoke test passed.
- [ ] Specialist models created.

## User Access

- [ ] Open WebUI operational.
- [ ] Tailscale operational (if used).
- [ ] Authentication enabled.

## Automation

- [ ] n8n operational (if used).
- [ ] Paperclip operational (if used).

## Security

- [ ] Security review completed.
- [ ] Backups completed.
- [ ] Recovery process documented.

## Documentation

- [ ] README reviewed.
- [ ] ROADMAP updated.
- [ ] Deployment notes recorded.

---

# Deployment Notes

Date:

```
____________________________
```

Deployed By:

```
____________________________
```

Environment:

```
____________________________
```

Notes:

```
________________________________________________

________________________________________________

________________________________________________

________________________________________________
```

# Deployment Status

- [ ] Successful
- [ ] Successful With Issues
- [ ] Failed
- [ ] Requires Additional Testing