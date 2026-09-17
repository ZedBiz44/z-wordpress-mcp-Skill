# Bounded correction verification

Owner: Cody. Reviewer and merge/install decision: Jack. Status: implemented candidate; not installed or deployed.

Scope excludes production WordPress writes, deployment, new providers, consolidation, storage migration and skill retirement. Rollback before merge is closing the PR; existing installations remain unchanged. After a future authorized installation, restore the previous approved package if the pilot fails.

Base: 7f0a1dc920622fb913f24691281dbf474a424f82. Branch: cody/prevent-uncertain-write-replay; target: main.

Endpoint selection now uses read-only discovery. A tool call is submitted once, never replayed against another endpoint. Invalid JSON, wrong response ID, JSON-RPC errors and MCP isError results fail without reporting completion. Unknown tools are rejected before submission. After an uncertain write, instructions require independent state inspection before deciding on a retry.

Validation: 13 isolated shell scenarios passed using mock curl/op and fake credentials: discovery, successful call, v1 discovery fallback, completed mutation with response lost, HTTP error, JSON-RPC error, tool error, malformed JSON, wrong response ID, unavailable endpoints, unknown tool, domain mismatch and invalid arguments. Each call-failure scenario recorded exactly one simulated mutation and no fallback tool call. Fake secrets were absent from stdout/stderr. Bash syntax passed. ZedBiz repository and native package validators passed. Built package contains 4 source-matching files (see manifest).

Security review: credential retrieval and domain binding preserved; curl still receives the token through its private temporary header file. Read-only discovery can fall back; mutation cannot. Errors no longer print arbitrary malformed response bodies. No real credentials, website requests or production state were used in the tests. Live runtime loading, service compatibility and real write/read-back remain untested and require a separately authorized pilot.

