# ADR-004 - GitHub Pages Allowlist Publishing

## Status

Accepted

## Context

Publishing entire repositories can accidentally expose files not intended for public consumption.

## Decision

GitHub Pages content should be sourced from an explicit allowlist.

Only approved documentation and public assets should be published.

## Consequences

### Advantages

- Reduced risk of accidental publication
- Better control of public content
- Easier audits

### Disadvantages

- Additional workflow maintenance

## Alternatives Considered

### Publish Entire Repository

Rejected due to risk of exposing internal files.

### Manual Uploads

Rejected due to poor repeatability.

## Security Notes

No secrets should ever be committed to Git.

GitHub Pages should be treated as fully public.