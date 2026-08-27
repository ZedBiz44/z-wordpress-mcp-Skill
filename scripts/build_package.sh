#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skill_name="$(sed -n 's/^name: *//p' "$root_dir/SKILL.md" | head -n 1 | xargs)"
package_dir="$root_dir/dist/$skill_name"

[[ -n "$skill_name" ]] || { printf 'ERROR: Skill name is missing.\n' >&2; exit 1; }
rm -rf "$package_dir"
mkdir -p "$package_dir"
cp "$root_dir/SKILL.md" "$package_dir/SKILL.md"

while IFS= read -r resource || [[ -n "$resource" ]]; do
  resource="${resource%%#*}"
  resource="$(printf '%s' "$resource" | xargs)"
  [[ -z "$resource" ]] && continue
  case "$resource" in
    agents|scripts) cp -a "$root_dir/$resource" "$package_dir/$resource" ;;
    *) printf "ERROR: Unsupported runtime resource: %s\n" "$resource" >&2; exit 1 ;;
  esac
done <"$root_dir/package-resources.txt"

printf 'Built deployable package: %s\n' "$package_dir"
