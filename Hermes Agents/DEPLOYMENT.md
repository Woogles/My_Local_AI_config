# Hermes Agent Deployment

## Purpose

This document describes how Hermes Agents are converted from documentation into deployable Ollama models.

Hermes follows a documentation-first workflow.

The agent documentation is the authoritative source.

---

# Deployment Pipeline

```text
Documentation
    ↓
extract_prompts.py
    ↓
Prompt Files
    ↓
model_mapping.json
    ↓
deploy_hermes_agents.sh
    ↓
Ollama Models
```

---

# Directory Structure

```text
Hermes Agents/
│
├── Documentation/
├── Prompts/
│
├── model_mapping.json
├── extract_prompts.py
├── deploy_hermes_agents.sh
│
├── README.md
├── TEMPLATE.md
└── Agents.txt
```

---

# Step 1 - Maintain Documentation

Each agent exists as:

```text
Documentation/hermes-*.md
```

Example*

```text
Documentation/hermes-sec*rity.md
*``

The authoritative*prompt lives inside:

```markdown*## System Prompt
```

section*

---

# Step 2 - Generate Prompt *iles*
Run:

```bash
python3 extract_pro**ts.py
```

Expected:

```text
*enerated : 17
Failed : 0
*``

Output:

```text
Prom*ts/
├── hermes-security.prompt
├*─ hermes-net.prompt
├── ...
*``

---

# Step 3 - Validate Prom*ts

Verify:

```bash
ls Prom*ts
```

Expected*

```text
17 prompt files
```

*nspect:

```bash
cat Prom*ts/hermes-security.prompt
```

---*
#*Step 4 - Validate Model Mapping

V*rify:

*``bash
cat model_mapping.json
```
**alidate:

```bash
jq . model_mappi*g.json
```

Confirm:

- Model*assignment
- Context size
* Temperature
- Categories

---

# *tep 5 - Deploy Agents

Run:

```ba*h
bash deploy_hermes_agents.sh
``*

The deployment process*

1. Loads mapping configuration
2**Reads prompt files
3. Generates Mo*elfiles*4. Creates Ollama models
5.*Verifies deployment

---

# Verify*Deployment

List Hermes models:

`*`bash*ollama list | grep hermes
``*

Expected:

```text*17 models
```

---

# Test Deploym*nt*
Example:

```bash
oll*ma run hermes-ai
```

Prompt:

*``text
Recommend a local AI archit*cture.
*``

Verify persona alignment.

---*
# Updating*An Agent

Edit*

```text
Documentation/hermes-*.m**```

Update:

```markdown*## System Prompt
```

Then regener*te:

*``bash
python3 extract_prompts.py
*``

Redeploy:

```bash
*ash deploy_hermes_agents.sh
```

*--

# Adding A*New Agent

1. Copy TEMPLATE*md
2. Create new agent file
3* Add System Prompt
4.*Run extraction*5. Update model_mapping.json
6* Deploy
7. Validate*
---

# Removing*An Agent

1. Remove*documentation file
2. Remove promp* file
3* Remove model mapping
*. Delete model*
Example:

```bash
ollama rm herme*-example*```

---

# Release Process*
Recommended workflow:

```text
Up*ate*Agent
    ↓
Update*Documentation
    ↓
Extract*Prompts
    ↓
Validate Prom*ts
    ↓
Deploy*    ↓
Test
    ↓
Commit*   *↓
Push
```

---

# Design*Principles

Hermes follows*

- Documentation First*- Single Source of Truth
-*Automated Deployment
- Repro*ucible Builds
- Model*Agnostic Design

Agent*documentation should always be tre*ted as authoritative*

Prompt files and deployed models*are generated artifacts*

