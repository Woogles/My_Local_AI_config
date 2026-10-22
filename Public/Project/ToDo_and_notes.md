# Executive summary

The current README and setup scripts are safer and more consistent than the older Blueprint.txt: the maintained Ollama script binds its API to loopback, and the n8n Compose file currently binds its editor to loopback. However, the deployment still needs work before it meets the stated access and publication goals:

1. Replace the Pages root upload with an allowlisted publication directory. The workflow uploads .. That makes ordinary repository files—not just the website—eligible for publication. Since publishing project files is intentional, publish a curated set instead of the whole checkout.
2. Do not use Blueprint.txt as installation instructions. It contains obsolete setup directions, including binding Ollama to 0.0.0.0. Archive it as clearly unsafe historical material or remove it.
3. Keep Ollama’s API on loopback. Do not expose port 11434 directly to the LAN or tailnet. Open WebUI and n8n need deliberate, narrowly scoped paths to reach it.
4. Require authentication for Open WebUI and Paperclip. A LAN or tailnet address is not a substitute for application authentication. Paperclip’s current tailnet bind does not, by itself, meet a requirement that Paperclip also be reachable from the LAN.
5. Replace n8n host networking with a reviewed network design, or document why it is retained. Host networking makes workflow nodes more consequential: inspect imported workflows and treat them as code with access to the host network.
6. Pin moving software versions. setup_n8n.sh creates an .env with N8N_VERSION=stable; setup_paperclip.sh invokes paperclipai@latest. Pin tested versions, and keep Paperclip at v2026.416.0 or higher.
7. Reconcile the remaining documentation and deployment gaps. Open WebUI has no setup script or Compose service in the repository; the README and web page describe different setup sequences and access details.


# Priority recommendations
# Priority recommendations

Priority  | Finding  | Recommended action
-------   |  ------   | ------- 
High  | .github/workflows/pages.yml uploads the repository root with path: .  | Build a dedicated Pages artifact from an explicit allowlist. Include the site and only the project files intended for public download. Exclude .github, credentials, local state, and files marked obsolete.
High  | Blueprint.txt contains outdated and unsafe instructions, including OLLAMA_HOST=0.0.0.0	  | Remove it, or label it prominently as archived and unsafe. Do not link to it as setup guidance or publish it as an active project document.
High  | automation/compose.yaml uses network_mode: host  | Prefer a dedicated container network and a narrowly scoped Ollama access path. If host networking is retained, explain that it removes container network isolation and require review of every imported or modified workflow.
High  | n8n uses a moving stable image tag  | Pin a tested n8n image version. Upgrade deliberately after backup and testing, rather than silently following a moving tag.
High  | Paperclip uses paperclipai@latest  | Pin a specific tested version at or above v2026.416.0. Do not use an older version or a floating latest tag for a network-accessible service.
High  | Access requirements are not met consistently by the current bindings  | Define and test the intended LAN and tailnet access path for each service. Keep authentication enabled, restrict firewall access, and avoid public internet exposure.
Medium  | setup_ollama.sh replaces /etc/systemd/system/ollama.service.d/override.conf  | Back up an existing override before replacing it; ideally merge required settings or stop with a clear prompt if the file already exists.
Medium  | .gitignore excludes only automation/.env  | Ignore likely credential files and local state, and add a secret-scanning check. .gitignore does not protect files already tracked or secrets in Git history.
Medium  | Agents.txt is stale and contains malformed shell quoting  | Do not run it. Replace it with a generated role listing or label it as obsolete. Use setup_models.sh as the current source of role names and prompts.
Medium  | 14B model defaults may exceed practical GPU memory or be slow  | Begin with the documented 8B smoke test. Measure memory, placement, temperature, and response time before pulling both 14B bases.
Medium  | Open WebUI is a required service but is not installed by a repository script  | Add a version-pinned Compose service and document authentication, persistent storage, network access to Ollama, backup, and upgrades.
Medium  | UI keyboard access and focus handling need improvement  | Add visible focus styles, preserve a visible focus indicator for the search field, and improve mobile-menu Escape handling, focus placement, and focus return. Test filtering and copy controls with keyboard-only navigation and a screen reader.
Medium  | The page depends on Google Fonts and Unsplash assets  | Keep local font/system fallbacks, and consider self-hosting assets or providing a fully local visual fallback for offline use.
Lower  | README and index.html present setup in different sequences and with different access details  | Maintain one canonical deployment sequence and derive or cross-check both documents against it.
Lower  | setup_models.sh does not remove old model variants  | Document how to inspect disk usage and safely remove unused models. Do not delete models automatically without confirmation.
Lower  | GitHub Actions use version tags such as @v4  | Pin third-party Actions to reviewed full commit SHAs and update them through a documented process.

# Network and access plan

Use this as the target policy, then confirm the unresolved access questions below.

Service  | Recommended exposure  | Authentication and notes
-------- | --------------------  | ------------------------
Ollama  | Loopback only, 127.0.0.1:11434  | Do not expose the API directly to LAN, tailnet, or the internet. Container access must use a deliberately designed path; do not “fix” connectivity by binding Ollama to all interfaces.
Open WebUI  | LAN and tailnet through a controlled listener or reverse proxy  | Enable authentication before LAN access. Persist and back up WebUI data. Do not expose it publicly without a separately reviewed public-access design.
n8n  | Loopback behind a TLS-enabled reverse proxy reachable on the intended LAN and tailnet interfaces  | Keep n8n authenticated. Configure proxy and webhook settings deliberately. Do not enable public webhook ingress unless it is required and separately secured.
Paperclip  | Private, authenticated access; current script selects tailnet binding  | Tailnet binding is not LAN access. To serve both LAN and tailnet, use a carefully secured listener or proxy and firewall policy; do not assume the current script provides both.
GitHub Pages  | Public website and allowlisted project files  | Treat every published file as public. Publish only reviewed files, and never rely on .gitignore as a Pages security control.

A TLS reverse proxy can provide a consistent authenticated entry point for n8n and, if selected, other web interfaces. The exact proxy, certificate, DNS, and firewall configuration depends on the answers to the access questions below. Keep router port forwarding disabled unless a separate, explicit public-access requirement is approved.


# Hardware and model guidance

The two GPUs have separate VRAM pools; the system does not provide a simple, interchangeable 20 GB pool. Ollama may distribute model layers across GPUs in some configurations, but actual placement, performance, and compatibility must be measured on this host.

With 32 GB system RAM and a 12 GB RTX 3060, a 14B model at the script’s 4096-token context may run with reduced GPU placement, use system RAM, or perform too slowly for the intended use. The GTX 1070 may help in some model-placement configurations, but it does not guarantee that both 14B defaults will fit or perform well. Leave memory for the operating system, desktop, service containers, context cache, and runtime overhead.

# Recommended sequence:

1. Verify the machine, GPUs, driver, thermals, storage, and PSU cabling before installing or loading models.
2. Run nvidia-smi and confirm that both GPUs appear correctly.
3. Run bash setup_ollama.sh, then test the README’s smaller qwen3:8b smoke test.
4. Observe actual GPU and RAM use while testing representative prompts. Record response speed and whether the model is split across GPUs or offloaded to RAM.
5. Only then test the 14B defaults in setup_models.sh. If performance or memory is unacceptable, select smaller model tags through GENERAL_MODEL and CODER_MODEL.
6. Keep Ollama’s one-loaded-model and one-parallel-request limits until measured results justify changing them.

The two reported 500 GB drives provide about 1 TB nominal capacity in total, but the usable free space, exact drive models, mount points, filesystem, and intended data layout are unknown. Before downloading models, decide where Ollama model data, container volumes, Paperclip state, backups, and system files should live. Check free space on the actual target filesystem; do not assume the model cache will land on the intended drive.
Recommended deployment sequence

The existing README and web page provide different sequences. Use this sequence as the single proposed order, and update both documents to match it.

1. Resolve hardware and access questions. Verify the exact workstation, CPU, PSU, GPU power cables, drive models, and network trust boundaries.
2. Prepare Ubuntu 22.04. Update the OS, install the appropriate NVIDIA driver, reboot, and confirm both GPUs with nvidia-smi.
3. Review scripts before running them. In particular, back up any existing Ollama service override before running setup_ollama.sh. The Ollama and Tailscale scripts use downloaded installer scripts; review the source and changes before executing them.
4. Install Ollama and run the small smoke test. Keep the API on loopback.
5. Add Open WebUI. Create a version-pinned deployment with persistent storage and authentication. Document the chosen secure connection from the container to loopback-only Ollama.
6. Add Tailscale. Authorize the workstation and confirm that only intended tailnet devices or users can reach the services.
7. Deploy n8n. Pin the image version, generate and protect its encryption key, and decide the network design before importing workflows. Put the user interface behind a TLS-enabled reverse proxy if LAN and tailnet browser access is required.
8. Deploy Paperclip. Use a pinned version at or above v2026.416.0. Confirm its authentication and decide how it will be made reachable from both LAN and tailnet, if both are required.
9. Create specialist models. Run setup_models.sh only after the smaller model test, and record the exact base-model tags and observed performance.
10. Enable Pages publication last. Publish from an allowlisted directory, review the resulting artifact, and confirm that the intended files—and only those files—are public.


# File-by-file review

File or group  | Review notes and recommended follow-up
-------------- | --------------------------------------
README.md  | Documents loopback-only Ollama and the small-model-first approach. It describes Open WebUI, n8n, and Paperclip as optional even though all are required here. Update the sequence, access requirements, and service status; make clear that Open WebUI still needs a deployment definition.
.github/workflows/pages.yml  | Deploys on pushes to main and uploads .. Replace the root artifact with a curated publication directory and review the built artifact. The current action references are version tags, not immutable commit SHAs.
.gitignore  | Ignores only automation/.env. Expand protections for local credential/config files and generated state, while remembering that ignore rules do not remove tracked files or erase Git history.
Blueprint.txt  | Historical instructions conflict with the maintained configuration and include unsafe all-interface Ollama binding. Do not execute or treat as current guidance.
Agents.txt  | Does not match the maintained role names or model setup. Its education prompt has malformed quoting, and the file calls create_agent without defining it. Do not execute.
Model_Reccomendations.md  | Separate notes, not used by the setup script. Verify the model tags, commands, runtime assumptions, and suggested settings against the exact installed versions before treating them as operational instructions. Consider correcting the filename typo when updating it.
setup_ollama.sh  | Configures loopback binding and limits parallel/model loading, which are appropriate conservative defaults. It overwrites the service override without preserving an existing file. Add backup or merge behavior and document how to restore the prior configuration.
setup_models.sh  | Pulls the configured general and coding bases and creates 17 prompt variants. The variants are not separately trained models. It does not reclaim disk space from older model variants; inspect models before removing them.
setup_n8n.sh  | Generates an encryption key for automation/.env and starts Compose. It sets N8N_VERSION=stable, so deployments can change unexpectedly. Pin a tested image version and ensure the env file is backed up securely; losing the encryption key can make saved credentials unusable.
automation/compose.yaml  | Uses host networking and loopback binding. This enables the sample workflow’s 127.0.0.1 Ollama call, but workflows share host networking. Review all workflow nodes and imported files; prefer a dedicated network if a safe Ollama access path can be provided.
automation/workflows/local-assistant-smoke-test.json  | The included workflow is inactive and sends a fixed test prompt to local Ollama. Treat imported or edited workflows as executable automation: inspect URLs, credentials, code nodes, file access, and any outbound requests before activation.
setup_paperclip.sh  | Requires a connected tailnet and runs as a regular user, but installs paperclipai@latest. Pin the package to a reviewed version at or above v2026.416.0. The script selects tailnet binding; this does not establish LAN reachability.
setup_tailscale.sh  | Installs and starts Tailscale, then prompts for authorization. Confirm the tailnet identity and access policy; do not treat membership in the tailnet as a substitute for application authentication.
index.html  | Gives a detailed static overview and identifies the 17 prompt-based roles. The page’s setup flow and access wording need to match the final README. It references external Google Fonts and Unsplash images, which may fail offline.
styles.css  | Includes reduced-motion support and responsive layouts. Add explicit :focus-visible styling and avoid suppressing the search field’s outline without an equally visible replacement. Test contrast and focus visibility across backgrounds and components.
script.js  | Handles filtering, copying, and mobile navigation. Improve mobile-menu keyboard behavior: manage focus on open/close, support Escape, and return focus to the menu button. Ensure filtering updates remain understandable to assistive technology and provide a genuine copy fallback if clipboard access is unavailable.

# GitHub Pages publication

The publication preference is to make both the website and project files available through GitHub Pages. That is compatible with a public repository, but it should be an explicit allowlist rather than publishing the checkout root.

Recommended layout:
```
public/
  index.html
  styles.css
  script.js
  project/
    README.md
    setup_models.sh
    setup_n8n.sh
    setup_ollama.sh
    setup_paperclip.sh
    setup_tailscale.sh
    automation/
      compose.yaml
      workflows/
        local-assistant-smoke-test.json
    Model_Reccomendations.md
```

Update the Pages workflow to build or copy only those approved files into the artifact. Before enabling or changing deployment, inspect the artifact contents and test the published file paths. If a secret has ever been committed, removing it from the latest commit is not sufficient: revoke or rotate it and address the repository history.
# Security and operational gotchas

* LAN is not automatically trusted. Decide whether “anyone on the local network” includes guest Wi-Fi, IoT devices, or other untrusted devices. Prefer firewall rules for a trusted subnet or VLAN and retain application authentication.
* Tailscale access is a separate boundary. Decide which tailnet users/devices are authorized. Use tailnet access controls rather than assuming every tailnet member should have access to every service.
* Do not expose Ollama as a convenience. A direct unauthenticated API on a reachable interface would give network clients access to model operations. Keep it loopback-only and design the container connection deliberately.
* Host-networked workflows can reach host services. Review every imported workflow before running it, including its HTTP destinations, code nodes, credentials, and filesystem-related nodes. Keep workflow credentials out of Git.
* Back up application state, not just scripts. Protect n8n’s encryption key alongside its data, and decide which Open WebUI and Paperclip state must be recoverable. Test restoration.
* Pin and update intentionally. Pin container images and npm packages, record the tested versions, and schedule reviewed upgrades. A pinned version still needs security updates.
* Model variants consume storage. Prompt-created variants may share base layers, but old base tags and prior downloads can remain. Check actual disk usage before cleaning up.
* Model fit is workload-dependent. Context length, model quantization, runtime overhead, GPU placement, and other active applications all affect memory and speed. A model pulling successfully does not prove it will run acceptably.
* Keep a rollback path. Back up service configuration before changing systemd overrides, networking, proxy settings, or persistent app data.

Review acceptance checklist

- [ ] Verify both GPUs and the NVIDIA driver after reboot.
- [ ] Run the 8B smoke test and record actual memory use and response speed.
- [ ] Keep Ollama bound to loopback.
- [ ] Add authenticated, version-pinned Open WebUI deployment and persistent storage.
- [ ] Decide and document the LAN and tailnet access policy for each service.
- [ ] Pin n8n and Paperclip versions; keep Paperclip at v2026.416.0 or higher.
- [ ] Review the n8n networking design and every workflow before activation.
- [ ] Back up service configuration and application data, including the n8n encryption key.
- [ ] Replace root-directory Pages upload with a reviewed allowlist.
- [ ] Update README and index.html to use the same installation order and access details.
- [ ] Test keyboard navigation, focus visibility, mobile-menu behavior, and offline fallbacks.
