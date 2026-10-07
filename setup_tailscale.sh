#!/usr/bin/env bash
set -Eeuo pipefail

if [[ ! -f /etc/os-release ]] || ! . /etc/os-release || [[ "${ID:-}" != "ubuntu" ]]; then
    printf 'This setup script is intended for Ubuntu.\n' >&2
    exit 1
fi

if ! command -v systemctl >/dev/null 2>&1; then
    printf 'Error: systemd is required to run the Tailscale service.\n' >&2
    exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
    printf 'Error: curl is required. Install it with: sudo apt install curl\n' >&2
    exit 1
fi

if [[ "$EUID" -ne 0 ]] && ! command -v sudo >/dev/null 2>&1; then
    printf 'Error: run as root or install sudo.\n' >&2
    exit 1
fi

run_root() {
    if [[ "$EUID" -eq 0 ]]; then
        "$@"
    else
        sudo "$@"
    fi
}

if ! command -v tailscale >/dev/null 2>&1; then
    printf 'Installing Tailscale with its official installer...\n'
    curl -fsSL https://tailscale.com/install.sh | sh
fi

printf 'Starting the Tailscale service...\n'
run_root systemctl enable --now tailscaled

printf '\nStarting Tailscale login. Follow the one-time URL shown below to add this server to your tailnet.\n'
run_root tailscale up

printf '\nTailscale status:\n'
run_root tailscale status

if tailnet_ip="$(run_root tailscale ip -4 2>/dev/null)" && [[ -n "$tailnet_ip" ]]; then
    printf '\nServer tailnet IPv4: %s\n' "$tailnet_ip"
    printf 'Use this address for trusted tailnet devices; keep Ollama port 11434 private.\n'
else
    printf '\nFinish device authorization using the URL above, then run: sudo tailscale ip -4\n'
fi