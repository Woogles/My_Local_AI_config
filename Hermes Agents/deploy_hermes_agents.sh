#!/usr/bin/env bash

set -euo pipefail

###############################################################################
# Hermes Agent Deployment Script
#
# Creates Ollama agent variants from prompt files.
#
# Expected Structure:
#
# Hermes Agents/
# ├── Prompts/
# │   ├── hermes-security.prompt
# │   ├── hermes-net.prompt
# │   └── ...
# └── deploy_hermes_agents.sh
#
###############################################################################

PROMPT_DIR="./Prompts"
TEMP_DIR="./.generated_modelfiles"

mkdir -p "$TEMP_DIR"

echo
echo "======================================"
echo " Hermes Agent Deployment"
echo "======================================"
echo

###############################################################################
# Verify Ollama
###############################################################################

if ! command -v ollama >/dev/null 2>&1; then
    echo "ERROR: Ollama is not installed."
    exit 1
fi

###############################################################################
# Verify Models
###############################################################################

declare -A AGENTS

AGENTS["hermes-boss"]="qwen3:14b"
AGENTS["hermes-codewright"]="qwen2.5-coder:14b"
AGENTS["hermes-net"]="qwen3:14b"
AGENTS["hermes-virt"]="qwen3:14b"
AGENTS["hermes-media"]="qwen3:14b"
AGENTS["hermes-hw"]="qwen3:14b"
AGENTS["hermes-security"]="qwen3:14b"
AGENTS["hermes-mentor"]="qwen3:14b"
AGENTS["hermes-archivist"]="qwen3:14b"
AGENTS["hermes-jarvis"]="qwen3:14b"
AGENTS["hermes-chaos"]="qwen3:14b"
AGENTS["hermes-backup"]="qwen3:14b"
AGENTS["hermes-monitor"]="qwen3:14b"
AGENTS["hermes-iot"]="qwen3:14b"
AGENTS["hermes-ai"]="qwen3:14b"
AGENTS["hermes-gate"]="qwen3:14b"
AGENTS["hermes-wiki"]="qwen3:14b"

###############################################################################
# Deployment Loop
###############################################################################

SUCCESS=0
FAILED=0

for AGENT in "${!AGENTS[@]}"
do

    MODEL="${AGENTS[$AGENT]}"
    PROMPT_FILE="${PROMPT_DIR}/${AGENT}.prompt"
    MODELFILE="${TEMP_DIR}/${AGENT}.Modelfile"

    echo
    echo "Deploying: ${AGENT}"

    if [[ ! -f "$PROMPT_FILE" ]]; then
        echo "  ERROR: Missing prompt file"
        FAILED=$((FAILED+1))
        continue
    fi

    cat > "$MODELFILE" <<EOF
FROM ${MODEL}

PARAMETER temperature 0.2
PARAMETER num_ctx 4096

SYSTEM """
$(cat "$PROMPT_FILE")
"""
EOF

    if ollama create "$AGENT" -f "$MODELFILE"; then
        echo "  SUCCESS"
        SUCCESS=$((SUCCESS+1))
    else
        echo "  FAILED"
        FAILED=$((FAILED+1))
    fi

done

###############################################################################
# Summary
###############################################################################

echo
echo "======================================"
echo " Deployment Summary"
echo "======================================"
echo

echo "Successful: $SUCCESS"
echo "Failed:     $FAILED"

echo
echo "Installed Hermes Agents:"
echo

ollama list | grep hermes || true

echo
echo "Deployment Complete"
echo