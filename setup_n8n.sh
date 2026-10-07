#!/usr/bin/env bash
set -Eeuo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
compose_dir="${script_dir}/automation"
env_file="${compose_dir}/.env"

if ! command -v docker >/dev/null 2>&1; then
    printf 'Error: Docker Engine and Docker Compose v2 are required.\n' >&2
    printf 'Install Docker, then rerun this script.\n' >&2
    exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
    printf 'Error: Docker Compose v2 is required (docker compose).\n' >&2
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    printf 'Error: Docker is not running or the current user cannot access it.\n' >&2
    exit 1
fi

if ! command -v openssl >/dev/null 2>&1; then
    printf 'Error: openssl is required to generate the n8n encryption key.\n' >&2
    exit 1
fi

mkdir -p "$compose_dir"
if [[ ! -f "$env_file" ]]; then
    umask 077
    encryption_key="$(openssl rand -hex 32)"
    printf 'N8N_ENCRYPTION_KEY=%s\nGENERIC_TIMEZONE=Etc/UTC\nTZ=Etc/UTC\nN8N_VERSION=stable\n' \
        "$encryption_key" > "$env_file"
    printf 'Created private n8n settings at %s\n' "$env_file"
else
    printf 'Using existing n8n settings at %s\n' "$env_file"
fi

cd "$compose_dir"
docker compose --env-file "$env_file" -f compose.yaml config --quiet
docker compose --env-file "$env_file" -f compose.yaml pull
docker compose --env-file "$env_file" -f compose.yaml up -d

printf '\nn8n is starting at http://127.0.0.1:5678\n'
printf 'Create the first-owner account in the browser. Workflows can call Ollama at http://127.0.0.1:11434.\n'
printf 'The n8n port is loopback-only; use a private reverse proxy or SSH tunnel for remote UI access.\n'
