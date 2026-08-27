#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script="$repo_dir/scripts/wp-mcp-1password"
test_dir="$(mktemp -d)"
trap 'rm -rf "$test_dir"' EXIT

bash -n "$script"
mkdir -p "$test_dir/state/credentials/onepassword" "$test_dir/bin"
printf 'fake-service-account-token' >"$test_dir/state/credentials/onepassword/service-account-token"

printf '%s\n' '#!/usr/bin/env bash' "printf '%s\\n' '{\"fields\":[{\"label\":\"url\",\"value\":\"https://example.com\"},{\"label\":\"credential\",\"value\":\"test-bearer\"}]}'" >"$test_dir/bin/op"
printf '%s\n' '#!/usr/bin/env bash' "printf '%s\\n' '{\"jsonrpc\":\"2.0\",\"result\":{\"tools\":[]}}'" >"$test_dir/bin/curl"
chmod +x "$test_dir/bin/op" "$test_dir/bin/curl"

output="$(PATH="$test_dir/bin:$PATH" OPENCLAW_STATE_DIR="$test_dir/state" CLAW_1PASSWORD_OP="$test_dir/bin/op" "$script" discover example.com)"
jq -e '.response.result.tools == []' <<<"$output" >/dev/null

if PATH="$test_dir/bin:$PATH" OPENCLAW_STATE_DIR="$test_dir/state" CLAW_1PASSWORD_OP="$test_dir/bin/op" "$script" discover wrong.example >/dev/null 2>&1; then
  printf 'ERROR: Mismatched stored domain was accepted.\n' >&2
  exit 1
fi

printf 'Wrapper tests passed.\n'
