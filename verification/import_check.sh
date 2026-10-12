#!/bin/zsh
# Checks the three files downloaded from the live page, exactly as downloaded (verification/import/downloaded/).
# 1) archive shape, 2) Claude Code plugin validation, 3) Agent Skills validation (skills-ref, path in $SKILLS_REF),
# 4) loading in Claude Code in a clean context and checking which skill Claude invokes.
setopt pipefail
HERE="${0:A:h}"; D="$HERE/import/downloaded"; LOG="$HERE/import/import-check-log.md"; W="$(mktemp -d)"
CC=(env CLAUDE_CODE_DISABLE_CLAUDE_MDS=1 CLAUDE_CODE_DISABLE_AUTO_MEMORY=1 CLAUDE_CODE_DISABLE_BUNDLED_SKILLS=1 ~/.local/bin/claude -p --strict-mcp-config --no-session-persistence --tools Skill --model sonnet --output-format stream-json --verbose)
prompt() { python3 -c 'import json,sys;print(json.load(open(sys.argv[1]))["prompt"])' "$HERE/cases/$1.json"; }
summ() { python3 - "$1" <<'PY'
import json,sys
ev=[json.loads(l) for l in open(sys.argv[1])]
i=next(e for e in ev if e.get("subtype")=="init"); r=next(e for e in ev if e.get("type")=="result")
calls=[c["input"].get("skill") for e in ev if e.get("type")=="assistant" for c in e["message"]["content"] if c.get("type")=="tool_use" and c.get("name")=="Skill"]
print("- Claude Code", i.get("claude_code_version"), "| model", i.get("model"), "| auth: subscription, apiKeySource", i.get("apiKeySource"))
print("- skills in context:", ", ".join(s for s in i["skills"] if "inquir" in s))
print("- skill invoked by Claude:", calls)
print("- output:\n\n```markdown\n"+(r.get("result") or "")+"\n```")
PY
}
{
echo "# Import check of the files downloaded from the live page"
echo; echo "Run on $(date -u +%Y-%m-%dT%H:%M:%SZ) by \`verification/import_check.sh\`. Files: \`verification/import/downloaded/\`."
echo; echo "## 1. Archive shape and checksums"; echo; echo '```'
for z in "$D"/*.zip; do shasum -a 256 "$z" | sed "s|$D/||"; unzip -Z1 "$z" | sed 's/^/    /'; done
echo '```'
echo; echo "## 2. Claude Code plugin validation of page-korotkina-coworkers-plugin.zip (unzipped as is)"; echo
mkdir -p "$W/plug" && unzip -q "$D/page-korotkina-coworkers-plugin.zip" -d "$W/plug"
echo '```'; (cd "$W/plug" && ~/.local/bin/claude plugin validate korotkina-coworkers 2>&1 | sed "s|$W|<tmp>|g"); echo '```'
echo; echo "## 3. Agent Skills validation (skills-ref) of the skill ZIPs"; echo
for z in page-original-custom-heirloom-inquiries.zip page-edited-shorter-no-note-custom-heirloom-inquiries.zip; do
  mkdir -p "$W/${z%.zip}" && unzip -q "$D/$z" -d "$W/${z%.zip}"
  echo "- $z: \`$("$SKILLS_REF" validate "$W/${z%.zip}/custom-heirloom-inquiries" 2>&1 | sed "s|$W/||g")\`"
done
echo; echo "## 4a. Plugin ZIP loaded as downloaded (--plugin-dir <zip>), case 03 (urgent resize)"; echo
mkdir -p "$W/run1" && (cd "$W/run1" && $CC --setting-sources "" --plugin-dir "$D/page-korotkina-coworkers-plugin.zip" "$(prompt 03-urgent-guarantee)" </dev/null > "$W/r1.jsonl"); summ "$W/r1.jsonl"
echo; echo "## 4b. Original skill ZIP from the page, unzipped into a project's .claude/skills, case 01"; echo
mkdir -p "$W/run2/.claude/skills" && unzip -q "$D/page-original-custom-heirloom-inquiries.zip" -d "$W/run2/.claude/skills" && (cd "$W/run2" && $CC --setting-sources project "$(prompt 01-heirloom-ordinary)" </dev/null > "$W/r2.jsonl"); summ "$W/r2.jsonl"
echo; echo "## 4c. Edited skill ZIP from the page (Shorter, note left out), same case 01"; echo
mkdir -p "$W/run3/.claude/skills" && unzip -q "$D/page-edited-shorter-no-note-custom-heirloom-inquiries.zip" -d "$W/run3/.claude/skills" && (cd "$W/run3" && $CC --setting-sources project "$(prompt 01-heirloom-ordinary)" </dev/null > "$W/r3.jsonl"); summ "$W/r3.jsonl"
echo; echo "## Not checked here"; echo
echo "- Upload in Claude Desktop (Customize > Plugins or Skills): not driven from this machine."
echo "- Any run on Amazon Bedrock: no AWS account was used."
} > "$LOG" 2>&1
echo "written $LOG"
