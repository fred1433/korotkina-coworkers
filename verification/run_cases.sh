#!/bin/zsh
# Runs every case in verification/cases with ONLY the plugin ZIP given as $1, in a clean context:
# empty working directory, no CLAUDE.md, no memory, no user settings, no MCP servers, no bundled skills,
# and the Skill tool as the only tool. Claude subscription (OAuth), no API key.
# Usage: verification/run_cases.sh dist/korotkina-coworkers-plugin.zip [model]
set -e
ZIP="${1:A}"; MODEL="${2:-sonnet}"
HERE="${0:A:h}"; OUT="$HERE/records"; WORK="$(mktemp -d)"
mkdir -p "$OUT"
for f in "$HERE"/cases/*.json; do
  id="${f:t:r}"
  prompt="$(python3 -c 'import json,sys;print(json.load(open(sys.argv[1]))["prompt"])' "$f")"
  (cd "$WORK" && CLAUDE_CODE_DISABLE_CLAUDE_MDS=1 CLAUDE_CODE_DISABLE_AUTO_MEMORY=1 CLAUDE_CODE_DISABLE_BUNDLED_SKILLS=1 \
    ~/.local/bin/claude -p --setting-sources "" --strict-mcp-config --no-session-persistence \
    --tools Skill --plugin-dir "$ZIP" --model "$MODEL" --output-format stream-json --verbose "$prompt") > "$OUT/$id.jsonl"
  python3 "$HERE/make_record.py" "$f" "$OUT/$id.jsonl" "$ZIP" > "$OUT/$id.json"
  echo "$id done"
done
