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
Priority | Finding|Recommended action
------- | -------------------------
High | .github/workflows/pages.yml uploads the repository root with path: .|Build a dedicated Pages artifact from an explicit allowlist. Include the site and only the project files intended for public download. Exclude .github, credentials, local state, and files marked obsolete.
High|Blueprint.txt contains outdated and unsafe instructions, including OLLAMA_HOST=0.0.0.0	|Remove it, or label it prominently as archived and unsafe. Do not link to it as setup guidance or publish it as an active project document.
High|automation/compose.yaml uses network_mode: host|Prefer a dedicated container network and a narrowly scoped Ollama access path. If host networking is retained, explain that it removes container network isolation and require review of every imported or modified workflow.
High|n8n uses a moving stable image tag|Pin a tested n8n image version. Upgrade deliberately after backup and testing, rather than silently following a moving tag.
High|Paperclip uses paperclipai@latest|Pin a specific tested version at or above v2026.416.0. Do not use an older version or a floating latest tag for a network-accessible service.
High|Access requirements are not met consistently by the current bindings|Define and test the intended LAN and tailnet access path for each service. Keep authentication enabled, restrict firewall access, and avoid public internet exposure.
Medium|setup_ollama.sh replaces /etc/systemd/system/ollama.service.d/override.conf|Back up an existing override before replacing it; ideally merge required settings or stop with a clear prompt if the file already exists.
Medium|.gitignore excludes only automation/.env|Ignore likely credential files and local state, and add a secret-scanning check. .gitignore does not protect files already tracked or secrets in Git history.
Medium|Agents.txt is stale and contains malformed shell quoting|Do not run it. Replace it with a generated role listing or label it as obsolete. Use setup_models.sh as the current source of role names and prompts.
Medium|14B model defaults may exceed practical GPU memory or be slow|Begin with the documented 8B smoke test. Measure memory, placement, temperature, and response time before pulling both 14B bases.
Medium|Open WebUI is a required service but is not installed by a repository script|Add a version-pinned Compose service and document authentication, persistent storage, network access to Ollama, backup, and upgrades.
Medium|UI keyboard access and focus handling need improvement|Add visible focus styles, preserve a visible focus indicator for the search field, and improve mobile-menu Escape handling, focus placement, and focus return. Test filtering and copy controls with keyboard-only navigation and a screen reader.
Medium|The page depends on Google Fonts and Unsplash assets|Keep local font/system fallbacks, and consider self-hosting assets or providing a fully local visual fallback for offline use.
Lower|README and index.html present setup in different sequences and with different access details|Maintain one canonical deployment sequence and derive or cross-check both documents against it.
Lower|setup_models.sh does not remove old model variants|Document how to inspect disk usage and safely remove unused models. Do not delete models automatically without confirmation.
Lower|GitHub Actions use version tags such as @v4|Pin third-party Actions to reviewed full commit SHAs and update them through a documented process.


