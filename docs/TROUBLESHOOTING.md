# Troubleshooting

This document contains diagnostic commands, common issues, recovery procedures, and validation steps for the Local AI Test Lab.

---

# General Health Check

When troubleshooting, start here.

## System Information

```bash
hostnamectl
```

## Disk Usage

```bash
df -h
```

## Memory Usage

```bash
free -h
```

## CPU Utilization

```bash
top
```

or

```bash
htop
```

## Reboot History

```bash
last reboot
```

---

# GPU Troubleshooting

## Verify NVIDIA Driver

```bash
nvidia-smi
```

Expected:

```text
GPU information is displayed
```

---

## Verify Driver Module

```bash
lsmod | grep nvidia
```

Expected:

```text
nvidia
nvidia_uvm
```

---

## Verify Installed Driver

```bash
ubuntu-drivers devices
```

---

## Install Recommended Driver

```bash
sudo ubuntu-drivers autoinstall
```

Reboot:

```bash
sudo reboot
```

---

## Monitor GPU Usage

```bash
watch -n 1 nvidia-smi
```

---

## GPU Temperature Check

```bash
nvidia-smi --query-gpu=temperature.gpu --format=csv
```

---

## GPU Not Detected

Verify PCI device exists:

```bash
lspci | grep -i nvidia
```

Expected:

```text
NVIDIA Corporation
```

If no result:

- Reseat GPU
- Check BIOS
- Verify power connections

---

# Ollama Troubleshooting

## Verify Service Status

```bash
systemctl status ollama
```

---

## Restart Ollama

```bash
sudo systemctl restart ollama
```

---

## Enable Ollama At Boot

```bash
sudo systemctl enable ollama
```

---

## View Logs

```bash
journalctl -u ollama -n 100
```

Live Logs:

```bash
journalctl -u ollama -f
```

---

## Verify API

```bash
curl http://127.0.0.1:11434/api/tags
```

Expected:

```json
{
  "models": [...]
}
```

---

## Verify Bound Address

```bash
ss -tulpn | grep 11434
```

Expected:

```text
127.0.0.1:11434
```

Not:

```text
0.0.0.0:11434
```

---

## List Installed Models

```bash
ollama list
```

---

## Remove Model

```bash
ollama rm MODEL_NAME
```

Example:

```bash
ollama rm qwen3:14b
```

---

## Download Model Again

```bash
ollama pull qwen3:14b
```

---

## Test Model

```bash
ollama run qwen3:14b
```

---

## Ollama Using CPU

Verify:

```bash
nvidia-smi
```

Check logs:

```bash
journalctl -u ollama -n 50
```

Possible causes:

- Driver issue
- CUDA issue
- Model too large
- VRAM exhausted

---

# Open WebUI Troubleshooting

## Verify Container

```bash
docker ps
```

---

## View Logs

```bash
docker logs open-webui
```

---

## Restart Container

```bash
docker restart open-webui
```

---

## Verify Ollama Connectivity

Inside container:

```bash
docker exec -it open-webui bash
```

Test:

```bash
curl http://HOST_IP:11434/api/tags
```

---

## Models Missing

Verify:

```bash
ollama list
```

Verify:

```bash
curl http://127.0.0.1:11434/api/tags
```

Check Open WebUI configuration.

---

# Docker Troubleshooting

## Docker Status

```bash
systemctl status docker
```

---

## Restart Docker

```bash
sudo systemctl restart docker
```

---

## Running Containers

```bash
docker ps
```

---

## All Containers

```bash
docker ps -a
```

---

## Container Logs

```bash
docker logs CONTAINER_NAME
```

---

# n8n Troubleshooting

## Verify Container

```bash
docker ps
```

---

## View Logs

```bash
docker logs n8n
```

---

## Restart

```bash
docker restart n8n
```

---

## Verify Port

```bash
ss -tulpn | grep 5678
```

Expected:

```text
127.0.0.1:5678
```

---

## Encryption Key Recovery

Verify:

```bash
cat automation/.env
```

Contains:

```text
N8N_ENCRYPTION_KEY
```

Without the original key:

- Stored credentials cannot be decrypted.

---

# Tailscale Troubleshooting

## Verify Status

```bash
tailscale status
```

---

## Verify IP

```bash
tailscale ip
```

---

## Ping Tailnet Device

```bash
tailscale ping HOSTNAME
```

---

## Reauthenticate

```bash
sudo tailscale up
```

---

## Connectivity Check

```bash
ping TAILSCALE_IP
```

---

# Hermes Agent Troubleshooting

## Verify Extraction

Navigate:

```bash
cd "Hermes Agents"
```

Run:

```bash
python3 extract_prompts.py
```

Expected:

```text
Generated : 17
Failed : 0
```

---

## Verify Prompt Files

```bash
ls -lah Prompts/
```

Expected:

```text
17 prompt files
```

---

## Verify Prompt Contents

Example:

```bash
cat Prompts/hermes-security.prompt
```

Expected:

```text
You are Alastor Moody...
```

---

## Verify Mapping File

```bash
cat model_mapping.json
```

Validate:

```bash
jq . model_mapping.json
```

---

## Deploy Hermes Agents

```bash
bash deploy_hermes_agents.sh
```

---

## Verify Hermes Models

```bash
ollama list | grep hermes
```

Expected:

```text
17 Hermes models
```

---

## Test Hermes Security

```bash
ollama run hermes-security
```

Prompt:

```text
Review this firewall design.
```

Expected:

Security-focused response.

---

# Network Troubleshooting

## Open Ports

```bash
ss -tulpn
```

---

## Firewall Status

```bash
sudo ufw status verbose
```

---

## Enable Firewall

```bash
sudo ufw enable
```

---

## Allow SSH

```bash
sudo ufw allow 22/tcp
```

---

## Verify DNS

```bash
dig google.com
```

---

## Verify Routes

```bash
ip route
```

---

# Backup Verification

## Verify Backup Storage

```bash
df -h
```

---

## Verify Backup Files

```bash
ls -lah BACKUP_DIRECTORY
```

---

## Test Restore

Perform a scheduled restore test quarterly.

Document:

- Restore duration
- Problems encountered
- Recovery requirements

---

# GitHub Actions Troubleshooting

## Review Workflow Runs

GitHub:

```text
Actions → Workflow Runs
```

---

## YAML Validation

```bash
yamllint .github/workflows/pages.yml
```

---

# Emergency Recovery Checklist

If the system becomes unstable:

```text
1. Verify hardware
2. Verify storage
3. Verify GPU
4. Verify Ollama
5. Verify Docker
6. Verify Tailscale
7. Verify Open WebUI
8. Verify Hermes prompts
9. Verify Hermes deployment
10. Restore backups if required
```

---

# Validation Commands

## Complete Platform Validation

```bash
nvidia-smi

ollama list

curl http://127.0.0.1:11434/api/tags

docker ps

tailscale status

ollama run hermes-jarvis
```

If all commands succeed, platform status is considered operational.
