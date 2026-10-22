# Hermes Agent Deployment Checklist

## Purpose

This checklist provides a repeatable process for deploying, validating, updating, and troubleshooting the Hermes Agent ecosystem.

Use this checklist whenever:

- Performing an initial deployment
- Updating prompts
- Adding new agents
- Changing base models
- Recovering from a failure
- Migrating systems

---

# Phase 1 - Repository Validation

Verify repository structure.

## Documentation

- [ ] README.md present
- [ ] TEMPLATE.md present
- [ ] DEPLOYMENT.md present
- [ ] Agents.txt archived

Verify:

```bash
ls -lah
```

---

## Documentation Directory

Verify:

```bash
ls -lah Documentation/
```

Expected:

```text
17 Hermes documentation files
```

Checklist:

- [ ] hermes-ai.md
- [ ] hermes-archivist.md
- [ ] hermes-backup.md
- [ ] hermes-boss.md
- [ ] hermes-chaos.md
- [ ] hermes-codewright.md
- [ ] hermes-gate.md
- [ ] hermes-hw.md
- [ ] hermes-iot.md
- [ ] hermes-jarvis.md
- [ ] hermes-media.md
- [ ] hermes-mentor.md
- [ ] hermes-monitor.md
- [ ] hermes-net.md
- [ ] hermes-security.md
- [ ] hermes-virt.md
- [ ] hermes-wiki.md

---

## Prompt Directory

Verify:

```bash
ls -lah Prompts/
```

Checklist:

- [ ] Prompts directory exists
- [ ] Prompt files generated
- [ ] Prompt count equals agent count

---

# Phase 2 - Prompt Extraction

## Run Extraction

Generate prompt files.

```bash
python3 extract_prompts.py
```

Expected:

```text
Generated : 17
Failed    : 0
```

Checklist:

- [ ] Extraction completed
- [ ] No extraction failures

---

## Validate Prompt Files

Verify:

```bash
find Prompts -type f | wc -l
```

Expected:

```text
17
```

Checklist:

- [ ] Prompt count matches agent count

---

## Validate Prompt Quality

Inspect a sample:

```bash
cat Prompts/hermes-security.prompt
```

Checklist:

- [ ] Prompt contains expected persona
- [ ] Prompt is not empty
- [ ] Prompt is readable
- [ ] Prompt has no markdown artifacts

---

# Phase 3 - Model Mapping Validation

Verify file exists:

```bash
cat model_mapping.json
```

Validate JSON:

```bash
jq . model_mapping.json
```

Expected:

```text
Valid JSON
```

Checklist:

- [ ] JSON syntax valid
- [ ] Every agent exists in mapping
- [ ] Model assignments correct
- [ ] Context values present
- [ ] Temperature values present

---

## Verify Agent Coverage

Documentation:

```bash
ls Documentation/*.md |*wc -l
```

Mappings*

```bash
jq '*eys | length' model_mapping.json*```

Expected:

```text
17
*7
```

Checklist:

* [ ] Documentation count matches m*pping count

*--

# Phase 4 - Ollama Validation
**# Verify Ollama

Check*service:

```bash
systemctl status*ollama*```

Verify API:

```bash
*url http://127.0.0.1:11434/api/tags
```

Checklist*

- [ ] Ollama running
- [*] API responding
- [ ] No*errors in logs

---

## Verify*Base Models

List models:

```bash*oll*ma list
```

Expected base models:*
-*[ ] qwen3:14b
-*[ ] qwen2.5-coder:*4b

If missing*

```bash
ollama pull qwen3*14b
ollama pull qwen2*5-coder:14b
```

*--

# Phase 5 - Deploy Hermes Agen*s

*# Execute Deployment

Run*

```bash
bash deploy_hermes_agent**sh
```

Expected:

```text
Deploym*nt Complete
```

*hecklist*

- [ ] Deployment started
- [ ] D*ployment*completed
- [ ] No deployment fail*res*
---

## Verify Agent Count

List *ermes agents*

```bash
ollama list | grep herm*s
```

Count:

```bash
oll*ma list | grep hermes | wc -l*```

Expected:

```text
17
*``

Checklist:

- [ ] 17 Hermes*models present

---

# Phase * - Functional Testing*
## Router Validation

Run:

```*ash
ollama run hermes-boss
*``

Prompt:

```text
I*need help designing VLANs.
```

*xpected:

References Hermes*Net.

Checklist:

- [ ] Router beh*ves correctly*
---

## Security Validation

Run:*
```bash*ollama run hermes-security
```

*rompt:

```text
Should I expose Ol**ma to the internet?
```

*xpected:

Security-focused respons*.

Checklist:

- [*] Security persona active

---

##*AI Validation*
Run:

```bash
ollama run herm*s-ai
```

Prompt:

```text
*ecommend a local AI architecture.
*``

Checklist:

* [ ] AI persona active

---

## Ba*kup*Validation

Run:

```bash
ollama r*n*hermes-backup
```

Prompt:

```*ext
Review my backup strategy.
```*
Checklist*

- [ ] Backup persona active

---*
##*Documentation Validation

Run:

``*bash
ollama*run hermes-wiki
```

Prompt:

*``text
Help document my hom*lab.
```

Checklist:

- [ * Documentation persona active

---*
# Phase 7 -*Full Validation*
## Verify All Agents

Run:

*``bash
ollama list | grep hermes*```

Confirm all exist:

- [*] hermes-ai
- [ ] herm*s-archivist
- [ ] herm*s-backup
- [ ] hermes-b*ss
- [ ] hermes-chaos
* [ ] hermes-codewright
- [*] hermes-gate
- [ ] herm*s-hw
- [ ] hermes-i*t
- [ ] hermes-jarvis*- [ ] hermes-media
- [*] hermes-mentor
- [ ] herm*s-monitor
- [ ] hermes-net
**[ ] hermes-security
- [ ] hermes-v*rt
- [ ] hermes*wiki

---

# Phase 8 - Post*Deployment

*# Documentation

-*[ ] Deployment notes recorded
- [ * Change*log updated
- [ * Version history updated

---

## *ackup

Backup*

```text
Documentation*
Prompts/
model_mapping.json
extra*t*prompts.py
deploy_hermes_agents.sh*```

Checklist:

- [ ] Backup comp*eted*
---

# Upgrade Procedure

When*updating an agent:

1. Edit docume*tation*file
2. Update System*Prompt
3. Run extraction
4. Verify*prompts
5. Redeploy
6. Test*agent
7. Update change log

Checkl*st*

- [ ] Documentation updated
- [ * Prompt regenerated
- [ ] Deployme*t successful*- [ ] Validation successful

---

* Emergency*Recovery

If the Hermes deployment*is lost:

## Rebuild*
Verify*

```bash
ollama list
```

*estore:

```bash
git*clone RE*OSITORY
```

Generate*prompts:

```bash
python3 extract_*rompts*py
```

Deploy agents:

```bash
*ash deploy_hermes_agents.sh
```

*alidate:

```bash
ollama list | gr*p hermes
```

Checklist:

- [ ] Pr*mpts restored
- [ ] Agents deploye*
- [ ] Functional testing passed

*--

# Final Acceptance

## Infrast*ucture

- [ ] Repository validated*- [ ] Prompts generated
- [ ] Mapp*ng validated

## Deployment

- [ ]*Agents deployed
- [ ] Agent count *erified

## Validation

- [ ] Rout*r tested
- [ ] Specialist agents t*sted
- [ ] Responses verified*
## Documentation

- [ ] Change*log updated
- [ ] Deployment docum*nted

---

* Deployment Record*
Date:

```text
________________*________
```

Operator:

```text
_*______________*________
```

Version:

```text
__*_____________*________
```

Notes:

```text
____*__________________________________*_____________

___________________*_________________________________
*__________________________________*__________________
```

Deployment*Result:

- [ ] Successful*- [ ] Successful With W*rnings
- [ ] Failed
- [ * Requires Further Testing*