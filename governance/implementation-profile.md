# Z WordPress MCP Implementation Profile

Date: 2026-08-27 | Prepared by: Cody | Status: Deployed to Victor and Wilma

## Identity and Ownership

- Skill display name: Z WordPress MCP
- Canonical identifier: `z-wordpress-mcp`
- Owner and publisher: ZedBiz
- Repository: https://github.com/ZedBiz44/z-wordpress-mcp-Skill
- Authoritative branch: `main`
- Migration source: retired `skills/wordpress-mcp` folder from `ZedBiz-openclaw-ai-agents-vps1-vps2`
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
- Package validator: current `z-ai-skill-developer/scripts/validate_skill.py`.

## Controls and Approval

- Risk tier: Fleet/Public because the skill uses credentials and can change live sites or publish content.
- Default mode: read-only unless a write is clearly authorized.
- Human approver: ZedBiz business owner or delegated task owner.
- Pilot: Wilma completed one non-destructive live-site task.
- Approved deployment: Victor and Wilma.
- Stop rule: stop after one failed write or when authorization, discovery, endpoint, or verification is unclear.

## Security and Rollback

- Security review: `governance/security-rollback-review.md`.
- Approved credentials: dedicated `wordpress-mcp` 1Password vault through the wrapper only.
- Current known-good source: commit `6e06094c1d0553ba06d85254ab8047547cc239e7`.
- Rollback proof: passed on Wilma before the prior skill was retired.
- Current rollback: reinstall the exact tested package from the immutable repository commit.
- Rollback owner: ZedBiz technical administrator.

## Completion Evidence

- Structural validation: deployable package passed the current `z-ai-skill-developer` validator on 2026-08-27.
- Wrapper test: mocked discovery and wrong-domain rejection passed on 2026-08-27.
- Live pilot: Wilma discovered 24 tools through MCP v2 with no write and no credential exposure.
- Victor boundary: safe stop passed when the approved 1Password CLI was unavailable.
- Rollback: prior skill restore and return to `z-wordpress-mcp` passed on Wilma.
- Trigger and pilot record: `governance/pilot-trigger-test-record.md`.
- GitHub rollout record: https://github.com/ZedBiz44/z-wordpress-mcp-Skill/issues/1
- Notion SOP: https://app.notion.com/p/3c9a3e33d58181a281b3ef41284c727b
- Approval: Jack explicitly approved the Victor and Wilma replacement and old-skill deletion.
