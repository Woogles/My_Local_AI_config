# ADR-003 - Hermes Agent Architecture

## Status

Accepted

## Context

The project requires multiple specialists covering different technical domains.

Maintaining all prompts in one file becomes difficult over time.

## Decision

Hermes Agents will follow:

```text
Documentation
    ↓
Prompt Extraction
    ↓
Prompt Files
    ↓
Deployment
    ↓
Ollama Agents
```

Each agent receives its own documentation file.

## Consequences

### Advantages

- Easier maintenance
- Clear ownership
- Better version control
- Simpler updates

### Disadvantages

- Additional files
- More documentation to maintain

## Alternatives Considered

### Single Agents.txt

Rejected due to maintainability concerns.

### Direct Prompt Files Only

Rejected because documentation would be separated from design intent.

## Future Work

Consider additional deployment targets:

- Open WebUI Assistants
- n8n Agents
- CrewAI
- LangChain