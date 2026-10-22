# Change Log

This log tracks major documentation, deployment, and infrastructure changes.

The project follows a simple versioning approach:

- Major: Significant architectural or deployment changes.
- Minor: New features, scripts, or capabilities.
- Patch: Documentation updates, fixes, or maintenance changes.

---

## Unreleased

### Planned

#### Documentation
- Reorganize repository documentation.
- Create ROADMAP.md.
- Separate model sizing guidance into Model_Recommendations.md.
- Remove obsolete Blueprint.txt references.
- Remove deprecated website references.

#### Deployment
- Create Open WebUI deployment definition.
- Implement allowlisted GitHub Pages publishing.
- Pin n8n versions.
- Pin Paperclip versions.

#### Security
- Improve credential handling.
- Expand .gitignore coverage.
- Review network architecture.
- Review authentication defaults.

#### Accessibility
- Improve keyboard navigation.
- Improve focus visibility.
- Review responsive behavior.

---

## v0.1.0

### Initial Project Foundation

- Created Ollama deployment workflow.
- Added specialist model generation.
- Added n8n support.
- Added Tailscale support.
- Added Paperclip setup.
- Added GitHub Pages support.
- Added project documentation.



# Change Management

To keep the project stable and reproducible, all significant changes should follow this process:

1. Document the proposed change.
2. Test changes in a non-production environment.
3. Record version changes.
4. Update README if deployment steps change.
5. Update ROADMAP if future work changes.
6. Verify installation procedures still function.
7. Verify rollback procedures.
8. Document known impacts.

For infrastructure changes:

- Back up data before updates.
- Back up configuration before updates.
- Document rollback steps.
- Record tested software versions.

For model-related changes:

- Record exact model tags.
- Record quantization.
- Record observed hardware performance.
- Record memory utilization.