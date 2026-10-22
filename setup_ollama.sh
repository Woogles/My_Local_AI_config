#!/usr/bin/env bash
set -Eeuo pipefail

if [[ ! -f /etc/os-release ]] || ! . /etc/os-release || [[ "${ID:-}" != "ubuntu" ]]; then
    printf 'This setup script is intended for Ubuntu.\n' >&2
    exit 1
fi

if ! command -v systemctl >/dev/null 2>&1; then
    printf 'Error: systemd is required to configure the Ollama service.\n' >&2
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

if ! command -v ollama >/dev/null 2>&1; then
    printf 'Installing Ollama with its official installer...\n'
    curl -fsSL https://ollama.com/install.sh | sh
fi

override_dir="/etc/systemd/system/ollama.service.d"
override_file="${override_dir}/override.conf"
run_root install -d -m 0755 "$override_dir"
run_root tee "$override_file" >/dev/null <<'EOF'
[Service]
Environment="OLLAMA_HOST=127.0.0.1:11434"
Environment="OLLAMA_KEEP_ALIVE=5m"
Environment="OLLAMA_NUM_PARALLEL=1"
Environment="OLLAMA_MAX_LOADED_MODELS=1"
EOF

printf 'Configuring Ollama for local-only access...\n'
run_root systemctl daemon-reload
run_root systemctl enable --now ollama
run_root systemctl restart ollama

for attempt in {1..20}; do
    if curl --silent --fail http://127.0.0.1:11434/api/tags >/dev/null; then
        printf '\nOllama is ready at http://127.0.0.1:11434\n'
        printf 'API binding is loopback-only; it is not exposed directly to your LAN or the internet.\n'
        printf 'Next: bash setup_models.sh\n'
        exit 0
    fi
    sleep 1
done

printf 'Error: Ollama did not become ready. Service status follows:\n' >&2
run_root systemctl --no-pager --full status ollama >&2 || true
exit 1