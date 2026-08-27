# Z WordPress MCP

This repository is the technical source of truth for `z-wordpress-mcp`. The Skill lets an authorized AI agent read and manage live WordPress sites through the approved MCP wrapper while retrieving each site token on demand from the dedicated 1Password vault.

## When to Use This Skill

Use this Skill when a task requires a live read or authorized change on a WordPress site through MCP. Examples include reviewing content, creating drafts, updating pages, publishing approved content, managing media or taxonomy, and checking supported site data.

Do not use it for general WordPress advice, local theme or plugin development, browser-only work, or any site the requester is not authorized to manage.

## Authoritative Files

`SKILL.md` is the authoritative runtime guide. The Notion SOP is the business-facing operating procedure.

- `SKILL.md` defines triggers, authorization boundaries, workflow, and completion checks.
- `scripts/wp-mcp-1password` is the approved credential and MCP request wrapper.
- `agents/openai.yaml` contains supported interface metadata.
- `governance/` holds the implementation, security, rollback, trigger-test, and pilot records.
- `tests/` holds repository tests and is not part of the runtime package.

## Validate and Build

Validate this repository with the validator from `z-ai-skill-developer`, then run the local script test and build the deployable package:

```bash
python3 <z-ai-skill-developer-root>/scripts/validate_skill.py --repository .
bash tests/test_wp_mcp_1password.sh
bash scripts/build_package.sh
python3 <z-ai-skill-developer-root>/scripts/validate_skill.py dist/z-wordpress-mcp
```

The package is created at `dist/z-wordpress-mcp`. Pilot it on one approved OpenClaw agent before wider rollout.

## Safety and Approval Boundaries

Never store secrets, WordPress bearer tokens, or 1Password service-account tokens in this repository, chat, notes, logs, or configuration. The wrapper may access only the dedicated `wordpress-mcp` vault.

Live publication, deletion, user or permission changes, software installation or removal, settings changes, and broad production updates require clear user authorization. Every write must be verified with a separate read before completion is reported.

## Release Status

This repository is a release candidate until its governance review and controlled OpenClaw pilot are completed. The prior `wordpress-mcp` source remains the last known-good version until the pilot passes.
