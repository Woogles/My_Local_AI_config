# Hermes Agents

## Overview

Hermes Agents is a collection of specialized AI personas designed to assist with every aspect of the Local AI Test Lab ecosystem.

Rather than relying on a single general-purpose assistant, Hermes uses a team of domain experts, each focused on a specific area of knowledge and operational responsibility.

Every agent combines:

- A specific technical specialty
- A unique personality
- Consistent behavioral patterns
- A documented system prompt
- Clear operational boundaries

This approach makes it easier to obtain focused and context-aware assistance while maintaining consistency across the lab.

---

# Design Philosophy

Hermes follows several design principles:

## Specialization

Each agent should own a specific area of expertise.

Example:

- Networking belongs to Hermes Net
- Security belongs to Hermes Security
- Documentation belongs to Hermes Wiki

Avoid unnecessary overlap.

---

## Consistency

Agent behavior should remain predictable.

Users should know what to expect from a particular specialist.

---

## Documentation

All agents are documented individually.

Every agent includes:

- Purpose
- Personality
- Scope
- Responsibilities
- Boundaries
- System Prompt
- Related Agents

---

## Education First

Whenever practical:

- Explain concepts
- Document reasoning
- Encourage learning
- Promote best practices

Hermes is intended to teach, not merely provide answers.

---

## Security Awareness

Security considerations should be incorporated into recommendations whenever appropriate.

Special emphasis is placed on:

- Authentication
- Network exposure
- Access control
- Backups
- Recovery planning

---

# Agent Categories

## Router

| Agent | Purpose |
|---------|---------|
| Hermes Boss | Request triage and specialist routing |

---

## Infrastructure

| Agent | Purpose |
|---------|---------|
| Hermes Net | Networking, VLANs, routing |
| Hermes Virt | Virtualization and containers |
| Hermes Hardware | Physical hardware and servers |
| Hermes Monitor | Monitoring and observability |
| Hermes Gate | DNS and edge services |

---

## Security & Operations

| Agent | Purpose |
|---------|---------|
| Hermes Security | Security and hardening |
| Hermes Backup | Backup and disaster recovery |
| Hermes Wiki | Documentation and knowledge management |

---

## AI & Development

| Agent | Purpose |
|---------|---------|
| Hermes Codewright | Software development |
| Hermes Mentor | Education and learning |
| Hermes AI | Local AI and prompt engineering |

---

## Media

| Agent | Purpose |
|---------|---------|
| Hermes Media | Plex and media libraries |
| Hermes Archivist | Arr stack and media automation |

---

## Home Lab

| Agent | Purpose |
|---------|---------|
| Hermes Jarvis | General lab assistance |
| Hermes IoT | Home automation and smart devices |

---

## Experimental

| Agent | Purpose |
|---------|---------|
| Hermes Chaos | Creativity and experimentation |

---

# Agent Directory

## Core Routing

| Agent | File |
|---------|---------|
| Hermes Boss | `hermes-boss.md` |

---

## Infrastructure

| Agent | File |
|---------|---------|
| Hermes Net | `hermes-net.md` |
| Hermes Virt | `hermes-virt.md` |
| Hermes Hardware | `hermes-hw.md` |
| Hermes Monitor | `hermes-monitor.md` |
| Hermes Gate | `hermes-gate.md` |

---

## Security & Operations

| Agent | File |
|---------|---------|
| Hermes Security | `hermes-security.md` |
| Hermes Backup | `hermes-backup.md` |
| Hermes Wiki | `hermes-wiki.md` |

---

## AI & Development

| Agent | File |
|---------|---------|
| Hermes Codewright | `hermes-codewright.md` |
| Hermes Mentor | `hermes-mentor.md` |
| Hermes AI | `hermes-ai.md` |

---

## Media

| Agent | File |
|---------|---------|
| Hermes Media | `hermes-media.md` |
| Hermes Archivist | `hermes-archivist.md` |

---

## Home Lab

| Agent | File |
|---------|---------|
| Hermes Jarvis | `hermes-jarvis.md` |
| Hermes IoT | `hermes-iot.md` |

---

## Experimental

| Agent | File |
|---------|---------|
| Hermes Chaos | `hermes-chaos.md` |

---

# Agent Relationships

The following diagrams illustrate the intended relationships between specialists.

## User Workflow

```text
User
  │
  ▼
Hermes Boss
  │
  ├── Code Requests ─────────────► Hermes Codewright
  ├── AI Requests ───────────────► Hermes AI
  ├── Learning Requests ─────────► Hermes Mentor
  │
  ├── Networking ────────────────► Hermes Net
  ├── Virtualization ────────────► Hermes Virt
  ├── Hardware ──────────────────► Hermes Hardware
  ├── Monitoring ────────────────► Hermes Monitor
  ├── DNS / Proxy ───────────────► Hermes Gate
  │
  ├── Security ──────────────────► Hermes Security
  ├── Backups ───────────────────► Hermes Backup
  ├── Documentation ─────────────► Hermes Wiki
  │
  ├── Media Libraries ───────────► Hermes Media
  ├── Media Automation ──────────► Hermes Archivist
  │
  ├── Home Assistant ────────────► Hermes IoT
  ├── General Assistance ────────► Hermes Jarvis
  │
  └── Creative Requests ─────────► Hermes Chaos
```

---

# Recommended Agent Selection

## I Need Help With Code

Use:

```text
Hermes Codewright
```

---

## I Need Help Learning

Use:

```text
Hermes Mentor
```

---

## I Need Help With AI

Use:

```text
Hermes AI
```

---

## I Need Help With Networking

Use:

```text
Hermes Net
```

---

## I Need Help With Containers

Use:

```text
Hermes Virt
```

---

## I Need Help With Security

Use:

```text
Hermes Security
```

---

## I Need Help With Backups

Use:

```text
Hermes Backup
```

---

## I Need Help With Home Assistant

Use:

```text
Hermes IoT
```

---

## I Need Help With Documentation

Use:

```text
Hermes Wiki
```

---

## I Just Need General Assistance

Use:

```text
Hermes Jarvis
```

---

## I Don't Know Which Agent To Use

Use:

```text
Hermes Boss
```

Hermes Boss serves as the front door to the entire system and can recommend the appropriate specialist.

---

# Adding New Agents

When creating a new Hermes specialist:

## Requirements

- Clear purpose
- Clear technical ownership
- Distinct personality
- Minimal overlap with existing agents
- Documented responsibilities
- Documented boundaries

---

## Process

1. Copy `TEMPLATE.md`
2. Create a new agent file
3. Define responsibilities
4. Define exclusions
5. Create a system prompt
6. Add examples
7. Update this README

---

# Agent Naming Standard

Preferred naming convention:

```text
hermes-<function>.md
```

Examples:

```text
hermes-security.md
hermes-net.md
hermes-monitor.md
```

Avoid:

```text
security-agent-final-v3.md
networking_helper.md
```

Consistency improves maintainability.

---

# Agent Lifecycle

### Draft

Agent idea under development.

### Active

Documented and in use.

### Deprecated

Replaced by another specialist.

### Archived

Retained for historical reference.

---

# Historical Reference

The original consolidated definitions are preserved in:

```text
Agents_ARCHIVE.txt
```

This file serves as the historical source material from which the individual agent files were created.

Future edits should be made to the dedicated agent files rather than the archive.

---

# Future Expansion

Potential future Hermes specialists include:

- Kubernetes Specialist
- Storage Architect
- Cloud Architect
- Database Administrator
- Linux Distribution Specialist
- Incident Response Coordinator
- Compliance Officer
- Observability Architect

Additional specialists should be added only when there is a clear operational need.
---

# Deployment

## Understanding Hermes Agent Files

Each Hermes Agent document serves two purposes:

1. Human-readable documentation
2. Machine-deployable prompt definition

The most important section within every agent file is:

```markdown
## System Prompt
```

The contents of the System Prompt section are what should be deployed to the AI platform.

Everything else in the file exists to help maintain, document, and govern the agent.

---

## What Gets Deployed

Example:

```markdown
## System Prompt

You are Alastor Moody.

CONSTANT VIGILANCE!

You assume every open port is a breach...
```

Only the contents of the prompt should be copied into the deployment platform.

The following sections are documentation only:

- Primary Purpose
- Responsibilities
- Out of Scope
- Personality
- Operating Principles
- Example Tasks
- Related Agents
- Version History

These sections exist for maintainers and future development.

---

## Supported Deployment Platforms

Hermes Agents can be deployed to:

- Ollama Modelfiles
- Open WebUI Assistants
- Open WebUI Workspace Characters
- LibreChat Assistants
- AnythingLLM Agents
- n8n AI Agent Nodes
- CrewAI Roles
- LangChain Agents
- AutoGen Agents
- OpenAI Custom GPTs
- Claude Projects

Any platform that supports custom system prompts can host a Hermes Agent.

---

## Example: Ollama Deployment

Example Modelfile:

```text
FROM qwen3:14b

SYSTEM """
You are Alastor Moody.

CONSTANT VIGILANCE!

You assume every open port is a breach...
"""
```

Create the model:

```bash
ollama create hermes-security -f Modelfile
```

Run the model:

```bash
ollama run hermes-security
```

---

## Example: Open WebUI Deployment

Create a new assistant.

Name:

```text
Hermes Security
```

Description:

```text
Security and hardening specialist.
```

Instructions:

Paste the contents of:

```markdown
## System Prompt
```

from the associated Hermes file.

---

## Example: n8n Deployment

Within an AI Agent node:

```text
System Message
```

Paste:

```markdown
## System Prompt
```

from the desired Hermes Agent.

---

## Recommended Deployment Architecture

The recommended deployment strategy is:

```text
User
 │
 ▼
Hermes Boss
 │
 ├── Security
 ├── Networking
 ├── AI
 ├── Backup
 ├── Monitoring
 ├── Documentation
 └── Other Specialists
```

The Boss agent acts as the front door and routes users toward the proper specialist.

---

## Future Prompt Separation

The current design stores prompts and documentation together.

Future versions may separate deployment prompts into:

```text
Hermes Agents/
├── Documentation/
└── Prompts/
```

Example:

```text
Prompts/
├── hermes-security.prompt
├── hermes-net.prompt
├── hermes-ai.prompt
└── ...
```

This would allow automated deployment without parsing Markdown files.

---

# Version History

| Version | Change |
|----------|----------|
| 1.0 | Initial Hermes documentation system created |
| 1.1 | Individual agent files introduced |
| Future | Additional specialists and documentation improvements |
