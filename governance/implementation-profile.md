# Z WordPress MCP Implementation Profile

Date: 2026-08-27 | Prepared by: Cody | Status: Release Candidate

## Identity and Ownership

- Skill display name: Z WordPress MCP
- Canonical identifier: `z-wordpress-mcp`
- Owner and publisher: ZedBiz
- Repository: https://github.com/ZedBiz44/z-wordpress-mcp-Skill
- Authoritative branch: `main`
- Migration source: `skills/wordpress-mcp` in `ZedBiz-openclaw-ai-agents-vps1-vps2`
- License and attribution: ZedBiz-owned migration; no third-party skill identity is being replaced.

## Purpose and Scope

- Primary job: safely complete authorized live WordPress reads and changes through MCP.
- Intended users: approved ZedBiz AI agents operating on authorized WordPress sites.
- Positive triggers: requests to inspect or change a named WordPress site through MCP.
- Negative triggers: general advice, local code development, browser-only work, or an unauthorized site.
- Included actions: discovered WordPress MCP reads and explicitly authorized writes.
- Excluded actions: direct token handling, direct 1Password access, guessed MCP calls, and unrelated changes.

## Platform and Packaging

- Supported platform: OpenClaw on the ZedBiz agent environment.
- Runtime package: `dist/z-wordpress-mcp`.
- Target installation path: `/home/node/.openclaw/skills/z-wordpress-mcp`.
- Runtime resources: `SKILL.md`, `agents/`, and `scripts/`.
- Repository validator: current `z-ai-skill-developer/scripts/validate_skill.py` in repository mode.
- Package validator: the same validator in package mode.

## Controls and Approval

- Risk tier: Fleet/Public because the skill uses credentials and can change live sites or publish content.
- Default mode: read-only unless a write is clearly authorized.
- Human approver: ZedBiz business owner or delegated task owner.
- Pilot: one approved OpenClaw testing agent and one non-destructive site task.
- Wider rollout: only after repository validation, wrapper tests, package validation, trigger tests, and pilot pass.
- Stop rule: stop after one failed write or when authorization, discovery, endpoint, or verification is unclear.

## Security and Rollback

- Security review: `governance/security-rollback-review.md`.
- Approved credentials: dedicated `wordpress-mcp` 1Password vault through the wrapper only.
- Last known-good source: the existing `wordpress-mcp` folder in the VPS repository.
- Rollback: remove or replace the pilot package and restore the prior skill folder and reference.
- Rollback owner: ZedBiz technical administrator.

## Completion Evidence

- Structural validation: repository and deployable package passed the current `z-ai-skill-developer` validator on 2026-08-27.
- Wrapper test: mocked discovery and wrong-domain rejection passed on 2026-08-27.
- Trigger record: `governance/pilot-trigger-test-record.md`.
- Pilot result: pending.
- GitHub rollout record: https://github.com/ZedBiz44/z-wordpress-mcp-Skill/issues/1
- Notion SOP: https://app.notion.com/p/3c9a3e33d58181a281b3ef41284c727b
- Final approval: required before wider rollout.
