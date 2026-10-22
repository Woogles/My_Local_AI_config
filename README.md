# ROADMAP

## Project Status

Local AI Test Lab is actively under development.

The core installation scripts and documentation provide a functional starting point for local AI experimentation, but several deployment, security, maintainability, and usability improvements remain planned.

This roadmap tracks the major tasks, recommendations, and future work identified during project review.

The project's immediate objective is to create a stable, secure, and easily reproducible home-lab AI environment built around:

- Ollama
- Open WebUI
- Optional automation tooling
- Specialist AI roles
- GitHub Pages documentation
- Local-first deployment principles

---

# Guiding Principles

As development continues, the project should remain aligned with the following principles:

- Local-first AI inference
- Conservative security defaults
- Loopback-only Ollama access
- Authentication by default
- Minimal network exposure
- Reproducible deployments
- Simplicity over unnecessary complexity
- Measured performance validation before scaling

---

# High Priority

These items should be addressed before the project is considered mature.

## Implement Allowlisted GitHub Pages Publishing

### Current State

GitHub Pages publishing is intended to expose both project documentation and selected project files.

### Goal

Create a dedicated publication directory and publish only reviewed files.

### Benefits

- Prevents accidental publication of repository contents
- Reduces security risk
- Makes the public site easier to maintain
- Establishes a clean separation between source files and published artifacts

### Tasks

- Create a dedicated `public/` directory
- Build GitHub Pages artifacts from an explicit allowlist
- Exclude:
  - GitHub workflows
  - Local configuration
  - Secrets
  - Generated state
  - Obsolete documents

---

## Open WebUI Deployment Automation

### Current State

Open WebUI is documented but not fully automated through project-provided deployment assets.

### Goal

Provide a repeatable deployment method.

### Desired Outcome

- Version-pinned deployment
- Persistent storage
- Backup guidance
- Documented upgrades
- Authentication enabled by default

### Tasks

- Create deployment definition
- Pin image versions
- Document upgrades
- Document backups
- Document recovery procedures

---

## Pin Software Versions

### Current State

Some deployments rely on moving version targets.

### Risk

Future deployments may behave differently than tested environments.

### Goal

Use explicit, reviewed versions whenever practical.

### Candidate Targets

- n8n
- Paperclip
- Open WebUI
- Related containers
- GitHub Actions

### Tasks

- Identify tested versions
- Document version matrix
- Upgrade through deliberate review rather than automatic drift

---

## Review Network Architecture

### Current State

The networking model remains functional but intentionally conservative.

### Goal

Develop documented network architecture for:

- LAN access
- Tailscale access
- Optional reverse proxy deployment
- Service isolation

### Questions To Resolve

- Which services should be LAN-accessible?
- Which services should remain local-only?
- Should a reverse proxy become standard?
- How should authentication be enforced?

---

## Authentication Review

### Goal

Ensure all user-facing services require authentication.

### Scope

- Open WebUI
- n8n
- Paperclip
- Future services

### Tasks

- Verify authentication defaults
- Review recovery procedures
- Document administrator setup
- Document access-control recommendations

---

# Medium Priority

Important improvements that enhance reliability and maintainability.

## Improve Secret Management

### Current State

Secret handling remains basic.

### Goal

Reduce risk of accidental exposure.

### Tasks

- Expand ignore rules
- Review configuration storage
- Review backup procedures
- Add secret-scanning workflow
- Document credential rotation procedures

---

## Expand .gitignore

### Current State

Only limited generated files are excluded.

### Goal

Protect common local artifacts.

### Candidate Additions

- Environment files
- Temporary data
- Local databases
- Container volumes
- IDE configuration
- Build outputs

### Notes

`.gitignore` should be treated as a convenience feature, not a security boundary.

---

## Service Configuration Backups

### Goal

Prevent configuration loss during upgrades and experimentation.

### Areas of Interest

- Open WebUI
- n8n
- Paperclip
- Ollama configuration

### Tasks

- Identify critical files
- Document backup locations
- Create restore procedures
- Validate disaster recovery process

---

## Improve Accessibility

### Current State

Accessibility has not yet been fully reviewed.

### Goal

Improve usability across devices and input methods.

### Areas To Evaluate

- Keyboard navigation
- Focus visibility
- Contrast
- Screen-reader compatibility
- Mobile usability

### Tasks

- Add visible focus indicators
- Improve keyboard workflows
- Improve navigation behavior
- Verify responsive layouts

---

## Deployment Documentation Consistency

### Goal

Establish a single source of truth.

### Tasks

- Keep README current
- Update ROADMAP alongside major project changes
- Remove obsolete instructions
- Ensure installation order remains consistent

---

## Improve Service Recovery Documentation

### Goal

Make rebuilding the environment easier.

### Tasks

Document:

- Initial deployment
- Backup restoration
- Credential recovery
- Service migration
- Hardware replacement scenarios

---

# Low Priority

Useful improvements that can wait until core functionality stabilizes.

## Model Cleanup Guidance

### Goal

Help users manage disk usage.

### Areas

- Old base models
- Experimental model downloads
- Specialist role cleanup

### Tasks

- Document cleanup commands
- Explain storage consumption
- Provide safe removal examples

---

## GitHub Actions Hardening

### Goal

Improve supply-chain security.

### Tasks

- Review Actions usage
- Pin reviewed commit SHAs
- Document update process

---

## Documentation Refinement

### Goal

Improve readability and onboarding.

### Ideas

- Add architecture diagrams
- Add screenshots
- Add troubleshooting guides
- Add FAQ section
- Add deployment examples

---

# Future Research

These topics are exploratory and may significantly alter future project direction.

## Larger Models

Evaluate:

- 27B models
- 35B coding models
- High-VRAM deployments
- Multi-GPU capable workloads

Areas of interest:

- Inference speed
- Memory behavior
- Practical usefulness

---

## Multi-GPU Behavior

Explore:

- Layer distribution
- Performance impact
- Real-world VRAM utilization
- Model placement strategies

This project currently assumes practical constraints rather than idealized hardware scaling.

---

## Alternative Runtimes

Potential evaluation targets:

- llama.cpp
- vLLM
- SGLang
- Future local inference runtimes

Evaluation criteria:

- Stability
- Deployment complexity
- Resource requirements
- Model compatibility

---

## Reverse Proxy Architecture

Potential future investigation:

- Caddy
- Nginx
- Traefik

Goals:

- Unified authentication
- TLS termination
- Cleaner service exposure
- Simplified remote access

---

## Offline-First Operation

Research opportunities:

- Self-hosted fonts
- Local static assets
- Reduced external dependencies
- Fully offline deployment

---

## Model Evaluation Framework

Create a repeatable process for evaluating:

- Accuracy
- Response quality
- Speed
- Memory usage
- Resource efficiency

Potential outputs:

- Benchmark notes
- Recommendation tables
- Hardware sizing guidance

---

# Security Review Checklist

Before declaring the project ready for broader use, confirm:

- [ ] Ollama remains bound to loopback
- [ ] Open WebUI requires authentication
- [ ] n8n requires authentication
- [ ] Paperclip requires authentication
- [ ] Secrets are excluded from Git
- [ ] Backups are documented
- [ ] Restore procedures are tested
- [ ] Network exposure is documented
- [ ] GitHub Pages publishes only approved files
- [ ] Router port forwarding remains disabled unless intentionally required
- [ ] Service updates follow a documented process

---

# Performance Validation Checklist

Before expanding model size:

- [ ] Verify both GPUs are detected
- [ ] Verify driver installation
- [ ] Run 8B smoke test
- [ ] Measure GPU utilization
- [ ] Measure RAM utilization
- [ ] Measure temperatures
- [ ] Measure response speed
- [ ] Validate system stability
- [ ] Verify storage usage
- [ ] Document observations

---

# Deployment Milestones

## Milestone 1 – Foundation

- [ ] Ubuntu deployment completed
- [ ] NVIDIA drivers installed
- [ ] Ollama installed
- [ ] 8B smoke test completed

---

## Milestone 2 – User Interface

- [ ] Open WebUI deployed
- [ ] Authentication configured
- [ ] Persistent storage configured
- [ ] Backup process documented

---

## Milestone 3 – Remote Access

- [ ] Tailscale deployed
- [ ] Access policies reviewed
- [ ] Remote access validated

---

## Milestone 4 – Automation

- [ ] n8n deployed
- [ ] Encryption key secured
- [ ] Workflow testing completed

---

## Milestone 5 – Task Management

- [ ] Paperclip deployed
- [ ] Version pinned
- [ ] Authentication validated

---

## Milestone 6 – Specialist Models

- [ ] Base models downloaded
- [ ] Specialist roles created
- [ ] Performance documented

---

## Milestone 7 – Publication

- [ ] GitHub Pages allowlist implemented
- [ ] Documentation reviewed
- [ ] Public artifact validated

---

# Long-Term Vision

The long-term goal is to build a practical, secure, and well-documented AI home lab that demonstrates how local AI models, automation workflows, and supporting infrastructure can operate together on modest hardware.

The project is intended to remain:

- Educational
- Reproducible
- Security-conscious
- Adaptable
- Open to experimentation

Success is defined not by running the largest available model, but by building a system that is understandable, maintainable, and useful in day-to-day home-lab scenarios.