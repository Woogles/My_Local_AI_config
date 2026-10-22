# ADR-002 - Tailscale Remote Access

## Status

Accepted

## Context

Remote access is useful for administration and AI interaction.

Traditional approaches require:

- Port forwarding
- Dynamic DNS
- Exposed services

## Decision

Remote access will be provided through Tailscale.

## Consequences

### Advantages

- No router changes
- Encrypted communication
- Device-level authorization
- Easier administration

### Disadvantages

- Dependency on Tailscale
- Additional client software required

## Alternatives Considered

### Port Forwarding

Rejected due to security concerns.

### VPN Server

Rejected due to additional administrative burden.

## Security Notes

Tailscale does not replace application authentication.

Open WebUI, n8n, and other services should still require authentication.