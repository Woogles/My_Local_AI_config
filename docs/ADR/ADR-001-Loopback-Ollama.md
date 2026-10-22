# ADR-001 - Loopback-Only Ollama

## Status

Accepted

## Context

Ollama exposes an API that can be reached by any software capable of connecting to the configured interface.

Exposing the API directly creates additional attack surface and increases operational risk.

## Decision

The Ollama API will bind only to:

```text
127.0.0.1:11434
```

## Consequences

### Advantages

- Reduces attack surface
- Prevents accidental exposure
- Simplifies firewall requirements
- Encourages authenticated front-end access

### Disadvantages

- Requires additional configuration for external applications
- Container access requires deliberate design

## Alternatives Considered

### Bind To All Interfaces

Rejected due to increased exposure risk.

### Public Exposure

Rejected.

## Review Date

Future architecture reviews may revisit this decision but secure-by-default remains the preferred approach.