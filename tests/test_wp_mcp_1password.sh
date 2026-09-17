#!/usr/bin/env bash
set -euo pipefail
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script="$repo_dir/scripts/wp-mcp-1password"
test_dir="$(mktemp -d)"
trap 'rm -rf "$test_dir"' EXIT
bash -n "$script"
mkdir -p "$test_dir/state/credentials/onepassword" "$test_dir/bin"
printf 'fake-service-account-token' >"$test_dir/state/credentials/onepassword/service-account-token"
cat >"$test_dir/bin/op" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' '{"fields":[{"label":"url","value":"https://example.com"},{"label":"credential","value":"test-bearer"}]}'
MOCK
cat >"$test_dir/bin/curl" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
endpoint=""; payload=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --request) endpoint="$3"; shift 3 ;;
    --data-binary) payload="$2"; shift 2 ;;
    *) shift ;;
  esac
done
method="$(jq -r '.method' <<<"$payload")"
printf '%s %s\n' "$method" "$endpoint" >>"$MOCK_LOG"
if [[ "$method" == tools/list ]]; then
  if [[ "$MOCK_MODE" == no_endpoint || ( "$MOCK_MODE" == fallback && "$endpoint" == */v2/http ) ]]; then exit 22; fi
  printf '%s\n' '{"jsonrpc":"2.0","id":1,"result":{"tools":[{"name":"wp_create_post","inputSchema":{"type":"object"}}]}}'
  exit 0
fi
printf 'created-post\n' >>"$MOCK_MUTATIONS"
case "$MOCK_MODE" in
  lost_response) exit 28 ;;
  http_error) exit 22 ;;
  rpc_error) printf '%s\n' '{"jsonrpc":"2.0","id":1,"error":{"code":-32603,"message":"failed"}}' ;;
  tool_error) printf '%s\n' '{"jsonrpc":"2.0","id":1,"result":{"isError":true}}' ;;
  malformed) printf 'not-json' ;;
  wrong_id) printf '%s\n' '{"jsonrpc":"2.0","id":2,"result":{}}' ;;
  *) printf '%s\n' '{"jsonrpc":"2.0","id":1,"result":{"content":[{"type":"text","text":"created"}]}}' ;;
esac
MOCK
chmod +x "$test_dir/bin/op" "$test_dir/bin/curl"
export PATH="$test_dir/bin:$PATH"
export OPENCLAW_STATE_DIR="$test_dir/state" CLAW_1PASSWORD_OP="$test_dir/bin/op"
export MOCK_LOG="$test_dir/requests" MOCK_MUTATIONS="$test_dir/mutations"
run_case() {
  export MOCK_MODE="$1"; local expected="$2" expected_calls="$3"; shift 3
  : >"$MOCK_LOG"; : >"$MOCK_MUTATIONS"
  local status=0
  bash "$script" "$@" >"$test_dir/out" 2>"$test_dir/err" || status=$?
  if [[ "$expected" == success ]]; then [[ "$status" -eq 0 ]]; else [[ "$status" -ne 0 ]]; fi
  [[ "$(wc -l <"$MOCK_MUTATIONS" | tr -d ' ')" -eq "$expected_calls" ]]
  ! grep -Eq 'test-bearer|fake-service-account-token' "$test_dir/out" "$test_dir/err"
  if [[ "$expected_calls" -eq 1 ]]; then
    [[ "$(grep -c '^tools/call ' "$MOCK_LOG")" -eq 1 ]]
  fi
}
run_case happy success 0 discover example.com
jq -e '.response.result.tools[0].name == "wp_create_post"' "$test_dir/out" >/dev/null
run_case happy success 1 call example.com wp_create_post '{}'
run_case fallback success 1 call example.com wp_create_post '{}'
[[ "$(grep -c '^tools/list ' "$MOCK_LOG")" -eq 2 ]]
grep -q '^tools/call .*/v1/http$' "$MOCK_LOG"
for mode in lost_response http_error rpc_error tool_error malformed wrong_id; do
  run_case "$mode" failure 1 call example.com wp_create_post '{}'
  [[ "$(wc -l <"$MOCK_LOG" | tr -d ' ')" -eq 2 ]]
  grep -q 'not retried' "$test_dir/err"
done
run_case no_endpoint failure 0 call example.com wp_create_post '{}'
run_case happy failure 0 call example.com missing_tool '{}'
run_case happy failure 0 discover wrong.example
[[ ! -s "$MOCK_LOG" ]]
run_case happy failure 0 call example.com wp_create_post 'invalid-json'
[[ ! -s "$MOCK_LOG" ]]
printf 'PASS: 13 isolated wrapper scenarios; lost-response mutation count = 1; no automatic replay; fake secrets absent.\n'
