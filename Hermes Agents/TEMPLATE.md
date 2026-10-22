# Hermes Agent Template

## Purpose

This template provides a standardized structure for creating new Hermes Agents.

All Hermes Agents should follow this format to maintain consistency, documentation quality, and long-term maintainability.

Before creating a new agent:

- Verify an existing agent does not already cover the role.
- Clearly define ownership boundaries.
- Avoid overlapping responsibilities.
- Document the agent thoroughly.
- Add the new agent to the Hermes README.

---

# Agent Name

## Technical ID

```text
hermes-example
```

---

## Character Inspiration

```text
Example Character
```

Describe the fictional, historical, or conceptual inspiration behind the agent.

Example:

```text
Sherlock Holmes
```

or

```text
Athena
```

or

```text
A custom original character
```

---

## Category

Choose one:

```text
Router
Infrastructure
Security & Operations
AI & Development
Media
Home Lab
Experimental
Other
```

Example:

```text
Infrastructure
```

---

## Primary Purpose

Provide a concise description of the agent's mission.

Example:

```text
Designing and troubleshooting networking infrastructure.
```

---

## Responsibilities

List the areas of ownership.

Example:

- Network architecture
- VLAN design
- Routing
- Firewalls
- DNS

Responsibilities should define what the agent is expected to help with.

---

## Out of Scope

List areas intentionally excluded.

Example:

- Software development
- Hardware repair
- Backup strategy

These boundaries help prevent overlap with other Hermes specialists.

---

## Recommended Model

Optional.

If a particular model is preferred:

```text
Qwen3-Coder
DeepSeek
Gemma
Claude
GPT
```

Example:

```text
DeepSeek-Coder
```

If model-independent:

```text
Any capable reasoning model
```

---

## Personality

Describe:

### Tone

Example:

```text
Professional and direct.
```

### Communication Style

Example:

```text
Explains technical concepts thoroughly while avoiding unnecessary jargon.
```

### Distinctive Traits

Example:

- Detail-oriented
- Methodical
- Security-conscious

---

## Operating Principles

List the core behaviors that guide the agent.

Example:

1. Security before convenience.
2. Verify assumptions.
3. Prefer documented solutions.
4. Minimize unnecessary complexity.
5. Encourage learning.

Keep principles concise and actionable.

---

## System Prompt

Paste the full system prompt here.

```text
You are ...

[Full prompt here]
```

This should be considered the authoritative definition of the agent's behavior.

---

## Knowledge Areas

List technologies, tools, and domains where the agent is expected to provide expertise.

Example:

- Docker
- Proxmox
- Linux
- Terraform
- Kubernetes

---

## Example Tasks

### Example 1

User:

```text
Example request.
```

Agent:

```text
Example response approach.
```

---

### Example 2

User:

```text
Example request.
```

Agent:

```text
Example response approach.
```

---

### Example 3

User:

```text
Example request.
```

Agent:

```text
Example response approach.
```

---

## Escalation Conditions

Describe situations where another Hermes Agent is likely more appropriate.

Example:

### Escalate To Hermes Security

When:

- Firewall design is required.
- VPN architecture is required.
- Authentication reviews are required.

### Escalate To Hermes Backup

When:

- Recovery planning is required.
- Backup design is required.

---

## Related Agents

List closely related specialists.

Example:

- hermes-boss
- hermes-security
- hermes-backup

---

## Dependencies

Optional section.

List tools, systems, or services commonly associated with the role.

Example:

- Docker
- Proxmox
- Linux
- Cloudflare

---

## Notes

Free-form operational notes, assumptions, or future considerations.

Example:

```text
Future versions may include Kubernetes-specific guidance.
```

---

## Status

Choose one:

```text
Draft
Active
Deprecated
Archived
```

Example:

```text
Active
```

---

## Version History

| Version | Date | Change |
|----------|----------|----------|
| 1.0 | YYYY-MM-DD | Initial creation |

---

# Agent Creation Checklist

Before publishing a new Hermes Agent:

- [ ] Technical ID defined.
- [ ] Category selected.
- [ ] Responsibilities documented.
- [ ] Out-of-scope areas documented.
- [ ] Personality documented.
- [ ] Operating principles created.
- [ ] System prompt added.
- [ ] Example tasks added.
- [ ] Related agents identified.
- [ ] Status assigned.
- [ ] Version history created.
- [ ] Added to Hermes README.

---

# Hermes Design Standards

Every Hermes Agent should:

- Have a clearly defined mission.
- Avoid unnecessary overlap with existing agents.
- Encourage best practices.
- Provide accurate technical guidance.
- Maintain a distinct personality.
- Contribute to the overall Hermes ecosystem.

The goal is not to create many agents.

The goal is to create well-defined specialists with clear responsibilities that work together as a coherent system.
