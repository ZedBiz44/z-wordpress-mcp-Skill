# Z WordPress MCP Pilot and Trigger-Test Record

Date: 2026-08-27 | Tester: Cody | Status: Victor and Wilma Deployment Approved

## Artifact and Environment

- Skill: `z-wordpress-mcp`
- Repository: https://github.com/ZedBiz44/z-wordpress-mcp-Skill
- Tested commit: `6e06094c1d0553ba06d85254ab8047547cc239e7`
- Package: `dist/z-wordpress-mcp`
- Platform: ZedBiz VPS1 OpenClaw
- Pilot agent and site: Wilma and `zedbiz.com`
- Second deployment target: Victor
- Installation: `/home/node/.openclaw/skills/z-wordpress-mcp`

## Discovery Checks

| Check | Expected result | Actual result |
|---|---|---|
| Install current package | Installed files match the tested commit | Passed on Wilma and Victor; package checksums matched |
| Skill discovery | `z-wordpress-mcp` appears with the correct description | Passed in fresh sessions on both agents |
| Old skill discovery | `wordpress-mcp` is absent | Passed on both agents |
| Wrapper discovery | Tools list returns without exposing a token | Passed on Wilma; MCP v2 returned 24 tools |
| Missing prerequisite | Stop without another credential route | Passed on Victor; missing `/usr/local/bin/op` produced a safe stop |

## Controlled Pilot

Wilma completed a fresh OpenClaw read-only pilot:

- `z-wordpress-mcp` was model-visible and selected.
- The wrapper discovered 24 tools from the `zedbiz.com` MCP v2 endpoint.
- No write tool was called.
- No credential was printed or stored.
- OpenClaw reported zero tool failures.

Victor completed a fresh safe-stop test:

- `z-wordpress-mcp` was model-visible and selected.
- The approved 1Password CLI prerequisite was unavailable.
- The wrapper exited 127.
- Victor did not try another credential route and made no site change.

A production draft was not created because the rollout assignment did not authorize test content on a live site.

## Rollback Test and Cleanup

- Restored Wilma's prior `wordpress-mcp` folder temporarily.
- Confirmed the old skill was discoverable and its read-only wrapper reached the same 24-tool endpoint.
- Restored `z-wordpress-mcp` and repeated the successful read-only discovery.
- The old wrapper reproduced `response_file: unbound variable`; the new wrapper did not.
- After rollback proof passed, Jack authorized deletion of the old live skill and active GitHub source.
- Removed the old skill and hidden rollback folders from Victor and Wilma.
- Deleted `skills/wordpress-mcp` from the active `main` branch of `ZedBiz-openclaw-ai-agents-vps1-vps2`.
- Verified both agents report `wordpress-mcp` as not found and remain healthy.

## Evidence

- Rollout issue: https://github.com/ZedBiz44/z-wordpress-mcp-Skill/issues/1
- Old wrapper deletion commit: https://github.com/ZedBiz44/ZedBiz-openclaw-ai-agents-vps1-vps2/commit/32e66e846d0359e532cef1e68d2fba714d1847b0
- Old skill deletion commit: https://github.com/ZedBiz44/ZedBiz-openclaw-ai-agents-vps1-vps2/commit/4a80926239c96deeeb1957f720f7cc9263c47492
- Installed `SKILL.md` SHA-256: `7d3e4fcb319d85a6b1783d28a2d0652467044801b9c60d802b1680f02506f978`
- Installed wrapper SHA-256: `08a4ec977986982cfb9cd290674d2590c49474c52011803712c201eb65e5baf1`

## Sign-Off

- Tester: Cody
- Reviewer: Cody
- Approver: Jack, through the explicit rollout and deletion instruction
- Decision: approved and complete for Victor and Wilma
