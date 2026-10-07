#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "$EUID" -eq 0 ]]; then
    printf 'Run this as your regular Ubuntu user, not with sudo. Paperclip stores private state in that user account.\n' >&2
    exit 1
fi

if ! command -v node >/dev/null 2>&1 || ! command -v npx >/dev/null 2>&1; then
    printf 'Error: Node.js 24.11+ and npx are required. See https://nodejs.org/ or Paperclip installation docs.\n' >&2
    exit 1
fi

if ! node -e 'const [major, minor] = process.versions.node.split(".").map(Number); process.exit(major > 24 || (major === 24 && minor >= 11) ? 0 : 1)'; then
    printf 'Error: Paperclip requires Node.js 24.11 or newer; found %s.\n' "$(node --version)" >&2
    exit 1
fi

if ! command -v tailscale >/dev/null 2>&1; then
    printf 'Error: Tailscale is not installed. Run bash setup_tailscale.sh first.\n' >&2
    exit 1
fi

if ! tailscale_ip="$(sudo tailscale ip -4 2>/dev/null)" || [[ -z "$tailscale_ip" ]]; then
    printf 'Error: Tailscale is not connected. Authorize this server, then rerun the script.\n' >&2
    exit 1
fi

printf 'Starting Paperclip onboarding with authenticated, private tailnet access.\n'
printf 'This installs the Paperclip background service and creates its local instance state.\n\n'
npx --yes paperclipai@latest onboard --yes --bind tailnet --install-service

printf '\nPaperclip onboarding finished. The instance is configured for private tailnet access.\n'
printf 'Review the Paperclip output for the dashboard URL and finish any first-owner setup it requests.\n'
printf 'Paperclip agents still need a configured runtime and model provider; this script does not create provider credentials.\n'
