---
name: z-wordpress-mcp
description: Manage authorized WordPress sites through the approved MCP and 1Password workflow. Use for live site reads or changes, not general WordPress advice.
---

# Z WordPress MCP

Use the approved wrapper for every WordPress MCP request:

```bash
/home/node/.openclaw/skills/z-wordpress-mcp/scripts/wp-mcp-1password
```

Do not place bearer tokens in commands, chat, notes, configuration, memory, files, or logs. Do not call 1Password directly outside the wrapper.

## 1. Confirm the Request

- Identify the WordPress domain, requested outcome, and allowed action.
- Use this skill only for work on an authorized live site through WordPress MCP.
- Do not use it for general WordPress advice, local theme or plugin coding, browser-only work, or a site the requester is not authorized to manage.
- Treat “review,” “check,” and “diagnose” as read-only. Treat “draft” as permission to save a draft, not publish it.

## 2. Discover the Site Tools

Run discovery before the first action on a site in the current task or whenever the available tools may have changed:

```bash
/home/node/.openclaw/skills/z-wordpress-mcp/scripts/wp-mcp-1password discover example.com
```

Read the returned tool names and schemas. Choose only a discovered tool whose purpose and arguments match the request. Do not invent a tool, field, endpoint, or identifier.

## 3. Classify the Action

- **Read:** inspect posts, pages, media, taxonomies, SEO data, analytics, or site state.
- **Reversible write:** create or update a draft or make another change with a clear recovery path.
- **Production-impacting:** publish, delete, change users or permissions, install or remove software, change settings, or perform a broad update.

Proceed only within the user’s authorization. Obtain explicit confirmation immediately before a production-impacting action when that exact action was not already clearly requested.

## 4. Call the Selected Tool

Pass valid JSON arguments to the wrapper:

```bash
/home/node/.openclaw/skills/z-wordpress-mcp/scripts/wp-mcp-1password call example.com wp_get_posts '{"per_page":5}'
```

- Use the narrowest tool and scope that can complete the job.
- Preserve existing content, metadata, status, and identifiers unless the request requires a change.
- Avoid unrelated cleanup or improvements.
- Stop after one failed write attempt unless the cause is clear and a safe correction is available.

## 5. Verify and Report

- After a write, use an independent read to confirm the saved object, status, URL or ID, and requested fields.
- Do not claim completion from a successful HTTP response alone.
- Report what changed, what was verified, and any remaining limit.
- Never include bearer tokens, 1Password service-account details, or credential-file contents.

## Site Onboarding

A site is ready only when the dedicated `wordpress-mcp` 1Password vault contains an item named `wp-mcp-key-<domain-with-dashes>` with:

- the bearer token in `credential`;
- the site root URL in `url`.

Do not add per-site environment variables or restart agents for normal onboarding. The wrapper derives the standard v2 and v1 MCP endpoints from the stored URL and checks them without printing the token.

## Stop Conditions

Stop and report the safe blocker when:

- the domain or requested action is unclear;
- authorization is missing or conflicts with the requested operation;
- the site item, URL, token, wrapper, or required dependency is unavailable;
- the stored URL does not match the requested domain;
- neither standard MCP endpoint succeeds;
- the required tool or field is not present in discovery;
- verification fails or the returned state conflicts with the request;
- a new destructive, public, security, financial, or client-impacting decision appears.

The dedicated service-account workflow grants access only to the `wordpress-mcp` vault. It is not permission to inspect or use any other 1Password vault.
